# script following youtube tutorial 
# https://www.youtube.com/watch?v=1rSoiSb7xbw&t=39s
# attach packages
library(mlr)
library(dplyr)
library(sf)
library(lattice)
library(tidyverse)
library(geojsonsf) #to convert GEE .geo to sf coordinates 

#### import data ####

GEE_data <- read_csv("reports/05_modelling/data/export_site_v_1_3.csv") %>% 
  mutate(Plot = as.factor(Plot)) %>% 
  dplyr::select(Site_name, 
                coastTyp, #not now that only 1 level?
                elevation, #SRTM elevation
                evi_med, evi_stdev,
                flowAcc, flowAcc_1, gHM_2016 , maxTemp,
                merit_elevation, 
                #merit_slope, 
                minPrecip , minTemp, M2Tide,
                ndvi_med, ndvi_stdev, PETdry, PETwarm,
                popDens_change, savi_med, savi_stdev, slope,
                TSM, occurrence,
                .geo)
                #and the response variables
                #SOCD_g_cm3) 


training_data <- read_csv("reports/04_data_process/data/data_cleaned_SOMconverted.csv")

df0 <- inner_join(GEE_data,training_data, by = "Site_name")


df1 <- df0 %>% 
  ## creating a midpoint for each depth
  mutate(Depth_midpoint_m = (L_depth_m - U_depth_m)/2,
         Depth_thickness_m = L_depth_m - U_depth_m) %>% 
  ##converting SOM to OC just for test (this will be done beforehand for final data)
  mutate(OC_perc_estimated = 0.000838*(SOM_perc_combined^2) + 
           0.3953*SOM_perc_combined - 0.5358) %>% 
  mutate(OC_perc_final = coalesce(OC_perc_combined, OC_perc_estimated)) %>%
  mutate(SOCD_g_cm3 = BD_reported_combined*OC_perc_final/100,
         SOCS_g_cm2 = SOCD_g_cm3 * 100 *Depth_thickness_m,
         # 100,000,000 cm2 in 1 ha and 1,000,000 g per tonne
         SOCS_t_ha = SOCS_g_cm2 * (100000000)/1000000) %>% 
  filter(is.na(SOCD_g_cm3) == FALSE)

str(df1)

#### 2. subset data for sf ####

## for the sf package, need to have 2 separate files
# the response-predictor matrix and the coordinates matrix (cols = x,y)


#subset the predictor and response variables 
df <- df1 %>% 
  # mutate(coastTyp = as.factor(coastTyp)) %>% 
  
  # should have 22 
  
  dplyr::select(Depth_midpoint_m , 
                coastTyp, #not now that only 1 level?
                elevation, #SRTM elevation
                  evi_med, evi_stdev,
                  flowAcc, flowAcc_1, gHM_2016 , maxTemp,
                merit_elevation, 
                #merit_slope, 
                minPrecip , minTemp, M2Tide,
                ndvi_med, ndvi_stdev, PETdry, PETwarm,
                popDens_change, savi_med , savi_stdev , slope,
                TSM, occurrence,
                #and the response variables
                SOCD_g_cm3) %>% 
  dplyr::rename(OC = SOCD_g_cm3,
         flowAcc_MERIT = flowAcc,
         flowAcc_SRTM = flowAcc_1) %>% 
  mutate(coastTyp = as.factor(coastTyp))

summary(df$OC)

coords_forsf <- st_as_sf(data.frame(df1, geom=geojson_sf(df1$.geo))) 

#how to extract coordinates from geometry column in df
coords = sf::st_coordinates(coords_forsf) %>%
  as.data.frame %>%
  dplyr::rename(x = X, y = Y)


#### 3. visualize data ####

# first have a look at the data

df_viz <- df %>%
  dplyr::select(-coastTyp) # because a factor 

d = reshape2::melt(df_viz, id.vars = "OC")

xyplot(OC ~ value | variable, data = d, pch = 21, fill = "lightblue",
       col = "black", ylab = "response (SOCD_g_cm3)", xlab = "predictors",
       scales = list(x = "free",
                     tck = c(1, 0),
                     alternating = c(1, 0)),
       strip = strip.custom(bg = c("white"),
                            par.strip.text = list(cex = 1.2)),
       panel = function(x, y, ...) {
         panel.points(x, y, ...)
         panel.loess(x, y, col = "salmon", span = 0.5)
       })


#### correlations

library(PerformanceAnalytics)

panel.hist <- function(x, ...) {
  usr <- par("usr")
  on.exit(par(usr))
  par(usr = c(usr[1:2], 0, 1.5))
  his <- hist(x, plot = FALSE)
  breaks <- his$breaks
  nB <- length(breaks)
  y <- his$counts
  y <- y/max(y)
  rect(breaks[-nB], 0, breaks[-1], y, col = rgb(0, 1, 1, alpha = 0.5), ...)
  # lines(density(x), col = 2, lwd = 2) # Uncomment to add density lines
}


#vegetation indices 
df_veg <- df %>% 
  dplyr::select(ndvi_med, savi_med, evi_med)

pairs(df_veg, lower.panel = NULL, diag.panel = panel.hist)


#elevation indices 
df_elev <- df %>% 
  dplyr::select(elevation, merit_elevation, occurrence)

pairs(df_elev, lower.panel = NULL, diag.panel = panel.hist)




#### 4. create different parts of model ####

##### create a task####
task = makeRegrTask(data = df, target = "OC",
                    coordinates = coords)

  #target is the response variable
  #coordinates used for the spatial partitioning
  
#listLearners() is to see how many total models are available in mlr (can be over 200)

##### define the learner####
  
#define the learner with makeLearner(cl = "", predict.type = "response")
  #here, predict.type is the response, not the probability
lrn = makeLearner(cl = "regr.lm", predict.type = "response")


##### define the performance level with spatial CV #####  
#SpRepCV method is spatial repetitive cross validation
  #100 repeted 5 fold validation
perf_level <-  makeResampleDesc(method = "SpRepCV",
                   folds = 5,
                   reps = 100)


#### 5. run model ####

cv_sp = mlr::resample(learner = lrn,
                      task = task,
                      resampling = perf_level,
                      measures = mlr::rmse)
boxplot(cv_sp$measures.test$rmse)

cv_sp




# an option to test whether the RMSE/model performance is good: 
# aggr is mean of RMSE
#difference of the range 
cv_sp$aggr/diff(range(df$OC))*100

#this gives an idea of the mena deviation per prediction
# on average, our prediction is 14% off the real value



# random forest in ranger 
lrn_rf = makeLearner(cl = "regr.ranger", predict.type = "response")

#before we can do the predictions, we need to know the optimal parameters
#need to do nested cross validation for the tuning of the parameters
#hyperparameter testing is computationally intensive
#50 iterations of tuning in each inner fold (i.e. 5 inner folds = 250 models) 
#then, end up with optimum hyper parameter for each fold (1 from the 250)
#end up with 5*100 = 500 ifferent hyper parameters
# this is the aim for the performance estimation
# from this, we don't use it for spatial prediction (confusing)
# see chapter 11

tune_level = makeResampleDesc(method = "SpCV", iters = 5)

#tell mlr to find optimat hyperparameters via a random search with 50 iteration
ctrl = makeTuneControlRandom(maxit =10) #use 50 models in each of these folds
#note, trying 10 to reduce run time

# define the tuning space
# limit according to the literature (Probs, Wright & Boulesteix 2018)
#https://doi.org/10.1002/widm.1301
#they compare different hypoerparameter turning strategies
#they come up with this recommendation
ps = makeParamSet(
  makeIntegerParam("mtry", lower = 1, upper =ncol(df)-1),
  makeNumericParam("sample.fraction", lower = 0.2, upper = 0.9),
  makeIntegerParam("min.node.size", lower =1, upper =10)
)

#mtry - lowest value: use 1 prediction, or use all predictions (which is just bagging)
# minus 1 becuase the df also contains the response variable
# sample fraction varies between 20 and 90%; i.e. model willcontain somewhere between this
#min node size is the terminal node 
# how many observations must be found in the terminal knot

#random fest because randomly determine the number of predictors
# randomly determine the number of training data included
#radomnly determine the number of points in the terminal nodes 


#wrap it all up
wrapped_lrn_rf = makeTuneWrapper(learner = lrn_rf, 
                                 #innter loop (tuning level)
                                 resampling = tune_level,
                                 #hyperparameter search space
                                 par.set = ps,
                                 control = ctrl,
                                 show.info = TRUE,
                                 #performance measure
                                 measures = mlr::rmse
                                 )

#resampling
# CAUTION, running the next code chunk takes a while because we are asking R
# to run 125,500 models. parallelization might be a good idea. 
# see code/spatial_cv/01-mlr.R of the geocompr/geostats_18 repo to see how to set it up

set.seed(12345)
cv_sp_rf = mlr::resample(learner = wrapped_lrn_rf,
                         task = task,
                         resampling = perf_level,
                         extract = getTuneResult, #to get the tuning results
                         measures = mlr::rmse)

#if you use thousands of observations and hundreds of predictors, use parallelization

#look at the result
# conventional cv will have lower RMSE than spatial cv because it is overly optimistic

##even after 125,500 models, the example is worse than lm
# but usually use rf when lots of predictors and points
#machine learning models are not always better

cv_sp_rf


#> cv_sp_rf
# Resample Result
# Task: df
# Learner: regr.ranger.tuned
# Aggr perf: rmse.test.rmse=3.2476307
# Runtime: 2881.25

### with more covariate layers
# > cv_sp_rf
# Resample Result
# Task: df
# Learner: regr.ranger.tuned
# Aggr perf: rmse.test.rmse=0.0215683
# Runtime: 2083.32

# v 1_3
# > cv_sp_rf
# Resample Result
# Task: df
# Learner: regr.ranger.tuned
# Aggr perf: rmse.test.rmse=0.0226545
# Runtime: 1987.73



saveRDS(cv_sp_rf, "reports/05_modelling/data/cv_sp_rf_site_v_1_3.rds")

### trying to extract variable importance
mlr::getFeatureImportance(cv_sp_rf)

getLearnerModel(cv_sp_rf)

library(randomForest)
randomForest::importance(cv_sp_rf)

imp <- FeatureImp$new(cv_sp_rf, loss = "mae")

getFeatureImportanceLearner(cv_sp_rf$regr.ranger.tuned)
##for predictive mapping: https://github.com/geocompr/geostats_18/blob/master/code/spatial_cv/01-mlr.R

#trying new tutorial
# https://mlr-org.com/posts/2018-04-30-interpretable-machine-learning-iml-and-mlr/index.html#feature-importance
library("iml")
X = df[which(names(df) != "OC")]
predictor = iml::Predictor$new(cv_sp_rf, data = X, y = df$OC)

imp = iml::FeatureImp$new(predictor, loss = "mae")
plot(imp)