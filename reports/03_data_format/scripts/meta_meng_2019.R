## import data from Meng et al 2019, Estuarine, Coastal and Shelf Science
## supplementary information
## export for marsh soil C (and previously mangrove soil C)
# contact Tania Maxwell, tlgm2@cam.ac.uk
# 20.09.22

# NOTE - this is an aggregated dataset. Raw values are in individual datasets 


library(tidyverse)
library(measurements) #to convert to decimal degrees
library(stringr)

input_file <- "reports/03_data_format/data/meta_analysis/Meng_2019/Meng_2019_SI_for_reformat.csv"

input_data0 <- read.csv(input_file)

input_file2 <- "reports/03_data_format/data/bind/data_compile.csv"

data_compile <- read.csv(input_file2)


##### format data  #####

input_data1 <- input_data0 %>% 
  rename_with(~ gsub("..", "_", .x, fixed = TRUE)) %>% #replacing .. in columns by _
  rename_with(~ gsub(".", "_", .x, fixed = TRUE)) %>%  #replacing . in columns by _
  mutate_if(is.character, as.factor)

##### add informational  #####

source_name <- "Meng et al 2019"
author_initials <- "WM"


input_data2 <- input_data1 %>% 
  mutate(Habitat_type = fct_recode(Habitat_type, "Mangrove" = "mangrove", 
                                   "Salt marsh" = "salt marsh", 
                                   "Salt marsh" = "Salt Marsh", 
                                   "Seagrass" = "seagrass beds")) %>% 
  mutate(Source = source_name,
         Source_abbr = author_initials,
         Site_name = paste(Source_abbr, Location)) %>% 
  rename(Original_source = Reference) %>% 
  mutate(Original_source = gsub("al.", "al", #replace . with nothing to match Sanderman refs
                                Original_source))


## add information from paper

#### site data #####

input_data3 <- input_data2 %>% 
  rename(lat_detail = Latitude,
         long_detail = Longitude) %>% 
  mutate(lat0 = gsub("°", " ", #replace ° with a space
                    gsub("'", " ", #replace ' with a space
                         gsub("\"", " ", #replace " with a space
                                   gsub("N", "", lat_detail)))),
         long0 = gsub("°", " ", #replace ° with a space
                     gsub("'", " ", #replace ' with a space
                          gsub("\"", " ", #replace " with a space
                                    gsub("E", "", long_detail)))),
         lat = str_replace_all(lat0, "  ", " "),
         long = str_replace_all(long0, "  ", " "),
         lat_dec_deg = measurements::conv_unit(lat, from = "deg_min_sec", to = "dec_deg"), #N , keep positive
         long_dec_deg = measurements::conv_unit(long, from = "deg_min_sec", to = "dec_deg"), #E , keep positive
         Latitude = as.numeric(lat_dec_deg),
         Longitude = as.numeric(long_dec_deg),
         accuracy_flag = "direct from dataset",
         accuracy_code = "4",
         Year_collected = "see original study",
         Country = "China")


##### horizon data  #####

input_data4 <- input_data3 %>% 
  separate(Core_depth, c("U_depth_cm", "L_depth_cm"), sep = '-') %>%  #separate upper and lower depth
  mutate(U_depth_m = as.numeric(U_depth_cm)/100 , #cm to m
         L_depth_m = as.numeric(L_depth_cm)/100) %>% # cm to m 
  rename(C_stock_MgC_ha = Soil_carbon_stock_MgC_ha) %>%   #1 g cm-3 = 1 Mg m-3
  mutate_if(is.character, as.factor)


#### subset for marshes ####


input_data5 <- input_data4 %>% 
  filter(Habitat_type == "Salt marsh")


##compare to other meta-analysis studies

data_test <- left_join(input_data5, data_compile, by = "Original_source")


## compare to other single-source data 
input_data_fortest <- input_data5 %>% 
  rename(This_paper = Source, 
         Source = Original_source) # rename to match the source column in all other datasets

data_test2  <- left_join(input_data_fortest, data_compile, by = "Source") 

## ref from Original_source Xu et al 2014 already extracted by Hu et al 2020

input_data6 <- input_data5 %>% 
  filter(Original_source != "Xu et al 2014")



#### export data ####

export_data <- input_data6 %>% 
  select(Source, Site_name, Original_source, Habitat_type, Latitude, Longitude, 
         accuracy_flag, accuracy_code, Country, Year_collected, U_depth_m, L_depth_m, 
         C_stock_MgC_ha)



## export

path_out = 'reports/03_data_format/data/exported/'

export_file <- paste(path_out, source_name, ".csv", sep = '') 
export_df <- export_data

write.csv(export_df, export_file)

