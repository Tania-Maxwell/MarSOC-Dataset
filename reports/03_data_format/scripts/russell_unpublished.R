## import data from Sophie Russell and Alice Jones (alice.jones01@adelaide.edu.au)
## from University of Adelaide, Australia
## export for marsh soil C
# contact Tania Maxwell, tlgm2@cam.ac.uk
# 21.03.23


library(tidyverse)
input_file01 <- "reports/03_data_format/data/core_level/Russell_unpublished_email/Russell_unpublished.csv"

## keep only the submitted values 
input_data01 <- read.csv(input_file01) 


##### add informational 
source_name <- "Russell et al submitted"
author_initials <- "SKR"


input_data02 <- input_data01 %>% 
  mutate(Source = gsub("\\,", "",Source)) %>% 
  mutate(Site_name = paste(author_initials, Core)) %>% 
  mutate(accuracy_code = 1) %>% 
  mutate(across(where(is.character), str_trim)) %>%   # trim white spaces before and after character strings
  mutate(OC_perc = gsub("<0.25", "0",OC_perc)) %>%  # replace less than 0.25 with 0, as suggested by A. Jones
  mutate(OC_perc = as.numeric(OC_perc),
         BD_reported_g_cm3 = as.numeric(BD_reported_g_cm3))


#### export ####

export_data01 <- input_data02 %>% 
  dplyr::select(Source,  Site_name, Site, Core, Habitat_type, Country, Year_collected,
                Latitude, Longitude, accuracy_flag, accuracy_code,
                U_depth_m, L_depth_m, Method, OC_perc, BD_reported_g_cm3)


export_data02 <- export_data01 %>% 
  relocate(Source, Site_name, Site, Habitat_type, Latitude, Longitude, 
           accuracy_flag, accuracy_code, Country, Year_collected, .before = U_depth_m) %>% 
  arrange(Site, Habitat_type)

### submitted data ONLY (i.e. not the in prep data)
export_data03 <- export_data02 %>% 
  filter(Source == "Russell et al submitted")



## export

path_out = 'reports/03_data_format/data/exported/'

export_file <- paste(path_out, source_name, ".csv", sep = '') 
export_df <- export_data03

write.csv(export_df, export_file)

