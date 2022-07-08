## import data from CCRCN
## need to cite individual studies
## export for marsh soil C 
# contact Tania Maxwell, tlgm2@cam.ac.uk
# 07.07.22

library(tidyverse)

input_file1 <- "reports/03_data_format/data/core_level/CCRCN_data/CCRCN_depthseries.csv"
input_file2 <- "reports/03_data_format/data/core_level/CCRCN_data/CCRCN_cores.csv"

input_depthseries <- read.csv(input_file1)
input_cores <- read.csv(input_file2)

input_data01 <- right_join(input_cores, input_depthseries,
                        by = c("study_id", "site_id","core_id"))


#### reformat to match other datasets
input_data01$study_id <- input_data01$study_id %>% 
  fct_relabel(~ gsub("_", " ", .x)) %>% 
  fct_relabel(~ gsub("etal", "et al", .x))%>% 
  fct_relabel(~ gsub("\\(", "", .x)) %>% 
  fct_relabel(~ gsub("\\)", "", .x))



input_data02 <- input_data01 %>% 
  mutate(U_depth_m = depth_min/100, #cm to m
         L_depth_m = depth_max/100,
         Source = "CCRCN") %>%  #cm to m
  dplyr::rename(Original_source = study_id,
                Country = country,
                Latitude = latitude,
                Longitude = longitude,
                Site = site_id,
                Core = core_id,
                Habitat_type = habitat,
                State = admin_division,) 

#### export


export_data <- input_data02 %>% 
  select(Source, Original_source, Site, Core, Habitat_type, Latitude, Longitude, 
         Country, U_depth_m, L_depth_m)


# select(Source, Original_source, Site_name, Site, Core, Habitat_type, Latitude, Longitude, 
#        accuracy_flag, accuracy_code, Country, Year_collected, U_depth_m, L_depth_m, 
#        Method, Conv_factor, OC_perc, SOM_perc, BD_reported_g_cm3)

## export

source_name <- "CCRCN"
path_out = 'reports/03_data_format/data/exported/'

export_file <- paste(path_out, source_name, ".csv", sep = '') 
export_df <- export_data

write.csv(export_df, export_file)

