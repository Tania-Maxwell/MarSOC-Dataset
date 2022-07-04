## import data from Conrad et al 2019, Frontiers in Marine Science
## export for tidal marsh soil C (and previously mangrove soil C)
# contact Tania Maxwell, tlgm2@cam.ac.uk
# 04.07.22



library(tidyverse)
library(measurements) #to convert to decimal degrees

input_file <- "reports/03_data_format/data/core_level/Conrad_2019/Conrad_2019_SI_for_reformat.csv"

input_data0 <- read.csv(input_file)

##### format data  #####

input_data1 <- input_data0 %>% 
  slice(1:111) %>% # keep only relevant data
  rename_with(~ gsub("..", "_", .x, fixed = TRUE)) %>% #replacing .. in columns by _
  rename_with(~ gsub(".", "_", .x, fixed = TRUE)) #replacing . in columns by _


##### add informational  #####

source_name <- "Conrad et al 2019"
author_initials <- "SC"


input_data2 <- input_data1 %>% 
  mutate(Source = source_name,
         Source_abbr = author_initials,
         Site_name = paste(Source_abbr, Location, Core))

## add information from paper



#### site data #####


input_data3 <- input_data2 %>% 

  mutate(lat_detail = case_when(Location == "Coffs" ~ "30°18'0°", #South
                         Location == "Corindi"~ "29°59'03°", 
                         Location == "Wooli" ~ "29°51'17°"), 
         long_detail = case_when(Location == "Coffs" ~ "153°7'7°", #Eeast
                          Location == "Corindi"~ "153°13'38°", 
                          Location == "Wooli" ~ "153°13'41°"), 
         lat = gsub("°", " ",
                    gsub("'", " ", lat_detail)),
         long = gsub("°", " ",
                     gsub("'", " ", long_detail)),
         lat_dec_deg = measurements::conv_unit(lat, from = "deg_min_sec", to = "dec_deg"), #S , need to convert dec_deg to negative
         long_dec_deg = measurements::conv_unit(long, from = "deg_min_sec", to = "dec_deg"), #E , keep positive
         accuracy_flag = "estimated from Figure 1",
         accuracy_code = "3",
         Latitude = as.numeric(lat_dec_deg)*-1,
         Longitude = as.numeric(long_dec_deg),
         Year_collected = case_when(Location == "Coffs" ~ 2016, 
                                    Location == "Corindi"~ 2017,
                                    Location == "Wooli" ~ 2018),
         Country = "Australia")



##### horizon data  #####

#"Once collected, sediment cores were sectioned into 2 cm intervals"
#depth_interval_cm_ is middle of 2cm interval


# "Organic C content was calculated by multiplying the organic material, 
# determined from the loss on ignition (LOI) method, by 0.58"

input_data4 <- input_data3 %>% 
  mutate(U_depth_cm = depth_interval_cm_ - 1, #upper depth: interval -1 
         L_depth_cm = depth_interval_cm_ + 1, #lower depth: interval +1
         U_depth_m = U_depth_cm/100 , #cm to m
         L_depth_m = L_depth_cm/100,# cm to m
         Depth_to_bedrock = Depth_to_bedrock_cm_/100, #cm to m
         OC_perc_calc = C_content_g_C_per_g_sediment_*100, #convert to percent OC %
         SOM_perc = OC_perc_calc/0.58, #reconverting back to SOM using 0.58 factor
         BD_reported_g_cm3 = DBD_g_per_cm_3_)  #1 g cm-3 = 1 Mg m-3

input_data4$SOM_perc <- round(input_data4$SOM_perc, 2)


##### prepare for export  #####

## reformat
export_data <- input_data4 %>% 
  select(Source, Site_name, Location, Core, Habitat_type, Latitude, Longitude, 
         accuracy_flag, accuracy_code, Country, Year_collected, Depth_to_bedrock, U_depth_m, L_depth_m, 
         OC_perc_calc, SOM_perc, BD_reported_g_cm3)

## subset for marshes
export_data_marsh <- export_data %>% 
  filter(Habitat_type == "Saltmarsh")


## export

path_out = 'reports/03_data_format/data/exported/'

export_file <- paste(path_out, source_name, ".csv", sep = '') 
export_df <- export_data_marsh

write.csv(export_df, export_file)
