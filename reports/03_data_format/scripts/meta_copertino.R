## import data from Margareth Copertino, southwestern Atlantic salt marsh review, under review
## export for marsh soil C
# contact Tania Maxwell, tlgm2@cam.ac.uk
# 17.10.22


library(tidyverse)
input_file01 <- "reports/03_data_format/data/meta_analysis/Copertino_review_email/Copertino_Review.csv"

input_data01 <- read.csv(input_file01) 

##reformat style of data

input_data02 <- input_data01 %>% 
  slice(1:286) %>%  #drop rows with NAs
  rename_with(~ gsub("..", "_", .x, fixed = TRUE)) %>% #replacing .. in columns by _
  rename_with(~ gsub(".", "_", .x, fixed = TRUE)) %>%    #replacing . in columns by _
  mutate(Original_source = gsub("\\.", "", Original_source)) %>% 
  mutate(Original_source = gsub("\\.", "", Original_source))


input_data02[,c("SOM_perc", "SOM_perc_mean", 
                "SOM_perc_sd", "OC_perc_mean", "OC_perc")] <- lapply(
                  input_data02[,c("SOM_perc", "SOM_perc_mean", 
                                  "SOM_perc_sd", "OC_perc_mean", "OC_perc")], 
                  gsub, pattern = "\\,", replacement = "\\.")

input_data02 <- input_data02 %>% 
  mutate(across(N_samples:g_C_Kg_1,str_trim)) %>% 
  mutate(across(SOM_perc:g_C_Kg_1, as.numeric))

### remove data in TM_commment that is to be deleted (data estimated from figure)

input_data03 <- input_data02 %>% 
  filter(TM_comment == "OK" | 
           TM_comment == "changed_data")




##### add informational  
source_name <- "Copertino et al under review"
author_initials <- "MC"


input_data04 <- input_data03 %>% 
  mutate(Source = source_name,
         Source_abbr = author_initials,
         Site_name = paste(Source_abbr, Core_ID),
         Habitat_type = "Salt marsh") %>% 
  rename(Core = Core_ID)


#### reformat data ####

input_data05 <- input_data04 %>% 
  mutate(Conv_factor = "0.47*x+0.0008",
         BD_estimated_factor = "(2.684-140.943*0.008)*exp(-0.008*OC (g.kg-1))",
    accuracy_flag = "direct from dataset",
         accuracy_code = "1") %>% 
  rename(Method = METHOD) %>% 
  mutate(Method = fct_recode(Method, "EA" = "CHN"),
         Country = fct_recode(Country, "Brazil" = "BR", 
                              "Argentina" = "UK/Argentina")) %>% 
  # calculating a sd for OC_perc when OC is calculated from SOM with a mean and sd
  #using same conversion factor
  mutate(OC_perc_sd = case_when(is.na(SOM_perc_sd) == FALSE ~ (0.47*SOM_perc_sd + 0.0008)))



## edit depth

input_data06 <- input_data05 %>% 
  separate(Section_interval_cm_, c("U_depth_cm", "L_depth_cm"), sep = '-') %>%   #separate upper and lower depth
  mutate(U_depth_m = as.numeric(U_depth_cm)/100 , #cm to m
         L_depth_m = as.numeric(L_depth_cm)/100)# cm to m

test <- input_data06 %>% 
  filter(is.na(L_depth_cm) == TRUE) ##kauffman study removed anyway (data already imported)

#### remove data from references already used ####
# kauffman

input_data07 <- input_data06 %>% 
  filter(Original_source != "Kaufmann et al 2018")


#### export ####

export_data01 <- input_data07 %>% 
  dplyr::select(Source, Site_name, Original_source, Site, Core, Habitat_type, Country, Year_collected,
                Latitude, Longitude, accuracy_flag, accuracy_code,
                U_depth_m, L_depth_m, Method, Conv_factor, SOM_perc,
                SOM_perc_mean, SOM_perc_sd, OC_perc, OC_perc_mean, OC_perc_sd,
                BD_reported_g_cm3)


export_data02 <- export_data01 %>% 
  relocate(Source, Site_name, Original_source, Site, Core, Habitat_type, Latitude, Longitude, 
           accuracy_flag, accuracy_code, Country, Year_collected, .before = U_depth_m) %>% 
  arrange(Site, Habitat_type)


## export

path_out = 'reports/03_data_format/data/exported/'

export_file <- paste(path_out, source_name, ".csv", sep = '') 
export_df <- export_data02

write.csv(export_df, export_file)


