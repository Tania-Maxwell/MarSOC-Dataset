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


# test which columns have missing values
# note: Year_collected has been filled in as much as possible (NA = the original study did not mention the year)

test_NA <- data_paper %>% 
  filter(is.na(Country) == TRUE) # all from Rovai missing refs


#### 1. numbers for data paper ####


ntypes <- data_paper %>% 
  dplyr::group_by(Data_type, Source) %>% 
  dplyr::count()
ntypes   
#note: xia et al 2022 is both in core-level and meta-analysis

table(ntypes$Data_type)

nstudies <- length(table(data_paper$Source)) 
nstudies
#note: xia et al 2022 is both in core-level and meta-analysis


nlocations <- data_paper %>%
  distinct(Latitude, Longitude, .keep_all = TRUE) %>% 
  count()
nlocations

nsamples <- as.numeric(nrow(data_paper))
nsamples

ncountries <- length(table(data_paper$Country)) 
ncountries

country_table <- data_paper %>%  
  group_by(Country) %>% 
  distinct(Latitude, .keep_all = TRUE) %>% 
  count()


# ## saving the list of countries 
# library(gridExtra)
# png("data_paper/figures/sites_per_country.png", height = 50*nrow(country_table), width = 200*ncol(country_table))
# grid.table(country_table)
# dev.off()




SOM_and_OC <- data_paper %>%
  filter(OC_obs_est == "Observed") %>% 
  filter(is.na(SOM_perc_combined) == FALSE & is.na(OC_perc_combined) == FALSE) %>% 
  droplevels()

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


#percent of data with N data, bulk density

#N
nN_perc_data <- data_paper %>% 
  filter(is.na(N_perc) == FALSE)

nN_perc <- as.numeric(nrow(nN_perc_data))

#percent of data with N data
(nN_perc/nsamples)*100

# BD
nBD_data <- data_paper %>% 
  filter(is.na(BD_reported_g_cm3) == FALSE | 
           is.na(BD_reported_g_cm3_mean) == FALSE)

nBD<- as.numeric(nrow(nBD_data))

#percent of data with N data
(nBD/nsamples)*100


#### 2. export study IDs ####

path_out = 'data_paper/studies/'

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
  mutate(Conv_factor =  gsub("OC", "SOC",
                             gsub("OM", "SOM", Conv_factor))) %>% 
  dplyr::count()
conv_fact   


write.table(conv_fact, "data_paper/conversion_factors.txt", row.names =  FALSE,
            sep = ",")

SOM_and_OC_CCRCN <- data1 %>%
  filter(is.na(Latitude) == FALSE & is.na(Longitude) == FALSE) %>%
  filter(Source == "CCRCN") %>% 
  filter(is.na(SOM_perc_combined) == FALSE & is.na(OC_perc_combined) == FALSE) %>% 
  filter(Original_source != "Keshta et al 2020 a")
table(SOM_and_OC_CCRCN$Original_source)
nrow(SOM_and_OC_CCRCN)


##### 4b. conversion factor graph ####

conv_fact_xy <- conv_fact %>% 
  mutate(Conv_factor =  gsub("SOC", "y",
                             gsub("SOM", "x", Conv_factor))) %>% 
  dplyr::select(Conv_factor, Source)

x <- rep(1:100)
dat0 <- data.frame(x, y = 0.000663*(x^2) + 0.406*x - 0.63, Source  = "Our equation")
dat1 <- data.frame(x, y = 0.4*x + 0.0025*(x^2), Source  = "Craft equation: Burke et al 2022, 
                   \ Gu et al 2020, Wollenberg et al 2018")
dat2 <- data.frame(x, y = 0.58*x , Source  = "Conrad et al 2019")
dat3 <- data.frame(x, y = 0.47*x + 0.0008 , Source  = "Copertino et al under review")
dat4 <- data.frame(x, y = 0.3102*x - 0.066 , Source  = "Martins et al 2022, de los Santos et al 2022 (a)")
dat5 <- data.frame(x, y = 0.461*x - 0.266 , Source  = "de los Santos et al 2022 (b)")
dat6 <- data.frame(x, y = 0.44*x - 1.33  , Source  = "Gailis et al 2021")
dat7 <- data.frame(x, y = x/1.724 , Source  = "Gispert et al 2020, 2021")
dat8 <- data.frame(x, y = 0.8559*x + 0.1953, Source  = "Human et al 2022 eq a")
dat9 <- data.frame(x, y = 1.1345*x - 0.8806, Source  = "Human et al 2022 eq b")
dat10 <- data.frame(x, y = 0.44*x - 1.80, Source  = "Kohfeld et al 2022")
dat11 <- data.frame(x, y = 0.47*x, Source  = "Perera et al 2022")
dat12 <- data.frame(x, y = 0.47*x + 0.0008*(x^2) , Source  = "Ward 2020")
dat13 <- data.frame(x, y = 0.22*(x^1.1), Source  = "Ward et al 2021")

conv_fact_forgraph <- rbind(dat1, dat2, dat3, dat4, dat5, dat6,
                            dat7, dat8, dat9, dat10, dat11, 
                            dat12, dat13)


fig_conv_factors <- ggplot() +
  geom_line(data = conv_fact_forgraph, aes(x,y, color = Source), linetype = 2, size = 1)+
  geom_line(data = dat0, aes(x,y), color = 'black', size = 2)+
  theme_bw()+
  labs(title = "Conversion equations used by studies", 
       x = "Soil organic matter (%)", y = "Soil organic carbon (%)")+ 
  scale_color_viridis(name = "Source", discrete = TRUE, option = "H",
                      guide = guide_legend(override.aes = list(size = 5,
                                                               alpha = 1)))+
  theme(plot.title = element_text(size = 18, hjust = 0.5))+
  theme(legend.position = "right",
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 12),
        axis.text = element_text(size = 10, color = 'black'),
        axis.title = element_text(size = 12, color = 'black'))

fig_conv_factors


#### 5. export data for data paper ####

data_paper_export <- data_paper %>% 
  dplyr::select(-c(Habitat_type, accuracy_code, 
                   SOM_perc_Heiri, # only in Beasy & Ellison 
                   Depth_to_bedrock_m, # only in Conrad et al 2019 and Gailis et al 2021
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


#### 6. check papers ####

data_paper_noyear <- data_paper_export %>% 
  filter(is.na(Year_collected) == TRUE) %>% 
  droplevels()

table(data_paper_noyear$Source)



points_check <- data_paper_export %>% 
  mutate(Horizon_mid_depth_cm = (U_depth_m + (L_depth_m-U_depth_m)/2)*-100) %>% 
  ggplot(aes(x = Horizon_mid_depth_cm, y = OC_perc_final, color = Data_type))+
  coord_flip()+
  geom_point()+
  #geom_point(size = 0.5, color = 'darkgreen')+
  theme_bw()+
  labs(x = "Soil depth (cm)",
       y = "OC (%)")+
  facet_grid(~Data_type) +  
  theme(legend.position = "bottom",
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 12),
        axis.text = element_text(size = 10, color = 'black'),
        axis.title = element_text(size = 12, color = 'black'))
  

points_check




#### 7. export final data file ####

path_out = 'data_paper/'

file_name <- paste(Sys.Date(),"Maxwell_marshC_dataset", sep = "_")
export_file <- paste(path_out, file_name, ".csv", sep = '')
export_df <- data_paper_export

write.csv(export_df, export_file, row.names = F)


