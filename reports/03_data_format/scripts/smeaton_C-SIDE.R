## import data from Smeaton et al unpublished C-side dataset
## from 1323 sampling sites across UK saltmarshes
## export for marsh soil C
# contact Tania Maxwell, tlgm2@cam.ac.uk
# 01.09.22



library(tidyverse)
input_file01 <- "reports/03_data_format/data/core_level/Smeaton_unpublished_C-SIDE/Physical_geochemical_properties_narrow_cores.csv"

narrow_cores01 <- read.csv(input_file01) %>% 
  mutate(Core_type = "Narrow")


input_file02 <- "reports/03_data_format/data/core_level/Smeaton_unpublished_C-SIDE/Physical_geochemical_properties_wide_cores.csv"

wide_cores01 <- read.csv(input_file02) %>% 
  mutate(Core_type = "Wide")


### combine 

input_data01 <- bind_rows(narrow_cores01, wide_cores01)


##### add informational  
source_name <- "Smeaton unpublished C-SIDE"
author_initials <- "CS"


input_data02 <- input_data01 %>% 
  mutate(Source = source_name,
         Source_abbr = author_initials,
         Site_name = paste(Source_abbr, Core_ID),
         Habitat_type = "Saltmarsh",
         Country = "UK") %>% 
  rename(Plot = Core_ID,
         Site = Saltmarsh)

#### reformat data ####

input_data03 <- input_data02 %>% 
  rename(Latitude = Latitude_Dec_Degree,
         Longitude = Longitude_Dec_Degree,
         OC_perc = OC_Perc, 
         N_perc = N_Perc,
         BD_reported_g_cm3 = Dry_bulk_density_g_cm_3,
         Year_collected = Collection_Year) %>% 
  mutate(accuracy_flag = "direct from dataset",
         accuracy_code = "1") %>% 
  mutate(Method = "EA")


## edit depth

input_data04 <- input_data03 %>% 
  mutate(Core_depth_cm = gsub("-", "_", Core_depth_cm)) %>% #some core depths were separated by - instead of _
  separate(Core_depth_cm, c("U_depth_cm", "L_depth_cm"), sep = '_') %>%   #separate upper and lower depth
  mutate(U_depth_m = as.numeric(U_depth_cm)/100 , #cm to m
         L_depth_m = as.numeric(L_depth_cm)/100)# cm to m


#### export ####

export_data01 <- input_data04 %>% 
  dplyr::select(Source, Site_name, Site, Plot, Habitat_type, Substrate, Country, Nation, Year_collected,
                Latitude, Longitude, accuracy_flag, accuracy_code,
                U_depth_m, L_depth_m, Core_type, Method, OC_perc, N_perc, BD_reported_g_cm3)


export_data02 <- export_data01 %>% 
  relocate(Source, Site_name, Site, Plot, Habitat_type,Substrate, Latitude, Longitude, 
           accuracy_flag, accuracy_code, Country, Nation, Year_collected, .before = U_depth_m) %>% 
  arrange(Site, Habitat_type)

## export

path_out = 'reports/03_data_format/data/exported/'

export_file <- paste(path_out, source_name, ".csv", sep = '') 
export_df <- export_data02

write.csv(export_df, export_file)





