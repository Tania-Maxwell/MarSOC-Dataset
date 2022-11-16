## clean up data compiled from datasets 
## prior to soil C modelling 
# contact Tania Maxwell, tlgm2@cam.ac.uk
# 04.11.22

rm(list=ls()) # clear the workspace
library(tidyverse)
input_file01 <- "reports/03_data_format/data/bind/data_compile.csv"

data0 <- read.csv(input_file01)

str(data0)

#### 1. basic data cleaning ####


## year_collected
data1 <- data0 %>% 
  dplyr::select(-ID) %>%  #ID from each export; doesn't have meaning
  separate(Year_collected, c("Year_collected", "Year_collected_end"), sep = '-' ) %>% 
  mutate(Year_collected = as.numeric(Year_collected)) %>% 
  mutate(N_perc = round(as.numeric(N_perc),3))

table(is.na(data1$Year_collected))
hist(data1$Year_collected)


#### 2. merge columns ####

#to merge OC_perc with OC_perc_mean with Soil_OCcon_mean

data2 <- data1 %>% 
  #in column OC_perc_sd, keep OC_perc_sd values, and when empty fill with OC_perc_SD, or OC_perc_s values
  mutate(OC_perc_sd = coalesce(OC_perc_sd, OC_perc_SD, OC_perc_s)) %>% 
  mutate(OC_perc_mean = coalesce(OC_perc_mean, Soil_OCcon_mean, Soil_TCcon_mean)) %>% 
  mutate(SOM_perc_sd = coalesce(SOM_perc_sd, SOM_perc_SD)) %>% 
  mutate(BD_reported_g_cm3_mean = coalesce(BD_reported_g_cm3_mean, BD_g_cm3_mean, Soil_BD_mean)) %>% 
  mutate(BD_reported_g_cm3_sd = coalesce(BD_reported_g_cm3_sd, BD_g_cm3_SD, Soil_BD_SD)) %>% 
  mutate(BD_reported_g_cm3_se = coalesce(BD_reported_g_cm3_se, BD_g_cm3_se)) %>% 
  mutate(n_cores = coalesce(n_cores, Soil_OCcon_n, Soil_BD_n)) %>% 
  mutate(N_perc = coalesce(N_perc, Ntot_perc, TN_perc)) %>% 
  mutate(Nation = coalesce(Nation, Emirate)) %>% 
  mutate(Treatment = coalesce(Treatment, Marsh_type)) %>% 
  dplyr::select(-c(OC_perc_SD, OC_perc_s, Soil_OCcon_mean, Soil_TCcon_mean, SOM_perc_SD,
                   BD_g_cm3_mean, Soil_BD_mean, BD_g_cm3_SD, Soil_BD_SD, BD_g_cm3_se,
                   Soil_OCcon_n, Soil_BD_n, Ntot_perc, TN_perc, Emirate, Marsh_type))

#### check that data isn't being omitted 
#Ctot_perc: only Shamrikova included Ctot_perc - OC_perc is also calculated from study 
#OC_mg_g already calcualted to OC_perc (Ewers Lewis et al 2020)
#TC_mg_g study also has OC_mg_G (Ewers Lewis et al 2020)
#need to KEEP C_stock_MgC_ha (Meng et al 2019 review only has this data)


data3 <- data2 %>% 
  dplyr::select(Source:Original_source, Conv_factor, Core, State, Location, Depth_to_bedrock_m,
               Season, Treatment, Replicate, n_cores, Core_type, SOM_perc_mean:OC_perc_se, BD_reported_g_cm3_mean, 
               BD_reported_g_cm3_se, BD_reported_g_cm3_sd)


#### 3. Add data type & combining raw with site-level data  ####

data4 <- data3 %>% 
  mutate(Data_type = case_when(Source == "Cusack et al 2018" | Source == "Gailis et al 2021" |
                                 Source == "Gispert et al 2020" | Source == "Gispert et al 2021" |
                                 Source == "Perera et al 2022" | Source == "Rathore et al 2016" |
                                 Source == "Yang et al 2021" | Source == "Yu and Chmura 2010" |
                                 Source == "Yuan et al 2019" ~ "Site-level",
                               Source == "Copertino et al under review" | Source == "He et al 2020" |
                                 Source == "Hu et al 2020" | Source == "Meng et al 2019" |
                                 Source == "Wails et al 2021" ~ "Meta-analysis",
         TRUE ~ "Core-level")) %>% 
  relocate(Data_type, .before = OC_perc) %>% 
  mutate(OC_perc_combined = coalesce(OC_perc, OC_perc_mean)) %>% 
  mutate(SOM_perc_combined = coalesce(SOM_perc, SOM_perc_mean)) %>% 
  mutate(BD_reported_combined = coalesce(BD_reported_g_cm3, BD_reported_g_cm3_mean))


#### export cleaned data

path_out = 'reports/04_data_process/data/'

export_file <- paste(path_out, "data_cleaned.csv", sep = '') 
export_df <- data4

write.csv(export_df, export_file, row.names = F)


