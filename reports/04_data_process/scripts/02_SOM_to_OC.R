## clean up data compiled from datasets 
## prior to soil C modelling 
# contact Tania Maxwell, tlgm2@cam.ac.uk
# 16.11.22

rm(list=ls()) # clear the workspace
library(tidyverse)
library(ggpmisc) # for lm equation and R2 on graph
library(nimble) #for the nls function
library(propagate) #to predic nls
library(modelr)

input_file01 <- "reports/04_data_process/data/data_cleaned.csv"

data0<- read.csv(input_file01)

str(data0)


#### 1. background info ######

#19,282 observations with SOM instead of OC
test <-data0 %>% 
  filter(is.na(OC_perc_combined) == TRUE & is.na(SOM_perc_combined) == FALSE)

table(test$Source)

test1 <- data0 %>% 
  filter(Source == "CCRCN" & Original_source == "Piazza et al 2011") %>% 
  filter(is.na(OC_perc_combined) == FALSE & is.na(SOM_perc_combined) == FALSE)
table(test1$Original_source)


# 4025 observations with both SOM and OC

data_SOM_OC <-data0 %>% 
  filter(is.na(Conv_factor) == TRUE) %>% 
  filter(is.na(OC_perc_combined) == FALSE & is.na(SOM_perc_combined) == FALSE
         & Method == "EA") %>% 
  mutate(OC_perc_combined = case_when(Source == "Graversen et al 2022" ~ OC_perc_combined/10,
                                      TRUE ~ OC_perc_combined)) %>% 
  mutate(Source_country = paste(Original_source, Country)) %>% 
  filter(Original_source != "Elsey Quirk et al 2011")  ##issue with this study (seems SOM or OC was interpreted)


table(data_SOM_OC$Country)
table(data_SOM_OC$Original_source)

table(data_SOM_OC$Source)

## Plot different slopes

SOM_OC_observed <- ggplot(data_SOM_OC, aes(x = SOM_perc_combined, y = OC_perc_combined))+
  theme_bw()+
  stat_poly_line()+
  stat_poly_eq(aes(label = paste(after_stat(eq.label),
                                 after_stat(rr.label), sep = "*\", \"*")))+
  geom_point()+
  facet_wrap(~Source_country)

SOM_OC_observed




#### 2. all data: linear model ####

SOM_OC_linear <- ggplot(data_SOM_OC, aes(x = SOM_perc_combined, y = OC_perc_combined))+
  theme_bw()+
  stat_poly_line()+
  stat_poly_eq(aes(label = paste(after_stat(eq.label),
                                 after_stat(rr.label), sep = "*\", \"*")))+
  geom_point(aes(color = Source)) 
SOM_OC_linear

linear_model <- lm(OC_perc_combined ~ SOM_perc_combined, data = data_SOM_OC)
summary(linear_model)



#### 3. all data: quadratic model ####

#similar to Holmquist et al 2018

SOM_to_OC <- function(x, a, b, c) {
  (a*(x^2)) + (b*x) + c
}

## use the start values for the model from sanderman paper
quadratic_model <- nls(OC_perc_combined ~ SOM_to_OC(SOM_perc_combined, a, b, c), 
                  data=data_SOM_OC, 
                  start=list(a=0.074, b=0.0421, c=-0.0080))
summary(quadratic_model)

## extract the coefficient values from the model summary
a_est <- summary(quadratic_model)[['coefficients']][[1]]
b_est <- summary(quadratic_model)[['coefficients']][[2]]
c_est <- summary(quadratic_model)[['coefficients']][[3]]

a_std <- summary(quadratic_model)[['coefficients']][[1,2]]
b_std <- summary(quadratic_model)[['coefficients']][[2,2]]
c_std <- summary(quadratic_model)[['coefficients']][[3,2]]


#### calculating fitted values 
#calculated the predicted values at the random x values with the coefficient 
#and full function

xOC2 = seq(from = 0.01, to = 100, 
           length.out = 100)


fitted_values <- SOM_to_OC(xOC2, a_est, b_est, c_est)

plot(data_SOM_OC$SOM_perc_combined, data_SOM_OC$OC_perc_combined)

fitted_df <- as.data.frame(cbind(xOC2, fitted_values))
lines(xOC2, fitted_values, col="red")


# eq_label <- expression("OC =" ~~ bquote(a_est ~ "±" ~ a_std)~"OM"^2 ~~ "+" ~~ 
#                          (b_est ~ "±" ~ b_std)~"OM" ~~ "-" ~~ 
#                          ((c_est*-1)~"±"~c_std))

SOM_to_OC_quadratic <- ggplot(data_SOM_OC, aes(x = SOM_perc_combined, y = OC_perc_combined))+
  geom_point(aes(color = Source), size = 0.75)+
  theme_bw()+
  labs(x = "SOM (%)", y = "OC (%)")+
  geom_line(data = fitted_df, aes(x = xOC2, y =fitted_values), col = "blue", size = 1) 
  #annotate(geom="text", x=20, y=50, label= , color="blue")
  

# OLD"OC =(0.0005123±0.0000983) OM^2 + (0.4225±0.006726)OM - 0.5428±0.08799" 

SOM_to_OC_quadratic

quadratic_resitudals <- plot(residuals(quadratic_model))





### calculation prediction intervals for the predictions 
predictions <- predictNLS(quadratic_model, newdata = data.frame(SOM_perc_combined = xOC2),
                          interval="pred")
predictions$summary


modelr::rsquare(quadratic_model, data_SOM_OC)


### comparing linear to full quadratic 
AIC(linear_model, quadratic_model)



#### 4. figure exports ####
export_fig <- SOM_to_OC_quadratic
fig_main_name <- "SOM_to_OC_quadratic"

path_out = 'reports/04_data_process/figures/'
fig_name <- paste(Sys.Date(),fig_main_name, sep = "_")
export_file <- paste(path_out, fig_name, ".png", sep = '') 
ggsave(export_file, export_fig, width = 14.86, height = 8.46)


#### 5. errors #####
# looks like Graversen data is in per mille, and not percent? 
#i.e. test divided by 10

data_SOM_OC_grav <- data_SOM_OC %>% 
  mutate(OC_perc_corr = case_when(Original_source == "Graversen et al 2022" ~ OC_perc_combined/10,
                                  TRUE ~ OC_perc_combined)) %>% 
  relocate(OC_perc_corr, .before = OC_perc_combined) %>% 
  filter(Original_source == "Graversen et al 2022" | Original_source == "Ruranska et al 2020"
         | Original_source == "Ruranska et al 2022" | Original_source == "Burden et al 2018")


## to send to Graversen 

Grav_SOM_OC_observed <- ggplot(data_SOM_OC_grav, aes(x = SOM_perc_combined, y = OC_perc))+
  geom_point()+
  labs(x = "Soil organic matter (%)", y = "Organic carbon (%)")+
  facet_wrap(~Source_country)

Grav_SOM_OC_observed


#### 6. conversion factors used ######
table(data0$Conv_factor)

data_conv_factors <- data0 %>% 
  filter(is.na(Conv_factor) == FALSE) %>% 
  group_by(Source, Country, Original_source) %>% 
  dplyr::count(Conv_factor) 

library(gridExtra)
png("reports/04_data_process/figures/conversion_factors.png", height = 50*nrow(data_conv_factors), width = 200*ncol(data_conv_factors))
grid.table(data_conv_factors)
dev.off()


#### 7. compare study SOM conversion factors to ours ####

data_converted <-data0 %>% 
  filter(is.na(Conv_factor) == FALSE &
           is.na(SOM_perc_combined) == FALSE &
           is.na(OC_perc_combined) == FALSE) %>% 
  mutate(OC_perc_from_eq = a_est*(SOM_perc_combined^2) + 
           b_est*SOM_perc_combined + c_est) %>%
  mutate(OC_perc_from_eq = replace(OC_perc_from_eq, which(OC_perc_from_eq<0.00001), NA))%>%
  mutate(OC_calcualted_diff_perc = (OC_perc_from_eq - OC_perc_combined)/OC_perc_combined*100)

hist(data_converted$OC_perc_from_eq)




OC_eq_vs_OC_from_SOM <- ggplot(data_converted, aes(x = OC_perc_combined, y = OC_perc_from_eq))+
  geom_point(size = 0.75, aes(color = Source))+
  theme_bw()+
  labs(x = "OC (%) calculated from SOM from original study's equation",
       y = "OC (%) calculated from our general equation")
OC_eq_vs_OC_from_SOM

OC_calcualted_diff_graph <- ggplot(data_converted, aes(x = Source, y = OC_calcualted_diff_perc))+
  geom_boxplot(aes(color = Source))+
  theme_bw()+
  labs(x = "Source",
       y = "Percent different from OC (%) from SOM with original study's equation to OC calc from SOM with our general equation")
OC_calcualted_diff_graph



#### 8. apply our conversion factor to ones without CFs ####






#### 9. explore OC_perc and SOM_perc data in general

histogram <- data0 %>% 
  filter(is.na(SOM_perc_combined) == FALSE &
         Country != "United States") %>% 
  ggplot(aes(x = SOM_perc_combined)) +
  geom_histogram()+
  theme_bw() +
  facet_wrap(~Country)
  
histogram






#### last. export cleaned and converted data ####

path_out = 'reports/04_data_process/data/'

export_file <- paste(path_out, "data_cleaned_converted.csv", sep = '') 
export_df <- data4

write.csv(export_df, export_file, row.names = F)


