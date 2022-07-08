## import data compiled by Andre Rovai (personal communication)
## export for marsh soil C 
# contact Tania Maxwell, tlgm2@cam.ac.uk
# 07.07.22

library(tidyverse)

### need to check DBD and org C units!
##create a Site_name column??

setwd("~/07_Cam_postdoc/Data")
input_file01 <- "Andre_marsh_tidalfresh.csv"

input_data01 <- read.csv(input_file01)


#### subset to remove CCRCN data (already have this data) ####

input_data02 <- input_data01 %>% 
  filter(Collated_by != "CCRCN")



#### reformat to match other datasets
input_data02$study_id.x <- input_data02$study_id.x %>% 
  fct_relabel(~ gsub("_", " ", .x)) %>% 
  fct_relabel(~ gsub("etal", "et al", .x))%>% 
  fct_relabel(~ gsub("\\(", "", .x)) %>% 
  fct_relabel(~ gsub("\\)", "", .x))

input_data03 <- input_data02 %>% 
  mutate(U_depth_m = depth_min/100, #cm to m
         L_depth_m = depth_max/100) %>%  #cm to m
  dplyr::rename(Source = Collated_by,
    Original_source = study_id.x,
    Country = country,
         Latitude = core_latitude,
         Longitude = core_longitude,
         Site = site_id.x,
         Core = core_id,
         Habitat_type = vg_typ) 
  
#rename source "This study" to Rovai

input_data03$Source <- input_data03$Source %>% 
  fct_relabel(~ gsub("This study", "Rovai compiled", .x))


export_data <- input_data03 %>% 
  select(Source, Original_source, Site, Core, Habitat_type, Latitude, Longitude, 
         Country, U_depth_m, L_depth_m)
  
  
  # select(Source, Original_source, Site_name, Site, Core, Habitat_type, Latitude, Longitude, 
  #        accuracy_flag, accuracy_code, Country, Year_collected, U_depth_m, L_depth_m, 
  #        Method, Conv_factor, OC_perc, SOM_perc, BD_reported_g_cm3)

write.csv(export_data, "Data from Andre.csv")




