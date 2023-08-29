## for supplementary figure 
rm(list=ls()) # clear the workspace

library(tidyverse)
library(ggpmisc) # for lm equation and R2 on graph
library(nimble) #for the nls function
library(propagate) #to predic nls
library(modelr)
library(merTools) # for predictInterval() function - note: only works for lmerFunction
library(cowplot) #plot_grid
library(grid)
library(gridExtra)

#### import data ####
input_file01 <- "reports/04_data_process/data/data_cleaned_outliersremoved.csv"

# import 
read_data<- read.csv(input_file01) 

#remove outliers for analysis - note: need to add at the end
data0 <-read_data %>% 
  filter(!grepl("Outlier", Notes, ignore.case = TRUE)) 

str(data0)


data_SOM_OC <-data0 %>% 
  filter(is.na(Conv_factor) == TRUE) %>% 
  filter(is.na(OC_perc_combined) == FALSE & is.na(SOM_perc_combined) == FALSE
         & Method == "EA") %>% 
  mutate(Source_country = paste(Original_source, Country)) %>% 
  filter(SOM_perc_combined > OC_perc_combined) %>%  # remove rare cases where OC > SOM %
  filter(OC_perc_combined != 0) # 57 values from Poppe and Rybczyk 2019 have 0 for OC 

## Plot different slopes

SOM_OC_observed <- data_SOM_OC %>% 
  # filter(Source == "CCRCN") %>% 
  ggplot(aes(x = SOM_perc_combined, y = OC_perc_combined))+
  theme_bw()+
  stat_poly_line()+
  stat_poly_eq(aes(label = paste(after_stat(eq.label),
                                 after_stat(rr.label), sep = "*\", \"*")))+
  geom_point()+
  labs(x = "SOM (%)", y = "OC (%)")+
  facet_wrap(~Source_country)

SOM_OC_observed


###### predictions per study ####

## need to run a loop

#quadratic model without the random effect
# at set with intercept to 0
SOM_to_OC_0 <- function(x, a, b) {
  (a*(x^2)) +(b*x)
}


xOC2 = seq(from = 00, to = 120, 
                  length.out = 20)

study <- "Burden et al 2018"

test <- data_SOM_OC %>% 
  filter(Source == "Burden et al 2018" | Source == "Gorham et al 2021" | Source == "CCRCN")

study_test <- SOM_OC_nls(study)


SOM_OC_nls <- function(study){
  df  <- data_SOM_OC %>% 
    filter(Source == study)
  
  ### run the model 
  quadratic_model_0 <- nls(OC_perc_combined ~ SOM_to_OC_0(SOM_perc_combined, a, b), 
                           data=df, 
                           start=list(a=0.074, b=0.421))
  
  ## extract the values
  a_est <- summary(quadratic_model_0)[['coefficients']][[1,1]]
  b_est<- summary(quadratic_model_0)[['coefficients']][[2,1]]
  
  a_std <- summary(quadratic_model_0)[['coefficients']][[1,2]]
  b_std <- summary(quadratic_model_0)[['coefficients']][[2,2]]
  
  ##calculate R2 manually 
  R2 <- 1 - (deviance(quadratic_model_0)/sum((df$OC_perc_combined-mean(df$OC_perc_combined))^2))
  
  #extract n 
  n_samples <- nrow(df)
  
  
  ### build dataset for predicted values for graph
  xOC2 = seq(from = 00, to = (max(df$SOM_perc_combined)), 
             length.out = 10)
  
  fitted_values<- SOM_to_OC_0(xOC2, a_est, b_est)
 # fitted_df <- as.data.frame(cbind(xOC2, fitted_values))
  
  SOM_OC_predict_0 <- predictNLS(quadratic_model_0, 
                                 newdata = data.frame(SOM_perc_combined = xOC2),
                                 interval="pred")
  
  
  predictions <- SOM_OC_predict_0$summary %>% 
    mutate(xOC2 = xOC2,
           fitted_values = fitted_values,
           n_samples = n_samples,
           R2 = R2,
           study = study,
           a_est = a_est,
           b_est = b_est,
           a_std = a_std,
           b_std = b_std)
  return(predictions)
  
}


# predictions <- data.frame()
# for (i in unique(data_SOM_OC$Source)){
#   output = SOM_OC_nls(i)
#   predictions = rbind(predictions, output)
# }

#save RDS 
#saveRDS(predictions, "reports/04_data_process/figures/SOM_to_OC/study_level_SOM_OC.RDS")


###### plot per study ####

predictions <- readRDS("reports/04_data_process/figures/SOM_to_OC/study_level_SOM_OC.RDS") %>% 
  rename(Source = study)

SOM_OC_plot <- function(study){
  
  ## subset the dataset
  df  <- data_SOM_OC %>% 
    filter(Source == study)
  
  df_predictions <- predictions %>% 
    filter(Source == study)
  
  a_est <- df_predictions$a_est[1] # all values are the same
  b_est <- df_predictions$b_est[1] # all values are the same
  R2 <- df_predictions$R2[1] # all values are the same
  n_samples <- df_predictions$n_samples[1] # all values are the same
  
  figure <- ggplot()+ 
    #prediction interval ribbon first - the points will be plotted on top
    geom_ribbon(data = df_predictions, aes(x = xOC2, ymin = `Sim.2.5%`, ymax =`Sim.97.5%`),
                fill = "grey", alpha = 1) +
    geom_point(data = df, aes(x = SOM_perc_combined, y = OC_perc_combined), size = 0.8)+
    theme_bw()+
    ggtitle(study)+
    labs(x = "", y = "")+
    # model with 2.5 and 97.5 % prediction intervals 
    geom_line(data = df_predictions, aes(x = xOC2, y =fitted_values), col = "black", linewidth = 1.5)+
    annotate(geom = "text",  label = paste("OC =", round(a_est,4),"OM^2 +", round(b_est,2), "OM "), 
             size = 3, y = 45, x = 45) +
    annotate(geom = "text",  label = paste(expression(R^2),"=", round(R2,3), 
                                           ", n =", n_samples), 
             size = 3, y = 40, x = 40)+
    theme(plot.title = element_text(hjust = 0.5, size = 12),
      axis.text = element_text(size = 12, color = 'black'),
      plot.margin = unit(c(0,0.5,0,0), "cm")) + # so that 100 doesn't get cut off
    coord_cartesian(ylim = c(0, 50), xlim = c(0,100)) +
    scale_x_continuous(expand = c(0,0))+
    scale_y_continuous(expand = c(0,0))
  return(figure)    
}

SOM_OC_plot(study)

plot_list = list() 
for (i in unique(data_SOM_OC$Source)){
  plot_list[[i]] = SOM_OC_plot(i)
}


plot <- plot_grid(plotlist = plot_list)

#create common x and y labels

y.grob <- textGrob("Soil organic carbon (%)", 
                   gp=gpar(col="black", fontsize=16), rot=90)

x.grob <- textGrob("Soil organic matter (%)", 
                   gp=gpar(col="black", fontsize=16))

#add to plot

final_grid <- grid.arrange(arrangeGrob(plot, left = y.grob, bottom = x.grob))

##### export #####

path_out = 'data_paper/figures/'
export_file <- paste(path_out, "FigS2_study_SOM_OC.png", sep = '')
ggsave(export_file, final_grid, width = 12.93, height = 7.90)


#### comparing models ####
SOM_OC_model <- function(study){
  df  <- data_SOM_OC %>% 
    filter(Source == study)
  
  ### run the model 
  quadratic_model_0 <- nls(OC_perc_combined ~ SOM_to_OC_0(SOM_perc_combined, a, b), 
                           data=df, 
                           start=list(a=0.074, b=0.421))
  return(quadratic_model_0)
}

# note: this model is slightly different to the one from 03_SOM_to_OC
# because that model includes study as a random effect
# but here to compare models they must all the be the same
main_model <- nls(OC_perc_combined ~ SOM_to_OC_0(SOM_perc_combined, a, b), 
                  data=data_SOM_OC, 
                  start=list(a=0.074, b=0.421))


model_list = list() 
for (i in unique(data_SOM_OC$Source)){
  model_list[[i]] = SOM_OC_model(i)
}

test1<- SOM_OC_model(study)
test2 <- SOM_OC_model(study = "CCRCN")
test3 <- SOM_OC_model(study =   "Gorham et al 2021")

Study <- cbind(c("All studies" ,unique(data_SOM_OC$Source)))


anova(main_model, test1, test2, test3)

anova_table0 <- anova(main_model, model_list[[1]], model_list[[2]], 
      model_list[[3]], model_list[[4]], model_list[[5]], model_list[[6]],
      model_list[[7]], model_list[[8]], model_list[[9]], model_list[[10]],
      model_list[[11]], model_list[[12]], model_list[[13]], model_list[[14]],
      model_list[[15]], model_list[[16]], model_list[[17]], model_list[[18]])


options(scipen = 0) # decimals

anova_table = cbind(anova_table0,Study) %>% 
  relocate(Study, .before = Res.Df) %>% 
  mutate(across(where(is.numeric), round, 3)) %>% 
  mutate(p_value_small = case_when(`Pr(>F)` < 0.0001 ~ "<0.0001")) %>% 
  mutate(p_value = coalesce(p_value_small,as.character(`Pr(>F)`))) %>% 
  dplyr::select(-c(`Pr(>F)`,p_value_small))

anova_table

export_file <- paste(path_out, "TableS2_study_SOM_OC.csv", sep = '')
write.csv(anova_table,export_file, row.names = FALSE)

