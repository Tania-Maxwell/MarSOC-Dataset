## script to reorganize data for data paper
## global marsh soil C data paper 
# contact Tania Maxwell, tlgm2@cam.ac.uk
# 20.01.23

rm(list=ls()) # clear the workspace
library(plyr) # rbind.fill
library(tidyverse)
library(misty) # to calculate ci of median
library(ggpubr) # for ggarrange 
library(viridis)


#import compiled data
input_file01 <- "reports/04_data_process/data/data_cleaned_SOMconverted.csv"

data0 <- read.csv(input_file01) 

#recently published paper
data0$Source <- recode(data0$Source, "Mazarrasa et al in prep" = "Mazarrasa et al 2023")
data0$Source <- recode(data0$Source, "Copertino et al under review" = "Hatje et al 2023")

data1 <- data0 %>% 
  #remove data with no OC_final data
  filter(is.na(OC_perc_final) == FALSE) %>% ## this also removes all items tagged as outliers
  filter(is.na(U_depth_m) == FALSE)
  # mutate(Source = fct_recode(Source, "Rovai compiled" =  "Rovai compiled, reference cited in Chmura (2003)",
  #                            "Rovai compiled" = "Rovai compiled, reference cited in Chmura (2003) and in Ouyang and Lee (2014)",
  #                             "Rovai compiled" ="Rovai compiled, reference cited in Ouyang and Lee (2014)",
  #                             "Rovai compiled" ="Rovai compiled, reference cited in Ouyang and Lee (2020)" ))

data_paper <- data1 %>%
  filter(is.na(Latitude) == FALSE & is.na(Longitude) == FALSE) %>%
  filter(Source != "CCRCN") %>% 
  droplevels() %>% 
  mutate(Horizon_bin_cm = as.factor(Horizon_bin_cm),
         Horizon_bin_cm = fct_relevel(Horizon_bin_cm, "100cm and up", 
                                      "50-100cm", "30-50cm", "15-30cm",
                                      "0-15cm" 
         ) ) 

table(data_paper$Source)
# test which columns have missing values
# note: Year_collected has been filled in as much as possible (NA = the original study did not mention the year)

test_NA <- data0 %>% 
  filter(is.na(U_depth_m) == TRUE) 

table(test_NA$Original_source)

#### 1. numbers for data paper ####


ntypes <- data_paper %>% 
  dplyr::group_by(Data_type, Source) %>% 
  dplyr::count()
ntypes   
#note: xia et al 2022 is both in core-level and review

table(ntypes$Data_type) #note: xia et al 2022 is both in core-level and review

nstudies <- length(table(data_paper$Source)) 
nstudies




# ## saving the list of countries 
# library(gridExtra)
# png("data_paper/figures/sites_per_country.png", height = 50*nrow(country_table), width = 200*ncol(country_table))
# grid.table(country_table)
# dev.off()


SOM_and_OC <- data_paper %>%
  filter(OC_obs_est == "Observed") %>% 
  filter(is.na(SOM_perc_combined) == FALSE & is.na(OC_perc_combined) == FALSE) %>% 
  droplevels()

# from CCRCN
SOM_and_OC_CCRCN <- data0 %>% 
  filter(is.na(Latitude) == FALSE & is.na(Longitude) == FALSE) %>%
  filter(Source == "CCRCN")  %>% 
  filter(is.na(SOM_perc_combined) == FALSE & is.na(OC_perc_combined) == FALSE)


nSOM_OC <- nrow(SOM_and_OC)
nSOM_OC
length(table(SOM_and_OC$Source)) - 1 # note: human et al 2022 has 2 conversion factors 


reviews <- data_paper %>% 
  filter(Data_type == "Review") %>% 
  group_by(Source, Original_source) %>% 
  dplyr::count()
reviews   

table(reviews$Source) 

#location accuracy
table(data_paper$accuracy_flag)





#### 2. export study IDs ####

path_out = 'data_paper/studies/'


export_file <- paste(path_out, "studies.csv", sep = '')
export_df <- ntypes

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
  labs(title = "Global tidal marsh soil organic carbon dataset")+
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

##### figs for EGU 
data_model_figure_CCRCN <- data1 %>%
  filter(is.na(Latitude) == FALSE & is.na(Longitude) == FALSE) %>% 
  filter(Source == "CCRCN") %>% 
  mutate(`Dataset source` = case_when(Source == "CCRCN" ~ "CCRCN",
                                      TRUE ~ "Compiled dataset")) %>%
  distinct(Latitude, Longitude, .keep_all = TRUE) 

fig_model_CCRCN <- ggplot(data = world) +
  geom_sf() +
  coord_sf(ylim = c(-60, 80), expand = FALSE)+
  theme_bw()+
  theme(plot.title = element_text(size = 18, hjust = 0.5))+
  geom_point(data = data_model_figure_CCRCN, aes(x = Longitude, y = Latitude,
                                                 fill = `Dataset source`), 
             shape = 21, size = 3, alpha = 0.4)+
  scale_fill_manual(name = "Data source",values = c("#5ec962"))+
  # geom_point(data = data_model_figure, aes(x = Longitude, y = Latitude, 
  #                                    fill = `Dataset source`), shape = 21, size = 3, alpha = 0.4)+
  # scale_fill_manual(name = "Data source",values = c("#fcfdbf", "#721f81"))+

  guides(col = guide_legend(ncol = 2))+
  guides(fill = guide_legend(override.aes = list(alpha = 1)))+
  theme(legend.position = "bottom",
        legend.title = element_text(size = 14),
        legend.text = element_text(size = 14),
        axis.text = element_text(size = 12, color = 'black'),
        axis.title = element_text(size = 14, color = 'black'))

fig_model_CCRCN


data_model_figure_ours <- data1 %>%
  filter(is.na(Latitude) == FALSE & is.na(Longitude) == FALSE) %>% 
  filter(Source != "CCRCN") %>% 
  mutate(`Dataset source` = case_when(Source == "CCRCN" ~ "CCRCN",
                                      TRUE ~ "Compiled dataset")) %>%
  distinct(Latitude, Longitude, .keep_all = TRUE) 

fig_model_ours <- ggplot(data = world) +
  geom_sf() +
  coord_sf(ylim = c(-60, 80), expand = FALSE)+
  theme_bw()+
  theme(plot.title = element_text(size = 18, hjust = 0.5))+
  geom_point(data = data_model_figure_ours, aes(x = Longitude, y = Latitude,
                                                 fill = `Dataset source`), 
             shape = 21, size = 3, alpha = 0.4)+
  scale_fill_manual(name = "Data source",values = c("#440154"))+
  # geom_point(data = data_model_figure, aes(x = Longitude, y = Latitude, 
  #                                    fill = `Dataset source`), shape = 21, size = 3, alpha = 0.4)+
  # scale_fill_manual(name = "Data source",values = c("#fcfdbf", "#721f81"))+
  
  guides(col = guide_legend(ncol = 2))+
  guides(fill = guide_legend(override.aes = list(alpha = 1)))+
  theme(legend.position = "bottom",
        legend.title = element_text(size = 14),
        legend.text = element_text(size = 14),
        axis.text = element_text(size = 12, color = 'black'),
        axis.title = element_text(size = 14, color = 'black'))

fig_model_ours


##### export Fig. 2 n points ####
path_out = 'data_paper/figures/'

#fig_name <- "fig_model_forEGU_ours"
fig_name <- "n_points"
export_file <- paste(path_out, fig_name, ".png", sep = '')

ggsave(export_file, fig_paper, width = 11.26, height = 6.11)


##### 3b. data points with maximum depth ####

max_depth <- data1 %>%
  filter(is.na(Latitude) == FALSE & is.na(Longitude) == FALSE) %>% 
  mutate(`Dataset source` = case_when(Source == "CCRCN" ~ "CCRCN",
                                      TRUE ~ "Compiled dataset")) %>%
  group_by(`Dataset source`, Source, Latitude, Longitude, Site_name) %>% 
  summarise(max_depth = max(L_depth_m))
  distinct(Latitude, Longitude, .keep_all = TRUE) 

fig_max_depth <- ggplot(data = world) +
    geom_sf() +
    coord_sf(ylim = c(-60, 80), expand = FALSE)+
    theme_bw()+
    labs(title = "Global tidal marsh soil organic carbon dataset")+
    theme(plot.title = element_text(size = 18, hjust = 0.5))+
    geom_point(data = max_depth, aes(x = Longitude, y = Latitude,
                                             fill = `Dataset source`, 
                                     size = log(max_depth)), shape = 21, alpha = 0.5)+
    scale_size(range = c(2,8))+
    scale_fill_viridis(name = "Data Type:", discrete = TRUE, option = "D",
                       guide = guide_legend(override.aes = list(size = 5,
                                                                alpha = 1)))+
    theme(legend.position = "bottom",
          legend.title = element_text(size = 12),
          legend.text = element_text(size = 12),
          axis.text = element_text(size = 10, color = 'black'),
          axis.title = element_text(size = 12, color = 'black'))
  
fig_max_depth

#### 4. figure distribution of points ####

BD_hist <- data_paper %>%
  ggplot()+
  geom_histogram(aes(BD_reported_combined), color = "black", fill = "#fcfdbf",  binwidth = 0.1)+
  theme_bw()+
  labs(x = "Dry bulk density (g cm-3)",
       y = "Count")+
  theme(legend.position = "none",
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 12),
        axis.text = element_text(size = 10, color = 'black'),
        axis.title = element_text(size = 12, color = 'black'))


SOM_hist <- data_paper %>%
  ggplot()+
  geom_histogram(aes(SOM_perc_combined), color = "black", fill = "#fe9f6d",  binwidth = 4)+
  theme_bw()+
  labs(x = "Organic matter (%)",
       y = "Count")+
  theme(legend.position = "none",
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 12),
        axis.text = element_text(size = 10, color = 'black'),
        axis.title = element_text(size = 12, color = 'black'))



OC_hist <- data_paper %>%
  ggplot()+
  geom_histogram(aes(OC_perc_final), color = "black", fill = "#de4968",  binwidth = 2)+
  theme_bw()+
  labs(x = "Organic carbon (%)",
       y = "Count")+
  scale_y_continuous(breaks = c(1500, 3000, 4500))+
  theme(legend.position = "none",
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 12),
        axis.text = element_text(size = 10, color = 'black'),
        axis.title = element_text(size = 12, color = 'black'))


#### density and stocks just for data paper
data_paper_stocks <- data_paper %>% 
  mutate(Horizon_bin_cm = as.factor(Horizon_bin_cm)) %>% 
  filter(Horizon_bin_cm == "0-15cm" |
           Horizon_bin_cm == "15-30cm" |
           Horizon_bin_cm == "30-50cm" |
           Horizon_bin_cm == "50-100cm" ) %>%  
  droplevels() %>% 
  mutate(Horizon_thick_m = L_depth_m - U_depth_m) %>% 
  mutate(OCD_g_cm3 = BD_reported_combined * (OC_perc_final/100), #convert from percent to fraction
         OCD_kg_m3 = OCD_g_cm3*1000, #1,000,000 cm3 in 1 m3 and 1,000 g in 1 kg
         OCS_kg_m2 = OCD_kg_m3*Horizon_thick_m,
         OCS_t_ha = OCS_kg_m2*10) %>% 
  relocate(Horizon_thick_m,Horizon_bin_cm,
           OCD_g_cm3,OCD_kg_m3,OCS_kg_m2, OCS_t_ha, .after = L_depth_m)  


SOCD_hist <- data_paper_stocks %>%
  ggplot()+
  geom_histogram(aes(OCD_g_cm3), color = "black", fill = "#8c2981",  binwidth = 0.01)+
  theme_bw()+
  scale_y_continuous(breaks = c(1000, 2000, 3000))+
  labs(x = "Carbon density (g cm-3)",
       y = "Count")+
  theme(axis.text = element_text(size = 10, color = 'black'),
        axis.title = element_text(size = 12, color = 'black'))


distribution_plots_final <- ggarrange(BD_hist, SOM_hist + rremove("ylab"), 
                                      OC_hist+ rremove("ylab"), 
                                      SOCD_hist + rremove("ylab"),
                                      ncol = 4, nrow = 1,
                                      # vjust= 0.2,
                                      labels = c("(a)", "(b)", "(c)", "(d)"),
                                      font.label=list(color="black",size=10))
distribution_plots_final

##### export Fig. 3 final distribution figs ####
path_out = 'data_paper/figures/'

export_fig <- distribution_plots_final
fig_main_name <- "distribution_plots_final"
export_file <- paste(path_out, fig_main_name, ".png", sep = '')
ggsave(export_file, export_fig, width = 8.55, height = 3.97)


#### 5. SOC density and stocks using data paper and CCRCN ##### 

all_stocks <- data1 %>%
  filter(L_depth_m < 1.05) %>% # taking out cores deeper than 1m
  filter(is.na(Latitude) == FALSE & is.na(Longitude) == FALSE) %>%
  droplevels() %>% 
  mutate(Horizon_bin_cm = as.factor(Horizon_bin_cm),
         Horizon_bin_cm = fct_relevel(Horizon_bin_cm, "100cm and up", 
                                      "50-100cm", "30-50cm", "15-30cm",
                                      "0-15cm" 
         ) ) %>% 
  filter(Horizon_bin_cm == "0-15cm" |
           Horizon_bin_cm == "15-30cm" |
           Horizon_bin_cm == "30-50cm" |
           Horizon_bin_cm == "50-100cm" ) %>%  
  droplevels() %>% 
  mutate(Horizon_thick_m = L_depth_m - U_depth_m) %>% 
  mutate(OCD_g_cm3 = BD_reported_combined * (OC_perc_final/100), #convert from percent to fraction
         OCD_kg_m3 = OCD_g_cm3*1000, #1,000,000 cm3 in 1 m3 and 1,000 g in 1 kg
         OCS_kg_m2 = OCD_kg_m3*Horizon_thick_m,
         OCS_t_ha = OCS_kg_m2*10) 


## first - calculate an average SOC density value for each horizon bin 

all_density_means_meds <- all_stocks %>% 
  group_by(Horizon_bin_cm) %>%
  summarise(OCD_kg_m3_mean = mean(OCD_kg_m3, na.rm = T),
            OCD_kg_m3_sd = sd(OCD_kg_m3, na.rm = T),
            # median and median absolute deviation
            OCD_kg_m3_med = median(OCD_kg_m3, na.rm = T),
            OCD_kg_m3_med_dev = mad(OCD_kg_m3, na.rm = T),
            n = sum(!is.na(OCD_kg_m3)),
            OCD_g_cm3_med = median(OCD_g_cm3, na.rm = T),
            OCD_g_cm3_med_dev = mad(OCD_g_cm3, na.rm = T)) 



## then, multiply this average SOCD value by the horizon bin thickness to get SOCS
all_stock_means_meds <- all_density_means_meds %>% 
  mutate(Horizon_thick_m = case_when(Horizon_bin_cm == "0-15cm" ~ 0.15,
                                     Horizon_bin_cm == "15-30cm" ~ 0.15,
                                     Horizon_bin_cm == "30-50cm" ~ 0.2,
                                     Horizon_bin_cm == "50-100cm" ~ 0.5)) %>% 
  mutate(OCS_t_ha = OCD_kg_m3_mean * Horizon_thick_m * 10,
         OCS_t_ha_sd = OCD_kg_m3_sd * Horizon_thick_m * 10,
         OCS_t_ha_med = OCD_kg_m3_med * Horizon_thick_m * 10,
         OCS_t_ha_med_dev = OCD_kg_m3_med_dev * Horizon_thick_m * 10)#x10 to go from kg m-2 to t ha-1

## finally, take the sum of all mean values to get an average SOCS to 1m 
all_stock_mean_med_1m <- all_stock_means_meds %>% 
  summarise(OCS_t_ha_mean_1m = sum(OCS_t_ha),
            OCS_t_ha_sd_1m = sum(OCS_t_ha_sd),
            OCS_t_ha_med_1m = sum(OCS_t_ha_med),
            OCS_t_ha_med_dev_1m = sum(OCS_t_ha_med_dev),
            total_n = sum(n))

all_stock_mean_med_30cm <- all_stock_means_meds %>% 
  filter(Horizon_bin_cm == "0-15cm" | Horizon_bin_cm == "15-30cm") %>% 
  summarise(OCS_t_ha_mean_30cm = sum(OCS_t_ha),
            OCS_t_ha_sd_30cm = sum(OCS_t_ha_sd),
            OCS_t_ha_med_30cm = sum(OCS_t_ha_med),
            OCS_t_ha_med_dev_30cm = sum(OCS_t_ha_med_dev),
            total_n = sum(n))

#n for calculation to 30cm 
all_stock_mean_med_30cm$total_n

#additional n for calculation to 1m 
all_stock_mean_med_1m$total_n - all_stock_mean_med_30cm$total_n
## saltmarsh area from Worthington et al. https://doi.org/10.1101/2023.05.26.542433
area_km2 <-  52880 # km2 
area_ha <- area_km2*100
total_SOCS_t <- all_stock_mean_med_1m[, "OCS_t_ha_med_1m"]*area_ha 
tota_SOCS_Gt <- total_SOCS_t/1000000000 # tonnes to gigatonnes (which is the same as Petagram)
tota_SOCS_Gt

total_SOCS_t_MAD <- all_stock_mean_med_30cm[, "OCS_t_ha_med_dev_30cm"]*area_ha 
tota_SOCS_Gt_MAD <- total_SOCS_t_MAD/1000000000 # tonnes to gigatonnes (which is the same as Petagram)
tota_SOCS_Gt_MAD


###### figure #####

stocks_figure_all <- all_stocks %>%
  mutate(`Dataset source` = case_when(Source == "CCRCN" ~ "CCRCN",
                                      TRUE ~ "This dataset")) %>% 
  ggplot()+
  geom_jitter(aes(x = Horizon_bin_cm, y = OCS_t_ha, shape = `Dataset source`,
                  color = `Dataset source`), size = 2, alpha = 0.5)+
  scale_shape_manual(values = c(16,17))+ #if not fill c(17,16)
  scale_color_manual(values = c("#4771e9ff", "#C1C0CD"))+
  coord_flip()+
  geom_point(data = all_stock_means_meds, aes(x = Horizon_bin_cm,
                                     y = OCS_t_ha_med,
                                     group = Horizon_bin_cm),
             size = 3, shape = 23, fill = "#8c2981")+
  geom_errorbar(data = all_stock_means_meds, aes( x = Horizon_bin_cm,
                                        ymin = OCS_t_ha_med - OCS_t_ha_med_dev,
                                        ymax = OCS_t_ha_med + OCS_t_ha_med_dev,
                                        group = Horizon_bin_cm),
                width = 0.1, linewidth = 1,  color = "#8c2981")+
  theme_bw()+
  labs(
    x = "Soil depth",
    y = "Soil organic carbon stocks (t ha-1)")+
  theme(legend.position = "bottom",
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 12),
        axis.text = element_text(size = 10, color = 'black'),
        axis.title = element_text(size = 12, color = 'black'))
stocks_figure_all

ylab<- expression("Soil organic carbon density"~~("g"~~"cm"^-3))
density_figure_all <- all_stocks %>%
  mutate(`Dataset source` = case_when(Source == "CCRCN" ~ "CCRCN",
                                      TRUE ~ "This dataset")) %>% 
  ggplot()+
  geom_jitter(aes(x = Horizon_bin_cm, y = OCD_g_cm3, shape = `Dataset source`,
                  color = `Dataset source`), 
              size = 2, alpha = 0.5)+
  scale_shape_manual(values = c(16,17))+ 
  scale_color_manual(values = c("#4771e9ff", "#C1C0CD"))+
  coord_flip()+
  geom_point(data = all_stock_means_meds, aes(x = Horizon_bin_cm,
                                              y = OCD_g_cm3_med ,
                                              group = Horizon_bin_cm),
             size = 3, shape = 23, fill = "#8c2981")+
  geom_errorbar(data = all_stock_means_meds, aes( x = Horizon_bin_cm,
                                                  ymin = OCD_g_cm3_med - OCD_g_cm3_med_dev,
                                                  ymax = OCD_g_cm3_med+ OCD_g_cm3_med_dev,
                                                  group = Horizon_bin_cm),
                width = 0.1, linewidth = 1,  color = "#8c2981")+
  theme_bw()+
  labs(x = "Soil depth",
    y = ylab)+
  theme(legend.position = "bottom",
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 12),
    axis.text = element_text(size = 10, color = 'black'),
    axis.title = element_text(size = 12, color = 'black'))
density_figure_all


# horizons_plots_final <- ggarrange(density_figure_all, stocks_figure_all +rremove("ylab"),
#                                       ncol = 2, nrow = 1,
#                                   common.legend = T,
#                                       labels = c("(a)", "(b)"),
#                                       font.label=list(color="black",size=10))



###### export Fig. S1 SOC density #####
path_out = 'data_paper/figures/'

export_fig <- density_figure_all
fig_main_name <- "density_figure_all"
export_file <- paste(path_out, fig_main_name, ".png", sep = '')
ggsave(export_file, export_fig, width = 7.81, height = 5.42)


## BD vs OC

OC_BD_all <- all_stocks %>%
  mutate(`Dataset source` = case_when(Source == "CCRCN" ~ "CCRCN",
                                      TRUE ~ "This dataset")) %>% 
  ggplot()+
  geom_point(aes(x = OC_perc_final, y = BD_reported_combined, shape = `Dataset source`), size = 2)+
  scale_shape_manual(values = c(17,16))+ 
  theme_bw()+ 
  labs(x = "OC (%)", y = "BD (g cm-3)")

OC_BD_all




#### 6. export data for data paper ####

outliers <- data0 %>% 
  filter(grepl("Outlier", Notes, ignore.case = TRUE)) %>% 
  filter(is.na(Latitude) == FALSE & is.na(Longitude) == FALSE) %>%
  filter(Source != "CCRCN") %>% 
  droplevels() 

data_paper_for_export <- rbind.fill(data_paper,outliers)



data_paper_export <- data_paper_for_export %>% 
  dplyr::select(-c(Habitat_type, accuracy_code, 
                   SOM_perc_Heiri, # only in Beasy & Ellison 
                   Depth_to_bedrock_m, # only in Conrad et al 2019 and Gailis et al 2021
                   OC_perc_combined,
                   SOM_perc_combined,
                   BD_reported_combined,
                   Horizon_mid_depth_cm,
                   Horizon_bin_cm )) %>%  
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
  dplyr::relocate(n_cores, SOM_perc_mean, SOM_perc_sd, OC_perc_mean, 
                   OC_perc_sd, OC_perc_se, BD_g_cm3_mean,
                   BD_g_cm3_sd, BD_g_cm3_se, .after = Treatment) %>% 
  dplyr::relocate(Soil_type, .after = Site_name) %>% 
  dplyr::relocate(DOI, .after = Notes)

str(data_paper_export)

table(data_paper_export$Source)

##### 6b. numbers including outliers ####
nsamples <- as.numeric(nrow(data_paper_export))
nsamples


nlocations <- data_paper_export %>%
  distinct(Latitude, Longitude, .keep_all = TRUE) %>% 
  count()
nlocations

ncountries <- length(table(data_paper_export$Country)) 
ncountries

country_table <- data_paper_export %>%  
  group_by(Country) %>% 
  distinct(Latitude, .keep_all = TRUE) %>% 
  count()

#percent of data with N data, bulk density

#N
nN_perc_data <- data_paper_export %>% 
  filter(is.na(N_perc) == FALSE)

nN_perc <- as.numeric(nrow(nN_perc_data))

#percent of data with N data
(nN_perc/nsamples)*100

# BD
nBD_data <- data_paper_export %>% 
  filter(is.na(BD_g_cm3) == FALSE | 
           is.na(BD_g_cm3_mean) == FALSE)

nBD<- as.numeric(nrow(nBD_data))

#percent of data with N data
(nBD/nsamples)*100


# depth of cores
# less than 30cm
cores_less30 <- data_paper_export %>% 
  filter(L_depth_m < 0.3)

ncores_less30<- as.numeric(nrow(cores_less30))

#percent of data with N data
(ncores_less30/nsamples)*100

# greater than 30cm
samples_greater30 <- data_paper_export %>% 
  filter(L_depth_m >= 0.3)

nsamples_greater30<- as.numeric(nrow(samples_greater30))

#percent of data that is deeper than 30 cm
(nsamples_greater30/nsamples)*100

cores_to1m <- data_paper_export %>% 
  group_by(Site_name) %>% 
  filter(L_depth_m >= 1) %>% 
  distinct(Site_name, .keep_all = TRUE) 

cores_total <- data_paper_export %>% 
  group_by(Site_name) %>% 
#  filter(L_depth_m >= 1) %>% 
  distinct(Site_name, .keep_all = TRUE) 

cores_deeper30cm <- data_paper_export %>% 
  group_by(Site_name) %>% 
  filter(L_depth_m >= 0.3) %>% 
  distinct(Site_name, .keep_all = TRUE) 

nrow(cores_deeper30cm)/nrow(cores_total)*100
nrow(cores_to1m)/nrow(cores_total)*100

### with CCRCN
cores_to1m <- data1 %>% 
  group_by(Latitude, Longitude) %>% 
  filter(L_depth_m >= 1) %>% 
  distinct(Site_name, .keep_all = TRUE) 

cores_total <- data1 %>% 
  group_by(Latitude, Longitude) %>% 
  #  filter(L_depth_m >= 1) %>% 
  distinct(Site_name, .keep_all = TRUE) 

cores_deeper30cm <- data1 %>% 
  group_by(Latitude, Longitude) %>% 
  filter(L_depth_m >= 0.5) %>% 
  distinct(Site_name, .keep_all = TRUE) 

nrow(cores_deeper30cm)/nrow(cores_total)*100
nrow(cores_to1m)/nrow(cores_total)*100

#### 7. check papers ####

data_paper_noyear <- data_paper_export %>% 
  filter(is.na(Year_collected) == TRUE) %>% 
  droplevels()

table(data_paper_noyear$Source)


data_paper_largeBD <- data_paper %>% 
  filter(BD_reported_combined > 2) %>% 
  group_by(Original_source, Horizon_bin_cm) %>% 
  count()
data_paper_largeBD

test <- data_paper %>% 
  filter(SOM_perc_combined < 0.8) %>% 
  filter(Data_type != "Observed")

#### 8. Conversion Factors #####
###### Table S1 conversion factor table ####

#see figure in 03_SOM_to_OC.R

conv_fact <- data_paper_export %>% 
  filter(is.na(Conv_factor) == FALSE) %>% 
  group_by(Source, Conv_factor) %>% 
  droplevels() %>%
  mutate(Conv_factor =  gsub("OC", "SOC",
                             gsub("OM", "SOM", Conv_factor))) %>%
  mutate(Source = fct_recode(Source, "de los Santos et al 2022 (a) from Santos et al 2019" = 
                               "de los Santos et al 2022 (a)")) %>% 
  dplyr::count()
conv_fact   

write.table(conv_fact, "data_paper/figures/conversion_factors.txt", row.names =  FALSE,
            sep = ",")

SOM_and_OC_CCRCN <- data1 %>%
  filter(is.na(Latitude) == FALSE & is.na(Longitude) == FALSE) %>%
  filter(Source == "CCRCN") %>% 
  filter(is.na(SOM_perc_combined) == FALSE & is.na(OC_perc_combined) == FALSE) 
table(SOM_and_OC_CCRCN$Original_source)
nrow(SOM_and_OC_CCRCN)


##### conversion factor graph 

conv_fact_xy <- conv_fact %>% 
  mutate(Conv_factor =  gsub("SOC", "y",
                             gsub("SOM", "x", Conv_factor))) %>% 
  dplyr::select(Conv_factor, Source)

x <- rep(1:100)

##our equation and the prediction intervals 
dat0 <- data.frame(x, y = 0.000732*(x^2) + 0.403*x, Source  = "Our equation")


xOC2 = seq(from = 0.00, to = 120, 
           length.out = 80) 

SOM_OC_predict_0 <- read.csv("reports/04_data_process/data/SOM_OC_predict_0.csv") %>% 
  mutate(xOC2 = xOC2)


## the other equations
# dat1 <- data.frame(x, y = 0.4*x + 0.0025*(x^2), Source  = "Craft equation: Burke et al 2022, 
#                    \ Gu et al 2020, Wollenberg et al 2018")
dat1 <- data.frame(x, y = 0.4*x + 0.0025*(x^2), Source  = "Craft et al 1991 (Louisiana, Coastal Carbon Manual)")
dat2 <- data.frame(x, y = 0.58*x , Source  = "Conrad et al 2019 (Coffs Creek, New South Wales, Australia)")
#dat3 <- data.frame(x, y = 0.47*x + 0.0008 , Source  = "Hatje et al 2023")
dat4 <- data.frame(x, y = 0.3102*x - 0.066 , Source  = "Martins et al 2022 (Ria Formosa lagoon, Portugal)")
dat4bis <- data.frame(x, y = 0.2822*x - 0.3401 , Source  = "Santos et al 2019 (Ria Formosa lagoon, Portugal)") # used in de los Santos et al 2022 a
dat5 <- data.frame(x, y = 0.461*x - 0.266 , Source  = "de los Santos et al 2022 (Cadiz Bay, Spain)") # de los Santos et al 2022 b
dat6 <- data.frame(x, y = 0.44*x - 1.33  , Source  = "Gailis et al 2021 (Boundary Bay, British Columbia)")
#dat7 <- data.frame(x, y = x/1.724 , Source  = "Gispert et al 2020, 2021")
dat8 <- data.frame(x, y = 0.8559*x + 0.1953, Source  = "Human et al 2022 eq a (Salicornia tegetaria zone,
                   \ Swartkops Estuary, South Africa)")
dat9 <- data.frame(x, y = 1.1345*x - 0.8806, Source  = "Human et al 2022 eq b (Spartina maritima zone, 
                   \ Swartkops Estuary, South Africa)")
dat10 <- data.frame(x, y = 0.44*x - 1.80, Source  = "Kohfeld et al 2022 (Clayoquot Sound, British Columbia)")
#dat11 <- data.frame(x, y = 0.47*x, Source  = "Perera et al 2022") # using Baustian et al 2017, derived from Howard et al 2014
dat12 <- data.frame(x, y = 0.47*x + 0.0008*(x^2) , Source  = "Howard et al 2014 (Maine, Coastal Carbon Manual)") # Ward 2020
dat13 <- data.frame(x, y = 0.22*(x^1.1), Source  = "Ward et al 2021 (California estuaries)")

conv_fact_forgraph <- rbind(dat1, dat2, 
                            #dat3, 
                            dat4, dat4bis, dat5, dat6,
                            # dat7, 
                            dat8, dat9, dat10, 
                            #dat11, 
                            dat12, dat13)


fig_conv_factors <- ggplot() +
  #prediction interval first -- so that it is in the background
  geom_ribbon(data = SOM_OC_predict_0, aes(x = xOC2, ymin = Sim.2.5., ymax = Sim.97.5.),
              fill = "grey", alpha = 0.5) +
  
  #1:1 line
  #geom_abline(intercept = 0, slope = 1, linetype = "dotted", color = 'darkgrey', size =1) + 
  
  #different converstion equations
  geom_line(data = conv_fact_forgraph, aes(x,y, color = Source), linetype = 2, size = 1)+
  
  #our conversion equation
  geom_line(data = dat0, aes(x,y), color = 'black', size = 2)+
  theme_bw()+
  labs(x = "Soil organic matter (%)", y = "Soil organic carbon (%)")+ 
  scale_color_viridis(name = "Conversion equations sources", discrete = TRUE, option = "H",
                      guide = guide_legend(override.aes = list(size = 5,
                                                               alpha = 1),
                                           keywidth=0.1, #the next three inputs are to increase width between legend
                                           keyheight=0.35,
                                           default.unit="inch"))+
  theme(plot.title = element_text(size = 18, hjust = 0.5),
        legend.position = "right",
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 12),
        axis.text = element_text(size = 10, color = 'black'),
        axis.title = element_text(size = 12, color = 'black'))+
  
  #to fix the axes without removing the grey shading area
  coord_cartesian(ylim = c(0, 100), xlim = c(0,100)) +
  scale_x_continuous(expand = c(0,0))+
  scale_y_continuous(expand = c(0,0))

fig_conv_factors
# note: legend for "THis dataset (Global) in black added afterwards using Inkscape



##### export Fig. 5 conversion relationships ####
path_out = 'data_paper/figures/'

export_file <- paste(path_out, "conv_factors", ".png", sep = '')

ggsave(export_file, fig_conv_factors, width = 10.48, height = 4.82)



#### 9. export final data file ####

path_out = '' # root directory

file_name <- paste("Maxwell_MarSOC_dataset", sep = "_")
export_file <- paste(path_out, file_name, ".csv", sep = '')
export_df <- data_paper_export

write.csv(export_df, export_file, row.names = F)


# export subset

# data_paper_export_subset <- data_paper_export %>%
#   filter(Source == "Serrano unpublished")
# 
# path_out = '../Data/' # up from root directory into Data folder
# 
# file_name <- "export_Serrano_unpublished"
# export_file <- paste(path_out, file_name, ".csv", sep = '')
# export_df <- data_paper_export_subset
# 
# write.csv(export_df, export_file, row.names = F)

