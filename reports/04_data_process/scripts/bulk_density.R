## script to estimate Bulk density from Organic carbon
## using double inverse exponential function
## global marsh soil C project
# contact Tania Maxwell, tlgm2@cam.ac.uk
# 25.10.22

library(tidyverse)
library(mosaic)
library(nimble) #for the nls function
library(propagate) #to predic nls


#import compiled data
input_file01 <- "reports/03_data_format/data/bind/data_compile.csv"

input_data01 <- read.csv(input_file01)


#visualize data 
plot(input_data_model$OC_perc, input_data_model$BD_reported_g_cm3)


##### Full  model ####

#model structure based on Sanderman et al. 2018 Scientific Reports

OC_to_BD <- function(x, a, b, c , d, f) {
  a + (b*exp(-c*x)) + (d*exp(-f*x))
}

## use the start values for the model from sanderman paper
full_model <- nls(BD_reported_g_cm3 ~ OC_to_BD(OC_perc, a, b, c, d, f), 
              data=input_data_model, 
              start=list(a=0.0906, b=0.8757, c=0.0786, d=0.6528, f =1.0975))
summary(full_model)

## extract the coefficient values from the model summary
a_est <- summary(full_model)[['coefficients']][[1]]
b_est <- summary(full_model)[['coefficients']][[2]]
c_est <- summary(full_model)[['coefficients']][[3]]
d_est <- summary(full_model)[['coefficients']][[4]]
f_est <- summary(full_model)[['coefficients']][[5]]

## calculated the predicted values at the random x values with the coefficient 
#and full function

xBD2 = seq(from = 0.001, to = 50, 
          length.out = 100)


fitted_values <- OC_to_BD(xBD2, a_est, b_est, c_est, d_est, f_est)

plot(input_data_model$OC_perc, input_data_model$BD_reported_g_cm3)
lines(xBD2, fitted_values, col="red")

plot(residuals(full_model))


###### predictions #####

predictions <- predictNLS(full_model, newdata = data.frame(OC_perc = xBD2),
                      interval="pred")
predictions$summary

plot(input_data_model$OC_perc, input_data_model$BD_reported_g_cm3)
lines(xBD2, fitted_values, col="red")
lines(xBD2, predictions$summary$`Sim.2.5%`, col="red", lty=2)
lines(xBD2, predictions$summary$`Sim.97.5%`, col="red", lty=2)


test <- input_data01 %>% 
  filter(OC_perc > 40 & BD_reported_g_cm3 >1)
