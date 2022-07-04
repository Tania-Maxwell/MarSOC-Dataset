
### NOTE: UNFINISHED. need to check papers cited. add year collected and country info ####
## need to reformat column names (include units)

## import data from Fehrer et al 2019, Ecosphere
## export for marsh soil C (and previously mangrove soil C)
# contact Tania Maxwell, tlgm2@cam.ac.uk
# 04.07.22

library(tidyverse)
library(measurements) #to convert to decimal degrees

input_file1 <- "reports/03_data_format/data/meta_analysis/Fehrer_2017/Fehrer_2017_SI-1_for_reformat.csv"

input_data01 <- read.csv(input_file1)

input_file2 <- "reports/03_data_format/data/meta_analysis/Fehrer_2017/Fehrer_2017_SI-2_for_reformat.csv"

input_data02 <- read.csv(input_file2)

##### format data  #####

input_data01 <- input_data01 %>% 
  rename_with(~ gsub("..", "_", .x, fixed = TRUE)) %>% #replacing .. in columns by _
  rename_with(~ gsub(".", "_", .x, fixed = TRUE)) #replacing . in columns by _

input_data02 <- input_data02 %>% 
  rename_with(~ gsub("..", "_", .x, fixed = TRUE)) %>% #replacing .. in columns by _
  rename_with(~ gsub(".", "_", .x, fixed = TRUE)) %>% #replacing . in columns by _
  rename(Original_source = Source) %>% 
  mutate(Review_source = "NA") %>% 
  relocate(Review_source, .before = Original_source)


input_data_merged <- rbind(input_data01, input_data02)

#### filter for marsh ####

input_data_mangrove <- input_data_merged %>% 
  filter(Type == "salt marsh")

#### TO DO: CHECK
input_data_mangrove_v2 <- input_data_mangrove %>% 
  filter(Original_source != "Cahoon & Lynch (1997)" ,
           Original_source != "Callaway et al. (1997)" ,
           Original_source != "Chen & Twilley (1999)" ,
           Original_source != "Osland et al. (2012)")

#### add info from papers ####

input_data_mangrove_v2 <- input_data_mangrove_v2 %>% 
  mutate(Year_collected = case_when(Original_source == "Ross et al. (2000)" ~ 1995, 
                                    Original_source == "Lynch (1989)" ~ "NA",
                                    Original_source == "Castaneda-Moya et al. (2013)" ~ "2001-2004", # MEANS ARE PRESENTED!!!
                                    Original_source == "Genthner et al. (2013)" ~ ,
                                    Original_source == "Koch & Madden (2001)" ~ ))


#### prepare for export ####

export_data <- input_data_mangrove_v3
  mutate(Country = case_when(Original_source == "Ross et al. (2000)" ~ "USA", 
                             Original_source == "Lynch (1989)" ~ "USA",
                             Original_source == "Castaneda-Moya et al. (2013)" ~ "USA",
                             Original_source == "Genthner et al. (2013)" ~ ,
                             Original_source == "Koch & Madden (2001)" ~ )
