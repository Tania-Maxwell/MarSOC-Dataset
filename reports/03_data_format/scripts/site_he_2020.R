## import data from He et al 2020, supplementary info
# https://doi.org/10.1098/rstb.2019.0451 
## meta-analysis, effect of consumer 
## export for marsh soil C
# contact Tania Maxwell, tlgm2@cam.ac.uk
# 26.07.22

library(tidyverse)


input_file01 <- "reports/03_data_format/data/site_level/He_2020_SI/He_2020_SI.csv"

input_data01 <- read.csv(input_file01)

input_data01 <- input_data01 %>% 
  slice(1:947) %>% 
  dplyr::select(-X)

input_file02 <- "reports/03_data_format/data/site_level/He_2020_SI/He_2020_SI_studies.csv"

study_IDs <- read.csv(input_file02)

input_data02 <- full_join(input_data01, study_IDs, by = "PublicationID")



##### add informational  
source_name <- "He et al 2020"
author_initials <- "QH"

## renaming author names
input_data02$Author <- as.factor(input_data02$Author) 
levels(input_data02$Author) <- gsub("_", " ", levels((input_data02$Author)))


input_data03 <- input_data02 %>% 
  rename(Habitat_type = Ecosystem) %>% 
  mutate(Original_source = paste(Author, Year, sep = " ")) %>% 
  mutate(Source = source_name,
         Source_abbr = author_initials,
         Site_name = paste(Source_abbr, DataID),
         Country_detail = Country)


### renaming country names
## wanted to separate USA and state by _
#first need to separate The_Netherlands to Netherlands
input_data03$Country <- as.factor(input_data03$Country) 
levels(input_data03$Country) <- gsub("The_", "", levels((input_data03$Country)))


input_data04 <-  input_data03 %>% 
  separate(Country, c("Country", "State"), sep = '_')   #separate country and state


#### reformat data ####

input_data05 <- input_data04 %>% 
  rename(Year_collected = Year) %>% 
  mutate(accuracy_flag = "direct from dataset",
         accuracy_code = "2") %>% 
  mutate(Method = NA) %>% 
  separate(Soil_core_depth, c("U_depth_cm", "L_depth_cm"), sep = '-') %>%   #separate upper and lower depth
  mutate(U_depth_m = as.numeric(U_depth_cm)/100 , #cm to m
         L_depth_m = as.numeric(L_depth_cm)/100)# cm to m


#### filter data ####

input_data05$Carbon_measure <- as.factor(input_data05$Carbon_measure) 

input_data_soil1 <- input_data05 %>% 
  filter(Carbon_measure == "Soil_OCcon" | Carbon_measure == "Soil_OCden" | 
           Carbon_measure == "Soil_TCcon" | Carbon_measure == "Soil_TCden" | 
           Carbon_measure == "Soil_BD" | Carbon_measure == "Soil_CS") %>% 
  filter(Habitat_type == "Marsh")

str(input_data_soil1)


### pivot table to extract relevant data 
input_data_soil2 <- input_data_soil1 %>% 
  pivot_longer(cols = c("n1":"SD2")) %>% 
  mutate(Treatment = case_when(name == "n1"|
                                 name == "mean1" |
                                 name == "SD1" ~ "Control",
                               name == "n2"|
                                 name == "mean2" |
                                 name == "SD2" ~ "Consumer presence")) %>% 
  mutate(name = fct_recode(name, "n" = "n1", "mean" = "mean1", "SD" = "SD1",
                           "n" = "n2", "mean" = "mean2", "SD" = "SD2"))

input_data_soil3 <- input_data_soil2 %>% 
  pivot_wider(names_from = c("Carbon_measure","name"),
              values_from = "value")

               