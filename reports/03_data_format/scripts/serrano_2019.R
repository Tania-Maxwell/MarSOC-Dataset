## import data from Serrano et al 2019, CSIRO
## export for  marsh soil C
# contact Tania Maxwell, tlgm2@cam.ac.uk
# 08.06.22



library(tidyverse)
library(measurements) #to convert to decimal degrees

input_file <- "reports/03_data_format/data/core_level/Serrano_2019_CSIRO/TidalmarshSoilCstock_Serranoetal.csv"

input_data0 <- read.csv(input_file)

##### format data  #####

input_data1 <- input_data0 %>% 
  rename_with(~ gsub("..", "_", .x, fixed = TRUE)) %>% #replacing .. in columns by _
  rename_with(~ gsub(".", "_", .x, fixed = TRUE)) #replacing . in columns by _


##### add informational  #####

source_name <- "Serrano et al 2019"
author_initials <- "OS"


input_data2 <- input_data1 %>% 
  rename(Original_source = Source) %>% 
  mutate(Source = source_name,
         Source_abbr = author_initials,
         Site_name = paste(Source_abbr, State))


#### site data #####


input_data3 <- input_data2 %>% 
  mutate(accuracy_flag = "direct from dataset",
         accuracy_code = "1",
         Year_collected = "NA",
         Country = "Australia",
         Habitat_type = "Tidal marsh")

##### horizon data  #####

#in 1m thick soil
input_data4 <- input_data3 %>% 
  mutate(U_depth_m = 0, #m
         L_depth_m = 1,#m
         SOC_stock_MgC_ha = Soil_organic_carbon_stock_Mg_C_ha_1_in_1_m_thick_soil_)


##### prepare for export  #####

## reformat
export_data <- input_data4 %>% 
  select(Source, Site_name, Original_source, State, Habitat_type, Latitude, Longitude, 
         accuracy_flag, accuracy_code, Country, Year_collected, U_depth_m, L_depth_m, SOC_stock_MgC_ha)

## data already only Tidal marshes

## export

path_out = 'reports/03_data_format/data/exported/'

export_file <- paste(path_out, source_name, ".csv", sep = '') 
export_df <- export_data

write.csv(export_df, export_file)


