## import data from Gispert 2020, CATENA and 
## 2021, Estuarine, Coastal and Shelf Science 
## from La Pletera, Spain
## export for marsh soil C
# contact Tania Maxwell, tlgm2@cam.ac.uk
# 25.10.22

## NOTE: UNFINISHED - asking for more detailed core-level data and 
# more detailed lat and long values

library(tidyverse)
input_file01 <- "reports/03_data_format/data/site_level/Gispert_2020_2021_email/LA_PLETERA_v2.csv"


input_data01 <- read.csv(input_file01) 


##### add informational 
source_name <- "Gispert et al 2020 2021"
author_initials <- "MG"

## unique ID for each row

input_data02 <- input_data01 %>% 
  mutate(Site_ID = case_when(Source == "Gispert et al 2020" ~ paste(Site, "2020",  seq(1:10)),
                             Source == "Gispert et al 2021" ~  paste(Site, "2021", seq(7:10)))) %>% 
  mutate(Source_abbr = author_initials,
         Site_name = paste(Source_abbr, Site_ID)) %>% 
  mutate(Country = fct_recode(Country, "Spain" = "SPAIN")) %>% 
  rename(n_cores = Core,
         SOM_perc_mean = SOM_perc,
         BD_reported_g_cm3_mean = BD_reported_g_cm3)

#### reformat data ####

input_data03 <- input_data02 %>% 
  mutate(accuracy_flag = "direct from dataset",
         accuracy_code = "1") 



#### export ####

export_data01 <- input_data03 %>% 
  dplyr::select(Source, Site_name, Site, n_cores, Habitat_type, Country, Year_collected,
                Latitude, Longitude, accuracy_flag, accuracy_code,
                U_depth_m, L_depth_m, Method, OC_perc_mean, OC_perc_sd, SOM_perc_mean, BD_reported_g_cm3_mean)


export_data02 <- export_data01 %>% 
  relocate(Source, Site_name, Site, n_cores, Habitat_type, Latitude, Longitude, 
           accuracy_flag, accuracy_code, Country, Year_collected, .before = U_depth_m) %>% 
  arrange(Site, Habitat_type)

## export

path_out = 'reports/03_data_format/data/exported/'

export_file <- paste(path_out, source_name, ".csv", sep = '') 
export_df <- export_data02

write.csv(export_df, export_file)




