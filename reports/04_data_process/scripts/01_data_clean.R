## clean up data compiled from datasets 
## prior to soil C modelling 
# contact Tania Maxwell, tlgm2@cam.ac.uk
# 04.11.22

rm(list=ls()) # clear the workspace
library(tidyverse)

setwd("~/07_Cam_postdoc/SaltmarshC")
input_file01 <- "reports/03_data_format/data/bind/data_compile.csv"

data0 <- read.csv(input_file01)

str(data0)

#### 1. basic data cleaning ####


## year_collected
data1 <- data0 %>% 
  mutate_all(na_if,"") %>% # replacing blanks with na
  dplyr::select(-ID) %>%  #ID from each export; doesn't have meaning
  separate(Year_collected, c("Year_collected", "Year_collected_end"), sep = '-' ) %>% 
  mutate(Year_collected = as.numeric(Year_collected)) %>% 
  mutate(N_perc = round(as.numeric(N_perc),3))

table(is.na(data1$Year_collected))
hist(data1$Year_collected)


#### 2. data corrections ####

## CCRCN database Keshta study has perfect fit between OC and SOM --> OC was calculated from SOM

data2 <- data1 %>% 
  mutate(Conv_factor = case_when( Original_source == "Keshta et al 2020 a" ~ "0.4068x+0.6705", 
                                  TRUE ~ Conv_factor))


#### 3. merge columns ####

#to merge OC_perc with OC_perc_mean with Soil_OCcon_mean

data3 <- data2 %>% 
  #in column OC_perc_sd, keep OC_perc_sd values, and when empty fill with OC_perc_SD, or OC_perc_s values
  mutate(OC_perc_sd = coalesce(OC_perc_sd, OC_perc_SD, OC_perc_s)) %>% 
  mutate(OC_perc_mean = coalesce(OC_perc_mean, Soil_OCcon_mean, Soil_TCcon_mean)) %>% 
  mutate(SOM_perc_sd = coalesce(SOM_perc_sd, SOM_perc_SD)) %>% 
  mutate(BD_reported_g_cm3_mean = coalesce(BD_reported_g_cm3_mean, BD_g_cm3_mean, Soil_BD_mean)) %>% 
  mutate(BD_reported_g_cm3_sd = coalesce(BD_reported_g_cm3_sd, BD_g_cm3_SD, Soil_BD_SD)) %>% 
  mutate(BD_reported_g_cm3_se = coalesce(BD_reported_g_cm3_se, BD_g_cm3_se)) %>% 
  mutate(n_cores = coalesce(n_cores, Soil_OCcon_n, Soil_BD_n, n)) %>% 
  mutate(N_perc = coalesce(N_perc, Ntot_perc, TN_perc)) %>% 
  mutate(Admin_unit = coalesce(Nation, Emirate, State)) %>% 
  mutate(Treatment = coalesce(Treatment, Marsh_type)) %>% 
  mutate(Time_replicate = coalesce(Season, Replicate)) %>% 
  dplyr::select(-c(OC_perc_SD, OC_perc_s, Soil_OCcon_mean, Soil_TCcon_mean, SOM_perc_SD,
                   BD_g_cm3_mean, Soil_BD_mean, BD_g_cm3_SD, Soil_BD_SD, BD_g_cm3_se,
                   Soil_OCcon_n, Soil_BD_n, Ntot_perc, TN_perc, Nation, Emirate, State, 
                   Marsh_type, Season, Replicate))

#### check that data isn't being omitted 
#Ctot_perc: only Shamrikova included Ctot_perc - OC_perc is also calculated from study 
#OC_mg_g already calcualted to OC_perc (Ewers Lewis et al 2020)
#TC_mg_g study also has OC_mg_G (Ewers Lewis et al 2020)
#need to KEEP C_stock_MgC_ha (Meng et al 2019 review only has this data)


data4 <- data3 %>% 
  dplyr::select(Source:Original_source, Conv_factor, Core, Admin_unit, Depth_to_bedrock_m,
               Treatment, Time_replicate, n_cores, Core_type, SOM_perc_mean:OC_perc_se, BD_reported_g_cm3_mean, 
               BD_reported_g_cm3_se, BD_reported_g_cm3_sd)


#### 4. add data type & combining raw with site-level data  ####

data5 <- data4 %>% 
  mutate(Data_type = case_when(Source == "Cusack et al 2018" | Source == "Gailis et al 2021" |
                                 Source == "Gispert et al 2020" | Source == "Gispert et al 2021" |
                                 Source == "Perera et al 2022" | Source == "Rathore et al 2016" |
                                 Source == "Yang et al 2021" | Source == "Yu and Chmura 2010" |
                                 Source == "Yuan et al 2019" | Source == "Voltz et al 2021"
                               | Source == "Hayes et al 2014"~ "Site-level",
                               Source == "Copertino et al under review" | 
                                 Source == "Fu et al 2021" | Source == "He et al 2020" |
                                 Source == "Hu et al 2020" | Source == "Meng et al 2019" |
                                 Source == "Wails et al 2021" | 
                                 Source == "Rovai compiled" | 
                                 Source == "Rovai compiled, reference cited in Chmura (2003)" |
                                 Source == "Rovai compiled, reference cited in Chmura (2003) and in Ouyang and Lee (2014)" |
                                 Source == "Rovai compiled, reference cited in Ouyang and Lee (2014)" |
                                 Source == "Rovai compiled, reference cited in Ouyang and Lee (2020)" 
                               ~ "Meta-analysis",
         TRUE ~ "Core-level")) %>% 
  relocate(Data_type, .before = OC_perc) %>% 
  mutate(OC_perc_combined = coalesce(OC_perc, OC_perc_mean)) %>% 
  mutate(SOM_perc_combined = coalesce(SOM_perc, SOM_perc_mean)) %>% 
  mutate(BD_reported_combined = coalesce(BD_reported_g_cm3, BD_reported_g_cm3_mean))


#### 5. change habitat_type to marsh_type ####

data6 <- data5 %>% 
  filter(is.na(OC_perc_combined) == FALSE | 
           is.na(SOM_perc_combined) == FALSE)


#### 5. remove rows with neither OC nor SOM data ####

data6 <- data5 %>% 
  filter(is.na(OC_perc_combined) == FALSE | 
           is.na(SOM_perc_combined) == FALSE)


#### 6. edit habitat type ####

table(data6$Habitat_type)

data7 <- data6 %>% 
  filter(Habitat_type != "tidal_freshwater_marsh",
           Habitat_type != "Freshwater" ,
           Habitat_type != "low sabkha" ,
           Habitat_type != "high sabkha")


#### 7. edit conversion factors ####

table(data7$Conv_factor)

data8 <- data7 %>% 
  mutate(Conv_factor = as.factor(Conv_factor)) %>% 
  mutate(Conv_factor = fct_recode(Conv_factor, 
                                  "OC = 0.47*OM + 0.0008*(OM^2)" = "%Corg = 0.47 x %LOI + 0.0008 x (%LOI)^2 ", #careful! space at end here
                                  "OC = 0.8559*OM + 0.1953" = "(0.8559*SOM_perc)+0.1953",
                                  "OC = 1.1345*OM - 0.8806" = "(1.1345*SOM_perc)-0.8806",
                                  "OC = 0.22*(OM^1.1)" = "0.22*x^1.1", 
                                  "OC = 0.4*OM + 0.0025*(OM^2)" = "0.4*x + 0.0025*x2", 
                                  "OC = 0.40*OM + 0.025*(OM^2)" = "0.40*x + (0.025*x)2", 
                                  "OC = 0.4068*OM + 0.6705" = "0.4068x+0.6705", 
                                  "OC = 0.44*OM - 1.33" = "0.44x -1.33", 
                                  "OC = 0.47*OM" = "0.47 from Craft 1991", 
                                  "OC = 0.47*OM + 0.0008" = "0.47*x+0.0008", 
                                  "OC = 0.58*OM" = "0.58", 
                                  "OC = 0.461*OM - 0.266" = "OC (% dw) = 0.461 x OM - 0.266", 
                                  "OC = 0.3102*OM - 0.066" = "OC = -0.066 + 0.3102*OM", 
                                  "OC = OM/1,724" = "SOM/1,724"))

#### 8. edit accuracy flag ####

data9 <- data8 %>% 
  mutate(accuracy_flag = fct_recode(accuracy_flag, 
                                    "direct from dataset" = "exact",
                                    "direct from dataset" = "RTK GPS",
                                    "estimated from GE" = "estimated from GEE"
                                    ))

#### 9. export cleaned data ####

path_out = 'reports/04_data_process/data/'

export_file <- paste(path_out, "data_cleaned.csv", sep = '') 
export_df <- data9

write.csv(export_df, export_file, row.names = F)

# 
# ### export for GEE
# 
# file_name <- paste(Sys.Date(),"data_cleaned", sep = "_")
# export_file_GEE <- paste(path_out, file_name, ".csv", sep = '')
# 
# data_unique <- data5 %>%
#   filter(is.na(Latitude) == FALSE & is.na(Longitude) == FALSE) %>%
#   distinct(Latitude, Longitude, .keep_all = TRUE)
# 
# 
# write.csv(data_unique, export_file_GEE, row.names = F)


