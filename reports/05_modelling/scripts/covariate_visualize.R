# script to visualize training data and covariate layers

rm(list=ls()) # clear the workspace
library(tidyverse)
library(lattice) #xyplot
#### import data ####

df0 <- read_csv("reports/05_modelling/data/export_data_landsat_v_1_2.csv")

# NOTE: need to find a unique identifier for each site or latitude so that can merge
# input_file01 <- "reports/04_data_process/data/data_cleaned.csv"
# 
# data0 <- read.csv(input_file01)
# 
# str(data0)
# 
# data1 <- left_join(data0, landsat, by = "Latitude")


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



df <- df1 %>% 
  # mutate(coastTyp = as.factor(coastTyp)) %>% 
  dplyr::select(evi_med, evi_stdev,
                ndvi_med, ndvi_stdev,savi_med , savi_stdev , 
                #and the response variables
                SOCD_g_cm3) %>% 
  rename(OC = SOCD_g_cm3)


# first have a look at the data
d = reshape2::melt(df, id.vars = "OC")

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

p <- df %>% 
  ggplot(aes(x = ndvi_med, y = OC))+
  geom_point()+
  theme_bw()

p


