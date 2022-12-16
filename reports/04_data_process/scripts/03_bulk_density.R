## script to estimate Bulk density from Organic carbon
## using double inverse exponential function
## global marsh soil C project
# contact Tania Maxwell, tlgm2@cam.ac.uk
# 25.10.22

rm(list=ls()) # clear the workspace
library(tidyverse)
library(mosaic)
library(nimble) #for the nls function
library(propagate) #to predic nls


#import compiled data
input_file01 <- "reports/04_data_process/data/data_cleaned_SOMconverted.csv"

data0 <- read.csv(input_file01) 

data1 <- data0 %>% 
  #remove data with no OC_final data
  filter(is.na(OC_perc_final) == FALSE)

#### 1. explore data ####

##### a. studies with  BD reported #####


studies_BD_reported <- data1 %>% 
  filter(is.na(BD_reported_combined) == FALSE)

## percent
nrow(studies_BD_reported)/nrow(data1)*100
##~89% have BD reported! 

##number of studies without BD reported
nmissing_BD <- (nrow(data1))-(nrow(studies_BD_reported))
nmissing_BD

###### a1. BD reported and OC (original) ######

studies_BD_reported_OC <- studies_BD_reported %>% 
  filter(Method != "LOI") %>% 
  #only include OC measured (not estimated)
  filter(is.na(OC_perc_combined) == FALSE)

##number of values = 17065
nrow(studies_BD_reported_OC)

#42% of data has BD reported and OC
nrow(studies_BD_reported_OC)/nrow(data1)*100

yesBD_yesOC <- studies_BD_reported_OC %>% 
  ggplot(aes(x = OC_perc_combined, y = BD_reported_combined))+
  geom_point()+
  theme_bw()+
  labs(x = "OC (%)",
       y = "BD (g cm-3)")
yesBD_yesOC

###### a2. BD reported and SOM ######

studies_BD_reported_SOM <- studies_BD_reported %>% 
  filter(Method == "LOI") %>% 
  #only include SOM measured
  filter(is.na(SOM_perc_combined) == FALSE)

yesBD_yesSOM <- studies_BD_reported_SOM %>% 
  ggplot(aes(x = SOM_perc_combined, y = BD_reported_combined))+
  geom_point(aes(color = Original_source))+
  theme_bw()+
  labs(x = "SOM (%)",
       y = "BD (g cm-3)")
yesBD_yesSOM



##### b. studies no BD yes OC ####

studies_noBD_yesOC <- data1 %>% 
  filter(is.na(BD_reported_g_cm3) == TRUE &
           is.na(OC_perc_combined) == FALSE)

## number of studies
nrow(studies_noBD_yesOC)

## left to account for: 
nmissing_BD - (nrow(studies_noBD_yesOC))


##### c. studies no BD yes SOM #####

studies_noBD_yesSOM <- data1 %>% 
  filter(is.na(BD_reported_g_cm3) == TRUE &
           is.na(OC_perc_combined) == TRUE &
           is.na(SOM_perc_combined) == FALSE)

## number of studies
nrow(studies_noBD_yesSOM)

## left to account for: 
nmissing_BD - (nrow(studies_noBD_yesSOM)) - (nrow(studies_noBD_yesOC))


##### d. studies no BD yes OC yes SOM #####

studies_noBD_yesSOM_yesOC <- data1 %>% 
  filter(is.na(BD_reported_g_cm3) == TRUE &
           is.na(OC_perc_combined) == FALSE &
           is.na(SOM_perc_combined) == FALSE)

## number of studies
nrow(studies_noBD_yesSOM_yesOC)
# 384

#### 2. Full  model from elemental analysis OC data ####

#model structure based on Sanderman et al. 2018 Scientific Reports

OC_to_BD <- function(x, a, b, c , d, f) {
  a + (b*exp(-c*x)) + (d*exp(-f*x))
}

start_vec <- c(a=0.0906, b=0.8757, c=0.0786, d=0.6528, f =1.0975)

## use the start values for the model from sanderman paper
model_OC_to_BD <- nls(BD_reported_combined ~ OC_to_BD(OC_perc_combined, a, b, c, d, f), 
              data=studies_BD_reported_OC, 
              start= start_vec)

summary(model_OC_to_BD)

## extract the coefficient values from the model summary
a_est <- summary(model_OC_to_BD)[['coefficients']][[1]]
b_est <- summary(model_OC_to_BD)[['coefficients']][[2]]
c_est <- summary(model_OC_to_BD)[['coefficients']][[3]]
d_est <- summary(model_OC_to_BD)[['coefficients']][[4]]
f_est <- summary(model_OC_to_BD)[['coefficients']][[5]]

## calculated the predicted values at the random x values with the coefficient 
#and full function

xBD2 = seq(from = 0.001, to = 50, 
          length.out = 100)


fitted_values <- OC_to_BD(xBD2, a_est, b_est, c_est, d_est, f_est)

df_fitted <- as.data.frame(cbind(xBD2, fitted_values))


plot(residuals(model_OC_to_BD))



##### graphs #####
OC_to_BD_graph <- ggplot(studies_BD_reported_OC, aes(x = OC_perc_combined, y = BD_reported_combined))+
  geom_point()+
  theme_bw()+
  labs(x = "Organic carbon (%)", y = "Bulk Density (g cm-3)")+
  geom_line(data = df_fitted, aes(x = xBD2, y =fitted_values), col = "blue", size = 1)+
  #annotate("text", x=60, y=4, label= "0.065 + (0.59*exp(-0.056*OC)) + (0.77*exp(-0.58*OC))", color="blue")
  # annotate(geom = "text",  label = paste("BD =", round(a_est,3), "±", round(a_std,3), 
  #                                      "+", round(b_est,3), "±", round(b_std,3),
  #                                      "exp(", round((c_est*-1),3), "±", round(c_std,3)),
  #                                       "*OC) +", round(d_est,3), "±", round(d_std,3),
  #                                       "exp(", round((f_est*-1),3), "±", round(f_std,3),
  #          
  #        y = 50, x = 30)
  annotate(geom = "text",  label = paste("BD =", round(a_est,3),  
                                         "+", round(b_est,3),
                                         "exp(", round((c_est*-1),3), 
           "*OC ) +", round(d_est,3), 
           "exp( ", round((f_est*-1),3), "*OC )"),
           
           y = 3, x = 30)

OC_to_BD_graph

# random effect? 
library(lme4)
model_randomeffect <- lmer(BD_reported_combined ~ exp(OC_perc_combined) 
                           + (1|Original_source), 
                           data = studies_BD_reported_OC)

test <- lmer(BD_reported_combined ~ OC_to_BD(OC_perc_combined)
             + (1|Original_source), 
             data = studies_BD_reported_OC)

## 3. Fit the same model with a user-built function:
## a. Define formula
nform <- ~(a + (b*exp(-c*x)) + (d*exp(-f*x)))
## b. Use deriv() to construct function:
nfun <- deriv(nform,namevec=c("a","b","c", "d", "f"),
              function.arg=c("x","a","b","c", "d", "f"))


test<- nlmer(BD_reported_combined ~ OC_to_BD(OC_perc_combined, a, b, c, d, f) 
             ~ a|Original_source, 
             data=studies_BD_reported_OC, 
             start=start_vec)


summary(model_randomeffect)
confint(model_randomeffect)

library(lmerTest)
anova(model_randomeffect)
model_OC_to_BD <- nls(BD_reported_combined ~ OC_to_BD(OC_perc_combined, a, b, c, d, f), 
data=studies_BD_reported_OC, 
start=list(a=0.0906, b=0.8757, c=0.0786, d=0.6528, f =1.0975))
summary(model_OC_to_BD)


##### predictions ####
# 
# predictions <- predictNLS(full_model, newdata = data.frame(OC_perc = xBD2),
#                       interval="pred")
# predictions$summary
# 
# plot(input_data_model$OC_perc, input_data_model$BD_reported_g_cm3)
# lines(xBD2, fitted_values, col="red")
# lines(xBD2, predictions$summary$`Sim.2.5%`, col="red", lty=2)
# lines(xBD2, predictions$summary$`Sim.97.5%`, col="red", lty=2)
# 
# 
# test <- input_data01 %>% 
#   filter(OC_perc > 40 & BD_reported_g_cm3 >1)
# 



#### 3. Full model from LOI SOM data ####

# k1 and k2 values start from Morris et al 2016
#https://agupubs.onlinelibrary.wiley.com/doi/10.1002/2015EF000334
# BD = 1/[LOI/k1 + (1-LOI)/k2]

SOM_to_BD <- function(x, k1, k2) {
  1/((x/k1) + ((1-x)/k2))
}

## use the start values for the model from sanderman paper
model_SOM_to_BD <- nls(BD_reported_combined ~ SOM_to_BD(SOM_perc_combined, k1,k2), 
                      data=studies_BD_reported_SOM, 
                      start=list(k1 = 0.085 , k2 = 1.99))
summary(model_SOM_to_BD)

library(lme4)
model_randomeffect <- lmer(BD_reported_combined ~ 1/((x/k1) + ((1-x)/k2))
                           + (1|Original_source), 
                           data = data_SOM_OC)

summary(model_randomeffect)


## extract the coefficient values from the model summary
a_est <- summary(model_SOM_to_BD)[['coefficients']][[1]]
b_est <- summary(model_SOM_to_BD)[['coefficients']][[2]]
c_est <- summary(model_SOM_to_BD)[['coefficients']][[3]]
d_est <- summary(model_SOM_to_BD)[['coefficients']][[4]]
f_est <- summary(model_SOM_to_BD)[['coefficients']][[5]]



#### 4. figure exports ####
export_fig <- OC_to_BD_graph
fig_main_name <- "OC_to_BD_graph"

path_out = 'reports/04_data_process/figures/OC_to_BD/'
fig_name <- paste(Sys.Date(),fig_main_name, sep = "_")
export_file <- paste(path_out, fig_name, ".png", sep = '') 
ggsave(export_file, export_fig, width = 9.83, height = 5.21)


