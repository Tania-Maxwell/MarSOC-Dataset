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
library(lme4) #model with random effect


#### import data ####
input_file01 <- "reports/04_data_process/data/data_cleaned.csv"

data0<- read.csv(input_file01)

str(data0)

data_unique <- data0 %>% 
  distinct(Latitude, .keep_all = TRUE)

country_table <- table(data_unique$Country)
country_table


data_noCCRCN <- data_unique %>% 
  filter(Source != "CCRCN")

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
  filter(Original_source != "Elsey Quirk et al 2011") %>%   ##issue with this study (seems SOM or OC was interpreted)
  filter(SOM_perc_combined > OC_perc_combined) # remove rare cases where OC > SOM %




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

xOC2 = seq(from = 0.01, to = 100, 
           length.out = 100)

fitted_values <- SOM_to_OC(xOC2, a_est, b_est, c_est)

fitted_df <- as.data.frame(cbind(xOC2, fitted_values))


# eq_label <- expression("OC =" ~~ bquote(a_est ~ "±" ~ a_std)~"OM"^2 ~~ "+" ~~ 
#                          (b_est ~ "±" ~ b_std)~"OM" ~~ "-" ~~ 
#                          ((c_est*-1)~"±"~c_std))

SOM_to_OC_quadratic <- ggplot(data_SOM_OC, aes(x = SOM_perc_combined, y = OC_perc_combined))+
  geom_point(aes(color = Source), size = 0.75)+
  theme_bw()+
  labs(x = "SOM (%)", y = "OC (%)")+
  geom_line(data = fitted_df, aes(x = xOC2, y =fitted_values), col = "blue", size = 1)+ 
  annotate(geom = "text",  label = paste("OC =", round(a_est,6), "±", round(a_std,6), 
                                         "OM^2 +", round(b_est,3), "±", round(b_std,3),
                                             "OM - ", round((c_est*-1),3), "±", round(c_std,3)), 
           y = 50, x = 30)

SOM_to_OC_quadratic

quadratic_resitudals <- plot(residuals(quadratic_model))


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


## graph

eq_label <- expression("OC =" ~~ (a_est ~ "±" ~ a_std)~"OM"^2 ~~ "+" ~~
                         (b_est ~ "±" ~ b_std)~"OM" ~~ "-" ~~
                         ((c_est*-1)~"±"~c_std))

eq_label_tidy <- list(bquote(paste("OC = ","(", !!a_est_RE, "±", !!a_std_RE, ")OM^2 +",
                            "(", !!b_est_RE, "±", !!b_std_RE, ")OM +",
                            "(", !!c_est_RE, "±", !!c_std_RE, ")", sep = " ")))

SOM_to_OC_quadratic_randomeffect <- ggplot(data_SOM_OC, aes(x = SOM_perc_combined, y = OC_perc_combined))+
  geom_point(aes(color = Source), size = 0.75)+
  theme_bw()+
  labs(x = "SOM (%)", y = "OC (%)")+
  geom_line(data = fitted_df, aes(x = xOC2, y =fitted_values), col = "blue", size = 1)+ 
  annotate(geom = "text",  label = paste("OC =", round(a_est_RE,6), "±", round(a_std_RE,6), 
                                         "OM^2 +", round(b_est_RE,3), "±", round(b_std_RE,3),
                                         "OM - ", round((c_est_RE*-1),3), "±", round(c_std_RE,3)), 
           y = 50, x = 30)
SOM_to_OC_quadratic_randomeffect


#### 4. compare models and finalize ####
AIC_df <- AIC(linear_model, linear_randomeffect, quadratic_model, quadratic_randomeffect)

lowest_AIC <- AIC_df %>% 
  slice(which.min(AIC))

final_model <- eval(parse(text = rownames(lowest_AIC)))


#### 5. conversion factors used ######
table(data0$Conv_factor)

data_conv_factors <- data0 %>% 
  filter(is.na(Conv_factor) == FALSE) %>% 
  group_by(Source, Country, Original_source) %>% 
  dplyr::count(Conv_factor) 

library(gridExtra)
png("reports/04_data_process/figures/SOM_to_OC/conversion_factors.png", height = 50*nrow(data_conv_factors), width = 200*ncol(data_conv_factors))
grid.table(data_conv_factors)
dev.off()


#### 6. compare study SOM conversion factors to ours ####

data_converted_compare <-data0 %>% 
  filter(is.na(Conv_factor) == FALSE &
           is.na(SOM_perc_combined) == FALSE &
           is.na(OC_perc_combined) == FALSE) %>% 
  mutate(OC_perc_from_eq = a_est*(SOM_perc_combined^2) + 
           b_est*SOM_perc_combined + c_est) %>%
  mutate(OC_perc_from_eq = replace(OC_perc_from_eq, which(OC_perc_from_eq<0.00001), NA))%>%
  mutate(OC_calcualted_diff_perc = (OC_perc_from_eq - OC_perc_combined)/OC_perc_combined*100)

hist(data_converted_compare$OC_perc_from_eq)




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

# first, creating the conversion based on which model had the lowest AIC

conversion_eq <- function (df, col) {
  if (rownames(lowest_AIC) == "quadratic_randomeffect") {
    df1 <-  df %>% 
      mutate(OC_from_SOM_our_eq = eval(a_est_RE)*((df[ ,col])^2) + eval(b_est_RE)*(df[ ,col]) + eval(c_est_RE))
    
  } else if (rownames(lowest_AIC) == "quadratic_model" ){ 
    df1 <-  df %>% 
      mutate(OC_from_SOM_our_eq = a_est*((df[ ,col])^2) + b_est*(df[ ,col]) + c_est)
    
  } else if (rownames(lowest_AIC) == "linear_randomeffect"){ 
    df1 <-  df %>% 
      mutate(OC_from_SOM_our_eq = lm_slope_RE * (df[ ,col]) + lm_intercept_RE)
    
  } else if (rownames(lowest_AIC) == "linear_model") { 
    df1 <-  df %>% 
      mutate(OC_from_SOM_our_eq = lm_slope * (df[ ,col]) + lm_intercept)
  }
  return(df1)
}

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
data_SOMconverted <-  data_SOMconverted0 %>% 
    #adding a column to indicate if an OC value is observed, estimated from study equation or estimated from our equation
  mutate(OC_obs_est = case_when(is.na(OC_perc_combined) == FALSE & is.na(Conv_factor) == TRUE ~  "Observed",
                                is.na(Conv_factor) == FALSE ~ "Estimated (study equation)",
                                is.na(OC_perc_combined) == TRUE & is.na(Conv_factor) == TRUE ~ "Estimated (our equation)")) %>%
 
     #adding a column where if there is an OC_perc_combined values, keep, if not, take the OC_from_SOM_our_eq value
  mutate(OC_perc_final = coalesce(OC_perc_combined, OC_from_SOM_our_eq)) %>% 
  
  #delete negative values but keep 0
  mutate(OC_perc_final = replace(OC_perc_final, which(OC_perc_final<=0), NA))
  # dplyr::select(Source, Site, Site_name, OC_perc, OC_perc_combined, OC_obs_est,
  #               SOM_perc_combined, OC_from_SOM_our_eq, Conv_factor, Method,
  #              OC_perc_final)

SOM_OC_converted <- data_SOMconverted %>% 
  filter(is.na(OC_perc_final) == FALSE
         & is.na(SOM_perc_combined) == FALSE) %>% 
  ggplot(aes(x = SOM_perc_combined, y = OC_perc_final))+
  geom_point(aes(color = OC_obs_est))+
  theme_bw()+
  labs(x = "SOM (%)",
       y = "OC (%) both observed and calcualted")
SOM_OC_converted


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


#### 8. figure exports ####
path_out = 'reports/04_data_process/figures/SOM_to_OC/'

### quadratic function
export_fig <- SOM_to_OC_quadratic_randomeffect
fig_main_name <- "SOM_to_OC_quadratic_randomeffect"

export_file <- paste(path_out, fig_main_name, ".png", sep = '')
ggsave(export_file, export_fig, width = 14.24, height = 8.46)



### summary of SOM to OC observations
export_fig <- SOM_OC_converted
fig_main_name <- "SOM_OC_converted_observed_estimated"

export_file <- paste(path_out, fig_main_name, ".png", sep = '') 
ggsave(export_file, export_fig, width = 10.69, height = 7.41)



#### 9. errors #####

# test <- data_SOM_OC %>% 
#   filter(OC_perc_combined > SOM_perc_combined) %>% 
#   filter(Source == "CCRCN") %>% 
#   dplyr::select(Source, Original_source, Core, SOM_perc_combined, OC_perc_combined, BD_reported_combined)
# 
# library(gridExtra)
# png("reports/04_data_process/figures/SOM_to_OC/CCRCN_OC-greater-SOM.png", 
#     height = 50*nrow(test), width = 200*ncol(test))
# grid.table(test)
# dev.off()

#### last. export cleaned and converted data ####

path_out = 'reports/04_data_process/data/'

export_file <- paste(path_out, "data_cleaned_SOMconverted.csv", sep = '') 
export_df <- data_SOMconverted

write.csv(export_df, export_file, row.names = F)


