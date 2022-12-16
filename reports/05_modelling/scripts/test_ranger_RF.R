## script to rest ranger random forest model

library(ranger)
library(caret)
library(tidyverse)
site_data0 <- read_csv("reports/05_modelling/data/export_site_v_1_1.csv")


site_data1 <- site_data0 %>% 
  ## creating a midpoint for each depth
  mutate(Depth_midpoint = (L_depth_m - U_depth_m)/2) %>% 
  ##converting SOM to OC just for test (this will be done beforehand for final data)
  mutate(OC_perc_estimated = 0.000838*(SOM_perc_combined^2) + 
           0.3953*SOM_perc_combined - 0.5358) %>% 
  mutate(OC_perc_final = coalesce(OC_perc_combined, OC_perc_estimated)) %>% 
  filter(is.na(OC_perc_final) == FALSE)

str(site_data1)
summary(site_data1$OC_perc_final)

model_caret <- caret::train()

#use CAST for target-oriented cross-validation 
#use the function CreateSpacetimeFolds  to easily divide dataset based on a variable
## a unique variable for each station, for example
# note: this doesn't take into account training points distance to one another 
#caution: elevation may be highly correlated with coordinates
#importance originates from ability of the algorithm to access the individual time series and not from spatial meaning

TrainingData <- site_data1 %>% 
  dplyr::select(Depth_midpoint , coastTyp , flowAcc , gHM_2016 , maxTemp,
                merit_elevation , minPrecip , minTemp , savi_med , savi_stdev , slope, .geo)

### caret model

model_OC <- train(OC_perc_final ~ Depth_midpoint + coastTyp + flowAcc + gHM_2016 + maxTemp 
                  + merit_elevation + minPrecip + minTemp + savi_med + savi_stdev + slope,
                  data = site_data1, 
                 method = "rf",
                 trControl = trainControl(method = "cv"))

model_OC

varImp(model_OC)

#target-oriented variable selection
# with forward feature selection
# first, the model selects which 2 variables lead to the best model
# improving the model means improving the leave location out error
# drop variables which are bad for the model 

# to do so, we change the function to "ffs" forward feature selection

library(CAST)

indices <- CreateSpacetimeFolds(TrainingData, spacevar = ".geo")

model_OCffs <- ffs(predictors = TrainingData, 
                   response = site_data1$OC_perc_final,
                  method = "rf",
                  trControl = trainControl(method = "cv",
                                           index = indices$index))
#here, the algorithm might drop variables 
model_OCffs
varImp(model_OCffs)
