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


# test which columns have missing values
# note: Year_collected has been filled in as much as possible (NA = the original study did not mention the year)

test_NA <- data0 %>% 
  filter(is.na(U_depth_m) == TRUE) # all from Rovai missing refs

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


reviews <- data_paper %>% 
  filter(Data_type == "Review") %>% 
  group_by(Source, Original_source) %>% 
  dplyr::count()
reviews   


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

# path_out = 'data_paper/studies/'
# 
# 
# export_file <- paste(path_out, "studies.csv", sep = '') 
# export_df <- ntypes
# 
# write.csv(export_df, export_file, row.names = F)
# 

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
# path_out = 'data_paper/figures/'
# 
# 
# fig_name <- paste(Sys.Date(),"n_points", sep = "_")
# export_file <- paste(path_out, fig_name, ".png", sep = '')
# 
# ggsave(export_file, fig_paper, width = 11.26, height = 6.11)


#### 4. figure distribution of points ####
# from outliers script


data_means <- data_paper %>% 
  filter(is.na(Horizon_bin_cm) == FALSE) %>% 
  group_by(Horizon_bin_cm) %>%
  summarise(across(c(OC_perc_final, SOM_perc_combined,BD_reported_combined), 
                   list(mean = ~ mean(.x, na.rm = T), 
                        sd = ~ sd(.x, na.rm = T))))

OC_points <- data_paper %>%
  filter(is.na(Horizon_bin_cm) == FALSE) %>% 
  ggplot()+
  geom_jitter(aes(x = Horizon_bin_cm, y = OC_perc_final))+
  coord_flip()+
  geom_point(data = data_means, aes(x = Horizon_bin_cm, 
                                    y = OC_perc_final_mean,
                                           group = Horizon_bin_cm, 
                                           fill = Horizon_bin_cm),
              size = 5, shape = 23)+
  geom_errorbar(data = data_means, aes( x = Horizon_bin_cm, 
    ymin = OC_perc_final_mean - OC_perc_final_sd,
                                       ymax = OC_perc_final_mean + OC_perc_final_sd,
                                       group = Horizon_bin_cm, 
                                       color = Horizon_bin_cm),
                width = 0.2)+
  theme_bw()+
  labs(
       x = "Soil depth",
       y = "OC (%)")+
  theme(legend.position = "none",
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 12),
        axis.text = element_text(size = 10, color = 'black'),
        axis.title = element_text(size = 12, color = 'black'))
OC_points


#### 5. figure estimated SOC stocks ####



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


test <- data_paper_stocks %>% 
  filter(OCD_kg_m3 > 280)
## first - calculate an average SOC density value for each horizon bin 

density_means <- data_paper_stocks %>% 
  group_by(Horizon_bin_cm) %>%
  summarise(OCD_kg_m3_mean = mean(OCD_kg_m3, na.rm = T),  
            OCD_kg_m3_sd = sd(OCD_kg_m3, na.rm = T)) 

## then, multiply this average SOCD value by the horizon bin thickness to get SOCS
stock_means <- density_means %>% 
  mutate(Horizon_thick_m = case_when(Horizon_bin_cm == "0-15cm" ~ 0.15,
                                     Horizon_bin_cm == "15-30cm" ~ 0.15,
                                     Horizon_bin_cm == "30-50cm" ~ 0.2,
                                     Horizon_bin_cm == "50-100cm" ~ 0.5)) %>% 
  mutate(OCS_t_ha = OCD_kg_m3_mean * Horizon_thick_m * 10,
         OCS_t_ha_sd = OCD_kg_m3_sd * Horizon_thick_m * 10)#x10 to go from kg m-2 to t ha-1

## finally, take the sum of all mean values to get an average SOCS to 1m 
stock_mean_1m <- stock_means %>% 
  summarise(sum_mean = sum(OCS_t_ha),
            sum_sd = sum(OCS_t_ha_sd))



stocks_figure <- #data_paper %>%
  ggplot()+
  geom_jitter(data = data_paper_stocks, aes(x = Horizon_bin_cm, y = OCS_t_ha))+
  coord_flip()+
  geom_point(data = stock_means, aes(x = Horizon_bin_cm,
                                    y = OCS_t_ha,
                                    group = Horizon_bin_cm,
                                    fill = Horizon_bin_cm),
             size = 5, shape = 23)+
  geom_errorbar(data = stock_means, aes( x = Horizon_bin_cm,
                                        ymin = OCS_t_ha - OCS_t_ha_sd,
                                        ymax = OCS_t_ha + OCS_t_ha_sd,
                                        group = Horizon_bin_cm,
                                        color = Horizon_bin_cm),
                width = 0.2)+
  theme_bw()+
  labs(
    x = "Soil depth",
    y = "Soil organic carbon stocks (t ha-1)")+
  theme(legend.position = "none",
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 12),
        axis.text = element_text(size = 10, color = 'black'),
        axis.title = element_text(size = 12, color = 'black'))
stocks_figure


density_figure <- #data_paper %>%
  ggplot()+
  geom_jitter(data = data_paper_stocks, aes(x = Horizon_bin_cm, y = OCD_kg_m3))+
  coord_flip()+
  geom_point(data = density_means, aes(x = Horizon_bin_cm,
                                     y = OCD_kg_m3_mean,
                                     group = Horizon_bin_cm,
                                     fill = Horizon_bin_cm),
             size = 5, shape = 23)+
  geom_errorbar(data = density_means, aes( x = Horizon_bin_cm,
                                        ymin = OCD_kg_m3_mean - OCD_kg_m3_sd,
                                        ymax = OCD_kg_m3_mean + OCD_kg_m3_sd,
                                        group = Horizon_bin_cm,
                                        color = Horizon_bin_cm),
                width = 0.2)+
  theme_bw()+
  labs(
    x = "Soil depth",
    y = "Soil organic carbon density (kg m-3)")+
  theme(legend.position = "none",
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 12),
        axis.text = element_text(size = 10, color = 'black'),
        axis.title = element_text(size = 12, color = 'black'))
density_figure

###### export fig ######
# path_out = 'reports/04_data_process/figures/stocks/'
# 
# export_fig <- density_figure
# fig_main_name <- "density_figure"
# export_file <- paste(path_out, fig_main_name, ".png", sep = '')
# ggsave(export_file, export_fig, width = 8.84, height = 7.78)



#### 5b values using data paper and CCRCN ##### 

all_stocks <- data1 %>%
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

all_density_means <- all_stocks %>% 
  group_by(Horizon_bin_cm) %>%
  summarise(OCD_kg_m3_mean = mean(OCD_kg_m3, na.rm = T),  
            OCD_kg_m3_sd = sd(OCD_kg_m3, na.rm = T)) 

## then, multiply this average SOCD value by the horizon bin thickness to get SOCS
all_stock_means <- all_density_means %>% 
  mutate(Horizon_thick_m = case_when(Horizon_bin_cm == "0-15cm" ~ 0.15,
                                     Horizon_bin_cm == "15-30cm" ~ 0.15,
                                     Horizon_bin_cm == "30-50cm" ~ 0.2,
                                     Horizon_bin_cm == "50-100cm" ~ 0.5)) %>% 
  mutate(OCS_t_ha = OCD_kg_m3_mean * Horizon_thick_m * 10,
         OCS_t_ha_sd = OCD_kg_m3_sd * Horizon_thick_m * 10)#x10 to go from kg m-2 to t ha-1

## finally, take the sum of all mean values to get an average SOCS to 1m 
all_stock_mean_1m <- all_stock_means %>% 
  summarise(OCS_t_ha_mean_1m = sum(OCS_t_ha),
            OCS_t_ha_sd_1m = sum(OCS_t_ha_sd))

## saltmarsh area (from McOhen for now): 54,951
area_km2 <-  54951 # km2 
area_ha <- area_km2*100
total_SOCS_t <- all_stock_mean_1m[1]*area_ha
tota_SOCS_Gt <- total_SOCS_t/1000000000 # tonnes to gigatonnes (which is the same as Petagram)
tota_SOCS_Gt

###### figure #####

stocks_figure_all <- all_stocks %>%
  mutate(`Dataset source` = case_when(Source == "CCRCN" ~ "CCRCN",
                                      TRUE ~ "This dataset")) %>% 
  ggplot()+
  geom_jitter(aes(x = Horizon_bin_cm, y = OCS_t_ha, shape = `Dataset source`), size = 2)+
  scale_shape_manual(values = c(17,16))+ 
  coord_flip()+
  geom_point(data = all_stock_means, aes(x = Horizon_bin_cm,
                                     y = OCS_t_ha,
                                     group = Horizon_bin_cm,
                                     fill = Horizon_bin_cm),
             size = 5, shape = 23)+
  geom_errorbar(data = all_stock_means, aes( x = Horizon_bin_cm,
                                        ymin = OCS_t_ha - OCS_t_ha_sd,
                                        ymax = OCS_t_ha + OCS_t_ha_sd,
                                        group = Horizon_bin_cm,
                                        color = Horizon_bin_cm),
                width = 0.2)+
  theme_bw()+
  labs(
    x = "Soil depth",
    y = "Soil organic carbon stocks (t ha-1)")+
  theme(#legend.position = "none",
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 12),
        axis.text = element_text(size = 10, color = 'black'),
        axis.title = element_text(size = 12, color = 'black'))
stocks_figure_all



#### outliers? 
#test for finding number of outliers
qnt_OCD <- quantile(all_stocks[ ,"OCD_kg_m3"], probs=c(.05, .95), na.rm=T) #finding the quantiles of 5% and 95% for the column desired
H_OCD<-2.2*IQR(all_stocks[,"OCD_kg_m3"], na.rm=T) #creating a variable H which is 2.2 times the interquartile range. See Kardol et al. 2018 --> they give a statistical ref.
#replace values above the 2nd quantile + H, and below 1st quantile - H
outliers1_OCD <-  all_stocks[all_stocks[, "OCD_kg_m3"] > (qnt_OCD[2] + H_OCD), "OCD_kg_m3"]
outliers2_OCD <- all_stocks[all_stocks[,"OCD_kg_m3"] < (qnt_OCD[1] - H_OCD), "OCD_kg_m3"]

#H1.5<-1.5*IQR(all_stocks[,"OCD_kg_m3"], na.rm=T) #creating a variable H which is 1.5 times the interquartile range. See Kardol et al. 2018 --> they give a statistical ref.
sum(!is.na(outliers1_OCD)) #n of not previously NA values (i.e. not from missing) ABOVE limit



density_figure_all <- all_stocks %>%
  mutate(`Dataset source` = case_when(Source == "CCRCN" ~ "CCRCN",
                                      TRUE ~ "This dataset")) %>% 
  ggplot()+
  geom_jitter(aes(x = Horizon_bin_cm, y = OCD_kg_m3, shape = `Dataset source`), size = 2)+
  scale_shape_manual(values = c(17,16))+ 
  coord_flip()+
  ##outliers
  geom_hline(aes(yintercept = qnt_OCD[2]+H_OCD), color = 'darkgreen',
             linetype = 'dashed', size = 1.5)+
  geom_hline(aes(yintercept = qnt_OCD[1]), color = 'gold',
             linetype = 'dashed', size = 1.5)+
  geom_hline(aes(yintercept = qnt_OCD[2]), color = 'gold',
             linetype = 'dashed', size = 1.5)+
  ##average point and error bar
  geom_point(data = all_density_means, aes(x = Horizon_bin_cm,
                                         y = OCD_kg_m3_mean,
                                         group = Horizon_bin_cm,
                                         fill = Horizon_bin_cm),
             size = 5, shape = 23)+
  
  geom_errorbar(data = all_density_means, aes( x = Horizon_bin_cm,
                                        ymin = OCD_kg_m3_mean - OCD_kg_m3_sd,
                                        ymax = OCD_kg_m3_mean + OCD_kg_m3_sd,
                                        group = Horizon_bin_cm,
                                        color = Horizon_bin_cm),
                width = 0.2)+
  theme_bw()+
  labs(
    x = "Soil depth",
    y = "Soil organic carbon density (kg m-3)")+
  theme(#legend.position = "none",
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 12),
    axis.text = element_text(size = 10, color = 'black'),
    axis.title = element_text(size = 12, color = 'black'))
density_figure_all



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


###### export outliers fig #####
# path_out = 'reports/04_data_process/figures/stocks/'
# 
# export_fig <- OC_BD_all
# fig_main_name <- "OC_BD_all"
# export_file <- paste(path_out, fig_main_name, ".png", sep = '')
# ggsave(export_file, export_fig, width = 12.91, height = 6.46)




#### 6. conversion factor table ####

#see figure in 02_SOM_to_OC


conv_fact <- data_paper %>% 
  filter(is.na(Conv_factor) == FALSE) %>% 
  group_by(Source, Conv_factor) %>% 
  droplevels() %>%
  mutate(Conv_factor =  gsub("OC", "SOC",
                             gsub("OM", "SOM", Conv_factor))) %>% 
  dplyr::count()
conv_fact   


# write.table(conv_fact, "data_paper/conversion_factors.txt", row.names =  FALSE,
#             sep = ",")

SOM_and_OC_CCRCN <- data1 %>%
  filter(is.na(Latitude) == FALSE & is.na(Longitude) == FALSE) %>%
  filter(Source == "CCRCN") %>% 
  filter(is.na(SOM_perc_combined) == FALSE & is.na(OC_perc_combined) == FALSE) %>% 
  filter(Original_source != "Keshta et al 2020 a")
table(SOM_and_OC_CCRCN$Original_source)
nrow(SOM_and_OC_CCRCN)


##### 6b. conversion factor graph ####

conv_fact_xy <- conv_fact %>% 
  mutate(Conv_factor =  gsub("SOC", "y",
                             gsub("SOM", "x", Conv_factor))) %>% 
  dplyr::select(Conv_factor, Source)

x <- rep(1:100)

##our equation and the prediction intervals 
dat0 <- data.frame(x, y = 0.000663*(x^2) + 0.406*x - 0.63, Source  = "Our equation")


xOC2 = seq(from = 0.00, to = 100, 
           length.out = 100) 

SOM_OC_predict <- read.csv("reports/04_data_process/data/SOM_OC_predict.csv") %>% 
  mutate(xOC2 = xOC2)


## the other equations
# dat1 <- data.frame(x, y = 0.4*x + 0.0025*(x^2), Source  = "Craft equation: Burke et al 2022, 
#                    \ Gu et al 2020, Wollenberg et al 2018")
dat1 <- data.frame(x, y = 0.4*x + 0.0025*(x^2), Source  = "Craft et al 1991 (Louisiana, Coastal Carbon Manual)")
dat2 <- data.frame(x, y = 0.58*x , Source  = "Conrad et al 2019 (Coffs Creek, New South Wales, Australia")
#dat3 <- data.frame(x, y = 0.47*x + 0.0008 , Source  = "Copertino et al under review")
dat4 <- data.frame(x, y = 0.3102*x - 0.066 , Source  = "Martins et al 2022 (Ria Formosa lagoon, Portugal)")
dat4bis <- data.frame(x, y = 0.2822*x - 0.3401 , Source  = "de los Santos et al 2022 (a) (Ria Formosa lagoon, Portugal)")
dat5 <- data.frame(x, y = 0.461*x - 0.266 , Source  = "de los Santos et al 2022 (b) (Cadiz Bay, Spain)")
dat6 <- data.frame(x, y = 0.44*x - 1.33  , Source  = "Gailis et al 2021 (Boundary Bay, British Columbia)")
#dat7 <- data.frame(x, y = x/1.724 , Source  = "Gispert et al 2020, 2021")
dat8 <- data.frame(x, y = 0.8559*x + 0.1953, Source  = "Human et al 2022 eq a (Salicornia tegetaria zone,
                   \ Swartkops Estuary, South Africa)")
dat9 <- data.frame(x, y = 1.1345*x - 0.8806, Source  = "Human et al 2022 eq b (Spartina maritima zone, 
                   \ Swartkops Estuary, South Africa)")
dat10 <- data.frame(x, y = 0.44*x - 1.80, Source  = "Kohfeld et al 2022 (Clayoquot Sound, British Columbia")
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
  geom_ribbon(data = SOM_OC_predict, aes(x = xOC2, ymin = Sim.2.5., ymax = Sim.97.5.),
              fill = "grey", alpha = 0.5) +
  
  #1:1 line
  geom_abline(intercept = 0, slope = 1, linetype = "dotted", color = 'darkgrey', size =1) + 
  
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



#### export figure
# path_out = 'data_paper/figures/'
# 
# 
# fig_name <- paste(Sys.Date(),"conv_factors", sep = "_")
# export_file <- paste(path_out, fig_name, ".png", sep = '')
# 
# ggsave(export_file, fig_conv_factors, width = 10.48, height = 4.82)
# 


#### 7. export data for data paper ####

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


#### 8. check papers ####

data_paper_noyear <- data_paper_export %>% 
  filter(is.na(Year_collected) == TRUE) %>% 
  droplevels()

table(data_paper_noyear$Source)







#### 9. export final data file ####

path_out = 'data_paper/'

file_name <- paste(Sys.Date(),"Maxwell_marshC_dataset", sep = "_")
export_file <- paste(path_out, file_name, ".csv", sep = '')
export_df <- data_paper_export

write.csv(export_df, export_file, row.names = F)


