## clean up data compiled from datasets 
## prior to soil C modelling 
# contact Tania Maxwell, tlgm2@cam.ac.uk
# 16.11.22

rm(list=ls()) # clear the workspace

library(plyr) # for rbind.fill
library(tidyverse)
library(viridis) # for plot
library(ggpmisc) # for lm equation and R2 on graph
library(nimble) #for the nls function
library(propagate) #to predic nls
library(modelr)
library(lme4) #model with random effect
library(MuMIn) # to get R2 from lmer
library(merTools) # for predictInterval() function - note: only works for lmerFunction


#### import data ####
input_file01 <- "reports/04_data_process/data/data_cleaned_outliersremoved.csv"

# import 
read_data<- read.csv(input_file01) 

#remove outliers for analysis - note: need to add at the end
data0 <-read_data %>% 
    filter(!grepl("Outlier", Notes, ignore.case = TRUE)) 

str(data0)

data_unique <- data0 %>% 
  distinct(Latitude, .keep_all = TRUE)

country_table <- table(data_unique$Country)
country_table


data_noCCRCN <- data_unique %>% 
  filter(Source != "CCRCN")

summary(data_noCCRCN$L_depth_m)

data_noCCRCN_upper <- data_noCCRCN %>% 
  filter(L_depth_m <0.3)
#### 1. background info ######

#19,232 observations with SOM instead of OC
test <-data0 %>% 
  filter(is.na(OC_perc_combined) == TRUE & is.na(SOM_perc_combined) == FALSE)

table(test$Source)

test1 <- data0 %>% 
  filter(Source == "CCRCN" & Original_source == "Piazza et al 2011") %>% 
  filter(is.na(OC_perc_combined) == FALSE & is.na(SOM_perc_combined) == FALSE)
table(test1$Original_source)


# 4183 observations with both SOM and OC

data_SOM_OC <-data0 %>% 
  filter(is.na(Conv_factor) == TRUE) %>% 
  filter(is.na(OC_perc_combined) == FALSE & is.na(SOM_perc_combined) == FALSE
         & Method == "EA") %>% 
  mutate(Source_country = paste(Original_source, Country)) %>% 
  filter(SOM_perc_combined > OC_perc_combined) %>%  # remove rare cases where OC > SOM %
  filter(OC_perc_combined != 0) # 57 values from Poppe and Rybczyk 2019 have 0 for OC 
  
n_CCRCN <- data_SOM_OC %>% 
  filter(Source == "CCRCN") 
nrow(n_CCRCN)

n_poppe <- data0 %>% 
  filter(Original_source == "Poppe and Rybczyk 2019")

plot(n_poppe$SOM_perc, n_poppe$OC_perc) # note - the OC values of 0 are removed in the data paper script

n_dataset <- data_SOM_OC %>% 
  filter(Source != "CCRCN") 
nrow(n_dataset)

table(data_SOM_OC$Country)
table(data_SOM_OC$Original_source)
table(data_SOM_OC$Source)

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




#### 2. generic all data models ####

##### 2a. 'lm' linear model ####

SOM_OC_linear <- ggplot(data_SOM_OC, aes(x = SOM_perc_combined, y = OC_perc_combined))+
  theme_bw()+
  stat_poly_line()+
  stat_poly_eq(aes(label = paste(after_stat(eq.label),
                                 after_stat(rr.label), sep = "*\", \"*")))+
  geom_point(aes(color = Source)) 
SOM_OC_linear

linear_model <- lm(OC_perc_combined ~ SOM_perc_combined, data = data_SOM_OC)
summary(linear_model)

## extract the coefficient values from the model summary
lm_intercept <- summary(linear_model)[['coefficients']][[1]]
lm_slope <- summary(linear_model)[['coefficients']][[2]]

lm_intercept_std <- summary(linear_model)[['coefficients']][[1,2]]
lm_slope_std <- summary(linear_model)[['coefficients']][[2,2]]

##### 2a. 'nls' quadratic model ####

#similar to Holmquist et al 2018

SOM_to_OC <- function(x, a, b, c) {
  (a*(x^2)) + (b*x) + c
}

## use the start values for the model from Holmquist paper
quadratic_model <- nls(OC_perc_combined ~ SOM_to_OC(SOM_perc_combined, a, b, c), 
                  data=data_SOM_OC, 
                  start=list(a=0.074, b=0.421, c=-0.0080))
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

xOC2 = seq(from = 0.00, to = 100, 
           length.out = 100)

fitted_values <- SOM_to_OC(xOC2, a_est, b_est, c_est)

fitted_df <- as.data.frame(cbind(xOC2, fitted_values))


# eq_label <- expression("OC =" ~~ bquote(a_est ~ "±" ~ a_std)~"OM"^2 ~~ "+" ~~ 
#                          (b_est ~ "±" ~ b_std)~"OM" ~~ "-" ~~ 
#                          ((c_est*-1)~"±"~c_std))
# 
# SOM_to_OC_quadratic <- ggplot(data_SOM_OC, aes(x = SOM_perc_combined, y = OC_perc_combined))+
#   geom_point(aes(color = Source), size = 0.75)+
#   theme_bw()+
#   labs(x = "SOM (%)", y = "OC (%)")+
#   geom_line(data = fitted_df, aes(x = xOC2, y =fitted_values), col = "blue", size = 1)+ 
#   annotate(geom = "text",  label = paste("OC =", round(a_est,6), "±", round(a_std,6), 
#                                          "OM^2 +", round(b_est,3), "±", round(b_std,3),
#                                              "OM - ", round((c_est*-1),3), "±", round(c_std,3)), 
#            y = 50, x = 30)
# 
# SOM_to_OC_quadratic


#### 3. random effect models ######

# this is to include study ID as a random effect

##### 3a. linear random effect ######

linear_randomeffect <- lmer(OC_perc_combined ~ SOM_perc_combined
                            + (1|Original_source), 
                            data = data_SOM_OC)
summary(linear_randomeffect)

lm_intercept_RE <- summary(linear_randomeffect)[['coefficients']][[1]]
lm_slope_RE <- summary(linear_randomeffect)[['coefficients']][[2]]

lm_intercept_REstd <- summary(linear_randomeffect)[['coefficients']][[1,2]]
lm_slope_RE_std <- summary(linear_randomeffect)[['coefficients']][[2,2]]

##### 3b. quadratic random effect ######

quadratic_randomeffect <- lmer(OC_perc_combined ~ SOM_perc_combined + I(SOM_perc_combined^2)
                           + (1|Original_source), 
                           data = data_SOM_OC)

summary(quadratic_randomeffect)

#for the figure
r2_quad_RE <- r.squaredGLMM(quadratic_randomeffect)[1,2]
dimensions_quad_RE <- summary(quadratic_randomeffect)$devcomp$dims
n_quad_RE <- dimensions_quad_RE[1]


#CAUTION - summary of random effect model has estimates in opposite order
# that those in the equation SOM_to_OC()
a_est_RE <- summary(quadratic_randomeffect)[['coefficients']][[3,1]]
b_est_RE <- summary(quadratic_randomeffect)[['coefficients']][[2,1]]
c_est_RE <- summary(quadratic_randomeffect)[['coefficients']][[1,1]]

a_std_RE <- summary(quadratic_randomeffect)[['coefficients']][[3,2]]
b_std_RE <- summary(quadratic_randomeffect)[['coefficients']][[2,2]]
c_std_RE <- summary(quadratic_randomeffect)[['coefficients']][[1,2]]



### fitted values

fitted_values_randomeffect <- SOM_to_OC(xOC2, a_est, b_est, c_est)
fitted_df_randomeffect <- as.data.frame(cbind(xOC2, fitted_values_randomeffect))

#### model predictions ####
#note, these need to be done on the quadratic model without the random effect

# note: this takes a while to calculate. will just import
# SOM_OC_predict <- predictNLS(quadratic_model, newdata = data.frame(SOM_perc_combined = xOC2),
#                       interval="pred")
# SOM_OC_predict_full <- SOM_OC_predict
# 
# path_out = 'reports/04_data_process/data/'
# export_file <- paste(path_out, "SOM_OC_predict.csv", sep = '')
# export_df <- SOM_OC_predict$summary
# write.csv(export_df, export_file, row.names = F)


SOM_OC_predict <- read.csv("reports/04_data_process/data/SOM_OC_predict.csv") %>% 
  mutate(xOC2 = xOC2)


##### 3c. fixing the intercept to 0 #####

quadratic_randomeffect_0 <- lmer(OC_perc_combined ~ 0 + SOM_perc_combined + 
                                       I(SOM_perc_combined^2)
                               + (1|Original_source), 
                               data = data_SOM_OC)

summary(quadratic_randomeffect_0)


#CAUTION - summary of random effect model has estimates in opposite order
# that those in the equation SOM_to_OC()
a_est_RE0 <- summary(quadratic_randomeffect_0)[['coefficients']][[2,1]]
b_est_RE0 <- summary(quadratic_randomeffect_0)[['coefficients']][[1,1]]

a_std_RE0 <- summary(quadratic_randomeffect_0)[['coefficients']][[1,2]]
b_std_RE0 <- summary(quadratic_randomeffect_0)[['coefficients']][[2,2]]


#for the figure
r2_quad_RE0 <- r.squaredGLMM(quadratic_randomeffect_0)[1,2]
dimensions_quad_RE0 <- summary(quadratic_randomeffect_0)$devcomp$dims
n_quad_RE0 <- dimensions_quad_RE0[1]


###### model predictions ####
#note, these need to be done on the quadratic model without the random effect
# at set with intercept to 0
SOM_to_OC_0 <- function(x, a, b) {
  (a*(x^2)) + (b*x)
}

## use the start values for the model from Holmquist paper
quadratic_model_0 <- nls(OC_perc_combined ~ SOM_to_OC_0(SOM_perc_combined, a, b), 
                       data=data_SOM_OC, 
                       start=list(a=0.074, b=0.421))
summary(quadratic_model_0)



fitted_values_randomeffect_0 <- SOM_to_OC_0(xOC2, a_est_RE0, b_est_RE0)
fitted_df_randomeffect_0 <- as.data.frame(cbind(xOC2, fitted_values_randomeffect_0))


xOC2_extend = seq(from = 0.0, to = 120, 
                       length.out = 80)

# #note: this takes a while to calculate. will just import
# SOM_OC_predict_0 <- predictNLS(quadratic_model_0, newdata = data.frame(SOM_perc_combined = xOC2_extend),
#                       interval="pred")
# 
# path_out = 'reports/04_data_process/data/'
# export_file <- paste(path_out, "SOM_OC_predict_0.csv", sep = '')
# export_df <- SOM_OC_predict_0$summary
# write.csv(export_df, export_file, row.names = F)


SOM_OC_predict_0 <- read.csv("reports/04_data_process/data/SOM_OC_predict_0.csv") %>% 
  mutate(xOC2 = xOC2_extend)


#### 4. compare models and finalize ####
AIC_df <- AIC(linear_model, linear_randomeffect, quadratic_model, quadratic_model_0,
              quadratic_randomeffect, quadratic_randomeffect_0)

AIC_df
# note: we are choosing the random effect model with a fixed intercept at 0 
# this isn't the absolute lowest value, but is very close and makes more sense biologically
# lowest_AIC <- AIC_df %>% 
#   slice(which.min(AIC))
# 
# final_model <- eval(parse(text = rownames(lowest_AIC)))

final_model <- quadratic_randomeffect_0

r.squaredGLMM(final_model)

#Conditional R2 is interpreted as a variance explained by the entire model, 
#including both fixed and random effects, and is calculated according to the equation

#### FINAL GRAPH ####

data_SOM_OC_forgraph <- data_SOM_OC %>% 
  mutate(`Dataset source` = case_when(Source == "CCRCN" ~ "CCRCN",
                                      TRUE ~ "This dataset"))


SOM_to_OC_quadratic_randomeffect <- ggplot()+
  #prediction interval ribbon first - the points will be plotted on top
  geom_ribbon(data = SOM_OC_predict_0, aes(x = xOC2, ymin = Sim.2.5., ymax = Sim.97.5.),
              fill = "grey", alpha = 1) +
  # # sd1 and sd2
  # geom_ribbon(data = SOM_OC_predict, aes(x = xOC2, ymin = (Sim.Mean-Sim.sd),
  #                                        ymax = (Sim.Mean+Sim.sd)),
  #             fill = "purple", alpha = 0.5) +
  
  geom_point(data = data_SOM_OC_forgraph, aes(x = SOM_perc_combined, y = OC_perc_combined, 
                                              color = Source, shape = `Dataset source`), size = 2)+
  theme_bw()+
  labs(x = "Soil organic matter (%)", y = "Soil organic carbon (%)")+
  # model with 2.5 and 97.5 % prediction intervals 
  geom_line(data = fitted_df_randomeffect_0, aes(x = xOC2, y =fitted_values_randomeffect_0), col = "black", size = 1.5)+ 
  
  # # test for prediction equation
  #   geom_line(aes(x = xOC2, y = xOC2^2*(a_est_RE0 + a_std_RE0) + xOC2*(b_est_RE0 + b_std_RE0), 
  #             col = "black", size = 1.5, linetype = "longdash") +
  #   geom_line(aes(x = xOC2, y = xOC2^2*(a_est_RE0 - a_std_RE0) + xOC2*(b_est_RE0 - b_std_RE0),
  #             col = "black", size = 1.5, linetype = "longdash") +
  
  #add equation to graph
  
  #if intercept is not set to 0
  # annotate(geom = "text",  label = paste("OC =", round(a_est_RE,6), "±", round(a_std_RE,6), 
  #                                        "OM^2 +", round(b_est_RE,3), "±", round(b_std_RE,3),
  #                                        "OM - ", round((c_est_RE*-1),2), "±", round(c_std_RE,2)), 
  #          size = 6, y = 45, x = 35) +
  annotate(geom = "text",  label = paste("OC =", round(a_est_RE0,6), "±", round(a_std_RE0,6), 
                                         "OM^2 +", round(b_est_RE0,3), "±", round(b_std_RE0,3),
                                         "OM "), 
           size = 6, y = 45, x = 35) +
  annotate(geom = "text",  label = paste("R2 =", round(r2_quad_RE0,3), 
                                         ", n =", n_quad_RE0), 
           size = 6, y = 40, x = 20) +
  scale_color_viridis(name = "Source", discrete = TRUE, option = "H")+
  # guide = guide_legend(override.aes = list(size = 5,
  #      alpha = 1, shape = 17)))+
  scale_shape_manual(values = c("CCRCN" = 16, "This dataset"=17 ))+
  theme(legend.title = element_text(size = 18),
        legend.text = element_text(size = 16),
        axis.text = element_text(size = 16, color = 'black'),
        axis.title = element_text(size = 18, color = 'black')) +
  coord_cartesian(ylim = c(0, 50), xlim = c(0,100)) +
  scale_x_continuous(expand = c(0,0))+
  scale_y_continuous(expand = c(0,0)) +
  guides(color = guide_legend(override.aes = list(size = 5, shape = 17) ),
         shape = guide_legend(override.aes = list(size = 5, 
                                                  color = c("CCRCN" = "#4771e9", 
                                                            "This datset" = 'black'), 
                                                  title = "Original Source") ))
SOM_to_OC_quadratic_randomeffect

#### 5. conversion factors used ######
table(data0$Conv_factor)

data_conv_factors <- data0 %>% 
  filter(is.na(Conv_factor) == FALSE) %>% 
  group_by(Source, Country, Original_source) %>% 
  dplyr::count(Conv_factor) 

# library(gridExtra)
# table_name <- paste("reports/04_data_process/figures/SOM_to_OC/", Sys.Date(),"_conversion_factors.png", sep = "")
# png(table_name, height = 50*nrow(data_conv_factors), width = 200*ncol(data_conv_factors))
# grid.table(data_conv_factors)
# dev.off()


#### 6. compare study SOM conversion factors to ours ####

data_converted_compare <-data0 %>% 
  filter(is.na(Conv_factor) == FALSE &
           is.na(SOM_perc_combined) == FALSE &
           is.na(OC_perc_combined) == FALSE) %>% 
  mutate(OC_perc_from_eq = a_est*(SOM_perc_combined^2) + 
           b_est*SOM_perc_combined + c_est) %>%
  mutate(OC_perc_from_eq = replace(OC_perc_from_eq, which(OC_perc_from_eq<0.00001), NA))%>%
  mutate(OC_calcualted_diff_perc = (OC_perc_from_eq - OC_perc_combined)/OC_perc_combined*100)


OC_eq_vs_OC_from_SOM <- ggplot(data_converted_compare, aes(x = OC_perc_combined, y = OC_perc_from_eq))+
  geom_point(size = 0.75, aes(color = Source))+
  theme_bw()+
  labs(x = "OC (%) calculated from SOM from original study's equation",
       y = "OC (%) calculated from our general equation")
OC_eq_vs_OC_from_SOM

OC_calcualted_diff_graph <- ggplot(data_converted_compare, aes(x = Source, y = OC_calcualted_diff_perc))+
  geom_boxplot(aes(color = Source))+
  theme_bw()+
  labs(x = "Source",
       y = "Percent different from OC (%) from SOM with original study's equation to OC calc from SOM with our general equation")
OC_calcualted_diff_graph



#### 7. apply our conversion factor to ones without CFs ####

conversion_eq <- function (df, col){
    df1 <-  df %>%
      mutate(OC_from_SOM_our_eq = eval(a_est_RE0)*((df[ ,col])^2) 
             + eval(b_est_RE0)*(df[ ,col]))
}


# first, creating the conversion based on which model had the lowest AIC
# 
# conversion_eq <- function (df, col) {
#   if (rownames(lowest_AIC) == "quadratic_randomeffect") {
#     df1 <-  df %>% 
#       mutate(OC_from_SOM_our_eq = eval(a_est_RE)*((df[ ,col])^2) + eval(b_est_RE)*(df[ ,col]) + eval(c_est_RE))
#     
#   } else if (rownames(lowest_AIC) == "quadratic_model" ){ 
#     df1 <-  df %>% 
#       mutate(OC_from_SOM_our_eq = a_est*((df[ ,col])^2) + b_est*(df[ ,col]) + c_est)
#     
#   } else if (rownames(lowest_AIC) == "linear_randomeffect"){ 
#     df1 <-  df %>% 
#       mutate(OC_from_SOM_our_eq = lm_slope_RE * (df[ ,col]) + lm_intercept_RE)
#     
#   } else if (rownames(lowest_AIC) == "linear_model") { 
#     df1 <-  df %>% 
#       mutate(OC_from_SOM_our_eq = lm_slope * (df[ ,col]) + lm_intercept)
#   }
#   return(df1)
# }

# # to check that the function works
# data_sub <- data0 %>% 
#   filter(is.na(SOM_perc_combined) == FALSE) %>% 
#   filter(Source != "Beasy and Ellison 2013") %>% 
#   mutate(OC_quad = a_est*(SOM_perc_combined^2) + b_est*SOM_perc_combined + c_est,
#          OC_quad_RE = a_est_RE*(SOM_perc_combined^2) + b_est_RE*SOM_perc_combined + c_est_RE,
#          OC_linear = lm_slope * SOM_perc_combined + lm_intercept,
#          OC_linear_RE =lm_slope_RE * SOM_perc_combined + lm_intercept_RE )
# # for the test
#test <- conversion_eq(df = data_sub, col = "SOM_perc_combined")



# adding the column for the converted values, apply to all rows
data_SOMconverted0 <- conversion_eq(df = data0, col = "SOM_perc_combined")


#create a final df with a column combining observed OC, OC from study equations and OC from our equation
data_SOMconverted1 <-  data_SOMconverted0 %>% 
    #adding a column to indicate if an OC value is observed, estimated from study equation or estimated from our equation
  mutate(OC_obs_est = case_when(is.na(OC_perc_combined) == FALSE & is.na(Conv_factor) == TRUE ~  "Observed",
                                is.na(OC_perc_combined) == FALSE & is.na(Conv_factor) == FALSE & Method != "LOI" ~ "Observed",
                                is.na(OC_perc_combined) == FALSE & is.na(Conv_factor) == FALSE & Method == "LOI" ~ "Estimated (study equation)",
                                is.na(OC_perc_combined) == TRUE & is.na(Conv_factor) == TRUE ~ "Estimated (our equation)",
                                is.na(OC_perc_combined) == TRUE & is.na(Conv_factor) == FALSE ~ "Estimated (our equation)")) %>%
  
     #adding a column where if there is an OC_perc_combined values, keep, if not, take the OC_from_SOM_our_eq value
  mutate(OC_perc_final = coalesce(OC_perc_combined, OC_from_SOM_our_eq)) %>% 
  
  #delete negative values but keep 0
  mutate(OC_perc_final = replace(OC_perc_final, which(OC_perc_final<=0), NA))
  # dplyr::select(Source, Site, Site_name, OC_perc, OC_perc_combined, OC_obs_est,
  #               SOM_perc_combined, OC_from_SOM_our_eq, Conv_factor, Method,
  #              OC_perc_final)

test_NAs <- data_SOMconverted1 %>% 
  filter(is.na(OC_obs_est) == TRUE)


### edit for Kohfeld et al. 2022 - published both OC from EA (limiteddata)
# but still used their own conversion factor for the rest of data
data_SOMconverted <- data_SOMconverted1 %>% 
  mutate(OC_perc_combined = case_when(Source == "Kohfeld et al 2022" & 
                                        OC_obs_est == "Estimated (our equation)"
                                      ~ SOM_perc_combined*0.44-1.80,
         TRUE ~ OC_perc_combined)) %>% 
  mutate(OC_obs_est = case_when(Source == "Kohfeld et al 2022" & 
                                  OC_obs_est == "Estimated (our equation)"
                                ~ "Estimated (study equation)",
                                TRUE ~ OC_obs_est))%>% 
  mutate(Conv_factor = case_when(Source == "Kohfeld et al 2022" & 
                                  OC_obs_est == "Estimated (study equation)"
                                ~ "OC = 0.44*OM - 1.80",
                                TRUE ~ Conv_factor)) %>% 
  mutate(OC_perc_final = case_when(Source == "Kohfeld et al 2022" & 
                                   OC_obs_est == "Estimated (study equation)"
                                 ~ OC_perc_combined,
                                 TRUE ~ OC_perc_final)) %>% 
  #delete negative values but keep 0
  mutate(OC_perc_final = replace(OC_perc_final, which(OC_perc_final<=0), NA))
  


test_studies <- data_SOMconverted %>% 
  filter(Source != "CCRCN") %>% 
  filter(OC_obs_est == "Estimated (study equation)") %>% 
  droplevels()

table(test_studies$Source)


SOM_OC_converted <- data_SOMconverted %>% 
  filter(is.na(OC_perc_final) == FALSE
         & is.na(SOM_perc_combined) == FALSE) %>% 
  ggplot(aes(x = SOM_perc_combined, y = OC_perc_final))+
  geom_point(aes(color = OC_obs_est))+
  theme_bw()+
  labs(x = "SOM (%)",
       y = "OC (%) both observed and calcualted")
SOM_OC_converted
# note: the large green line is from Kohfeld et al 2022


#### 9. explore OC_perc and SOM_perc data in general

# histogram <- data0 %>% 
#   filter(is.na(SOM_perc_combined) == FALSE &
#          Country != "United States") %>% 
#   ggplot(aes(x = SOM_perc_combined)) +
#   geom_histogram()+
#   theme_bw() +
#   facet_wrap(~Country)
#   
# histogram

test <- data_SOMconverted %>% 
  filter(Source == "Beasy and Ellison 2013")

#### 8. figure exports ####
path_out = 'reports/04_data_process/figures/SOM_to_OC/'

##studies with SOM to OC
export_fig <- SOM_OC_observed
fig_main_name <- "SOM_OC_observed"

export_file <- paste(path_out, fig_main_name, ".png", sep = '')
#ggsave(export_file, export_fig, width = 15.36, height = 8.14)


### quadratic function
export_fig <- SOM_to_OC_quadratic_randomeffect
fig_main_name <- "SOM_to_OC_quadratic_randomeffect"

export_file <- paste(path_out, fig_main_name, ".pdf", sep = '')
#ggsave(export_file, export_fig, width = 15.36, height = 8.14)



### summary of SOM to OC observations
export_fig <- SOM_OC_converted
fig_main_name <- "SOM_OC_converted_observed_estimated"

export_file <- paste(path_out, fig_main_name, ".png", sep = '') 
#ggsave(export_file, export_fig, width = 10.69, height = 7.41)


#### 9. errors #####

test <- data0 %>%
  filter(OC_perc_combined > SOM_perc_combined) %>%
#  filter(Source == "CCRCN") %>%
  dplyr::select(Source, Original_source, Core, Conv_factor, SOM_perc_combined, OC_perc_combined, BD_reported_combined)
# 
# library(gridExtra)
# png("reports/04_data_process/figures/SOM_to_OC/OC-greater-SOM.png",
#     height = 23*nrow(test), width = 200*ncol(test))
# grid.table(test)
# dev.off()


nrow(data_SOM_OC)

test <- data_SOM_OC %>% 
  filter(Source != "CCRCN")

length(table(test$Original_source))


#### 10. add outliers back onto data frame ####

outliers <- read_data %>% 
  filter(grepl("Outlier", Notes, ignore.case = TRUE)) 

export_data01 <- rbind.fill(data_SOMconverted, outliers) 

export_data02 <- export_data01 %>% 
  dplyr::relocate(Notes, .after = OC_perc_final)

#### last. export cleaned and converted data ####

path_out = 'reports/04_data_process/data/'

export_file <- paste(path_out, "data_cleaned_SOMconverted.csv", sep = '') 
export_df <- export_data02

write.csv(export_df, export_file, row.names = F)
