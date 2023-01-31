## script to reorganize data for data paper
## global marsh soil C data paper 
# contact Tania Maxwell, tlgm2@cam.ac.uk
# 20.01.23

rm(list=ls()) # clear the workspace
library(tidyverse)


#import compiled data
input_file01 <- "reports/04_data_process/data/data_cleaned_SOMconverted.csv"

data0 <- read.csv(input_file01) 

data1 <- data0 %>% 
  #remove data with no OC_final data
  filter(is.na(OC_perc_final) == FALSE) %>% 
  mutate(Source = fct_recode(Source, "Rovai compiled" =  "Rovai compiled, reference cited in Chmura (2003)",
                             "Rovai compiled" = "Rovai compiled, reference cited in Chmura (2003) and in Ouyang and Lee (2014)",
                              "Rovai compiled" ="Rovai compiled, reference cited in Ouyang and Lee (2014)",
                              "Rovai compiled" ="Rovai compiled, reference cited in Ouyang and Lee (2020)" ))

data_paper <- data1 %>%
  filter(is.na(Latitude) == FALSE & is.na(Longitude) == FALSE) %>%
  filter(Source != "CCRCN") %>% 
  droplevels()






#### 1. numbers for data paper ####


ntypes <- data_paper %>% 
  dplyr::group_by(Data_type, Source) %>% 
  dplyr::count()
ntypes   

table(ntypes$Data_type)

nstudies <- length(table(data_paper$Source)) 
nstudies

nsamples <- nrow(data_paper)
nsamples

ncountries <- length(table(data_paper$Country)) 
ncountries

SOM_and_OC <- data_paper %>%
  filter(OC_obs_est == "Observed") %>% 
  filter(is.na(SOM_perc_combined) == FALSE & is.na(OC_perc_combined) == FALSE) 

nSOM_OC <- nrow(SOM_and_OC)
nSOM_OC
length(table(SOM_and_OC$Source)) - 1 # note: human et al 2022 has 2 conversion factors 


meta_analyses <- data_paper %>% 
  filter(Data_type == "Meta-analysis") %>% 
  group_by(Source, Original_source) %>% 
  dplyr::count()
meta_analyses   


#location accuracy
table(data_paper$accuracy_flag)


#### 2. export study IDs ####

path_out = 'data_paper/'

export_file <- paste(path_out, "studies_meta-analyses.csv", sep = '') 
export_df <- meta_analyses

write.csv(export_df, export_file, row.names = F)


#### 3. data type figure for data paper ####

data_paper_figure <- data_paper %>%
  distinct(Latitude, Longitude, .keep_all = TRUE)

library(sf) #to map
library(rnaturalearth) #privides map of countries of world
library(viridis) # for map colors
# https://sjmgarnier.github.io/viridis/
world <- ne_countries(scale = "medium", returnclass = "sf")

fig_paper <- ggplot(data = world) +
  geom_sf() +
  coord_sf(ylim = c(-60, 80), expand = FALSE)+
  theme_bw()+
  labs(title = "Global tidal marsh soil carbon dataset")+
  theme(plot.title = element_text(size = 18, hjust = 0.5))+
  geom_point(data = data_paper_figure, aes(x = Longitude, y = Latitude,
                                           fill = Data_type), size = 3, shape = 21, alpha = 0.5)+
  scale_size(range = c(2,8))+
  scale_fill_viridis(name = "Data Type:", discrete = TRUE, option = "D",
                     guide = guide_legend(override.aes = list(size = 5,
                                                              alpha = 1)))+
  theme(legend.position = "bottom",
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 12),
        axis.text = element_text(size = 10, color = 'black'),
        axis.title = element_text(size = 12, color = 'black'))

fig_paper

#### export figure
path_out = 'data_paper/figures/'


fig_name <- paste(Sys.Date(),"n_points", sep = "_")
export_file <- paste(path_out, fig_name, ".png", sep = '')

ggsave(export_file, fig_paper, width = 11.26, height = 6.11)


#### 4. conversion factor table ####

#see figure in 02_SOM_to_OC


conv_fact <- data_paper %>% 
  filter(is.na(Conv_factor) == FALSE) %>% 
  group_by(Source, Conv_factor) %>% 
  droplevels() %>% 
  dplyr::count()
conv_fact   

# write.table(conv_fact, "data_paper/conversion_factors.txt", row.names =  FALSE,
#             sep = ",")

SOM_and_OC_CCRCN <- data7 %>%
  filter(is.na(Latitude) == FALSE & is.na(Longitude) == FALSE) %>%
  filter(Source == "CCRCN") %>% 
  filter(is.na(SOM_perc_combined) == FALSE & is.na(OC_perc_combined) == FALSE) %>% 
  filter(Original_source != "Keshta et al 2020 a")
table(SOM_and_OC_CCRCN$Original_source)
nrow(SOM_and_OC_CCRCN)


#### 5. export data for data paper ####

data_paper_export <- data_paper %>% 
  dplyr::select(-c(Habitat_type, accuracy_code, 
                   SOM_perc_Heiri, # only in Beasy & Ellison 
                   Depth_to_bedrock_m, # only in Conrad et al 2019 and Gailis et al 2021
                   Core_type,
                   OC_perc_combined,
                   SOM_perc_combined,
                   BD_reported_combined)) %>%  # narrow vs wide cores - CSIDE Smeaton projects
  dplyr::rename(BD_g_cm3 = BD_reported_g_cm3,
                BD_g_cm3_mean = BD_reported_g_cm3_mean,
                BD_g_cm3_se = BD_reported_g_cm3_se,
                BD_g_cm3_sd = BD_reported_g_cm3_sd) %>% 
  dplyr::relocate(Original_source, Data_type, Site, Core, 
                  Plot, Site_name, .after = Source) %>% 
  dplyr::relocate(Country, Admin_unit, Year_collected, 
                  Year_collected_end, .after = accuracy_flag) %>% 
  dplyr::relocate(OC_perc, BD_g_cm3, SOM_perc, N_perc, 
                  Time_replicate, Treatment, .after = Conv_factor) %>% 
  dplyr:: relocate(n_cores, SOM_perc_mean, SOM_perc_sd, OC_perc_mean, 
                   OC_perc_sd, OC_perc_se, BD_g_cm3_mean,
                   BD_g_cm3_sd, BD_g_cm3_se, .after = Treatment)

str(data_paper_export)