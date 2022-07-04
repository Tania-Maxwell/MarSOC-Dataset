
### NOTE: UNFINISHED. need to check papers cited. whether to include BD, OC estimated ####


## import data from Fu et al 2021, Global Change Biology
## export for marsh soil C (and previously mangrove soil C)
# contact Tania Maxwell, tlgm2@cam.ac.uk
# 04.07.22

library(tidyverse)
library(measurements) #to convert to decimal degrees
library(stringr) # extract first n values for date

input_file <- "reports/03_data_format/data/meta_analysis/Fu_2021/Fu_2021_SI_for_reformat.csv"

input_data0 <- read.csv(input_file)

##### format data  #####

input_data0[input_data0 == "nd"] <- NA_real_

source_name <- "Fu et al 2021"
author_initials <- "CF"

input_data1 <- input_data0 %>% 
  slice(1:207) %>% 
  rename(Habitat_type = Type,
         Original_source = Source) %>% 
  mutate_if(is.character, as.factor)


input_data1 <- input_data1 %>% 
  group_by(Habitat_type) %>% 
  mutate(id = row_number()) %>% #id number for each ecosystem type
  ungroup() %>% 
  mutate(Source = source_name,
         Source_abbr = author_initials,
         Site_name = paste(Source_abbr, Habitat_type, id))


input_data2 <- input_data1 %>% 
  #create Year_collected column from first 4 values of date 
  mutate(Year_collected = str_sub(input_data1$Sampling_date_year.month.date, 1,4)) %>% 
  mutate(Latitude = as.numeric(as.character(Latitude_N)),
         Longitude = as.numeric(as.character(Longitude_E)),
         Country = "China",
         U_depth_m = 0,
         L_depth_m = 1) %>% 
  mutate(accuracy_code = case_when(is.na(accuracy_flag) ~ NA_real_,
                                   accuracy_flag == "estimated from map" ~ 2,
                                   accuracy_flag == "exact" ~ 1,
                                   accuracy_flag == "no location" ~ NA_real_,
                                   accuracy_flag == "" ~ NA_real_),
         #only including OC reported, NOT extrapolated values
          OC_perc = case_when(is.na(SOC_accuracy) ~ NA_real_, 
                  SOC_accuracy == "reported" ~ as.numeric(as.character(SOC_percent)),
                   SOC_accuracy == "extrapolated" ~ NA_real_),
         #only including BP_reported, NOT BD values calcualted from OC or extrapolated
         BD_reported_g_cm3 = case_when(DBD_accuracy == "reported" ~ as.numeric(as.character(DBD_g_cm3)),
                                 TRUE ~ NA_real_))

input_data2$accuracy_code <-as.factor(input_data2$accuracy_code) 


#### compare to Sanderman v1 ####,


input_file <- "Sanderman_mangroveC_refs.csv"

sanderman_refs <- read.csv(input_file)

sanderman_refs <- sanderman_refs[c(1:149), c(1:3)]

sanderman_refs <- sanderman_refs %>% 
  rename(Original_source = Source)

test_join <- inner_join(sanderman_refs, input_data2, by = "Original_source")
table(test_join$Original_source)

## remove Xia et al 2015 and Wang et al 2013

input_data3 <- input_data2 %>% 
  filter(Original_source != "Xia et al 2015",
         Original_source != "Wang et al 2013")



##### prepare for export  #####

## reformat
export_data <- input_data3 %>% 
  select(Source, Site_name, Original_source, Site, Habitat_type, Latitude, Longitude, accuracy_flag, 
         accuracy_code, Country, Year_collected, U_depth_m, L_depth_m, 
         OC_perc, BD_reported_g_cm3, Age_status, Reference_detail)

## subset for mangroves

export_data_marsh <- export_data %>% 
  filter(Habitat_type == "Salt marsh")


## export

path_out = 'reports/03_data_format/data/exported/'

export_file <- paste(path_out, source_name, ".csv", sep = '') 
export_df <- export_data_marsh

# write.csv(export_df, export_file)


