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
         Habitat_type = vg_typ) %>% 
  mutate(accuracy_flag = "direct from dataset",
         accuracy_code = "1")
  

test <- input_data03 %>% 
  mutate(Core_site = coalesce(Site, Core)) %>% 
  relocate( Core,Core_site, .after = Site)
#rename source "This study" to Rovai

input_data03$Source <- input_data03$Source %>% 
  fct_relabel(~ gsub("This study", "Rovai compiled", .x))


#making carbon data  match main dataset
input_data04 <- input_data03 %>% 
  mutate(OC_perc = fraction_carbon*100,
         SOM_perc = fraction_organic_matter*100) %>% 
  dplyr::rename(BD_reported_g_cm3 = dry_bulk_density) %>% 
  mutate(Original_source = as.factor(Original_source))


#### adding year_collected and method - investigated in each study

levels(input_data04$Original_source)

sources <- input_data04 %>% 
  group_by(Source, Original_source) %>% 
  count()


input_data05 <- input_data04 %>% 
  mutate(Year_collected = case_when(Original_source == "" ~ ,))

list(input_data04$Original_source)


#### export

export_data01 <- input_data05 %>% 
  dplyr::select(Source, Original_source, Core, Habitat_type, Country,
                Latitude, Longitude, accuracy_flag, accuracy_code,
                U_depth_m, L_depth_m, OC_perc, SOM_perc, BD_reported_g_cm3)
  
#write.csv(export_data01, "Data from Andre.csv")


### exploring the data


data_subset <- export_data01 %>% 
  filter(Latitude >60) %>% 
  dplyr::select(Source, Original_source, Latitude, Longitude, Core, U_depth_m, L_depth_m)





