## clean up data compiled from datasets 
## prior to soil C modelling 
# contact Tania Maxwell, tlgm2@cam.ac.uk
# 16.11.22

library(tidyverse)
library(ggpmisc) # for lm equation and R2 on graph
input_file01 <- "reports/04_data_process/data/data_cleaned.csv"

data0<- read.csv(input_file01)

str(data0)



#### 1. SOM to OC ######

#10,609 observations with SOM instead of OC
test <-data0 %>% 
  filter(is.na(OC_perc_combined) == TRUE & is.na(SOM_perc_combined) == FALSE)

table(test$Source)


## Plot different slopes
# 4401 observations with both SOM and OC
## only 867 which measured SOM and OC by elemental analyzer
data_SOM_OC <-data0 %>% 
  filter(is.na(OC_perc_combined) == FALSE & is.na(SOM_perc_combined) == FALSE
         & Method == "EA") %>% 
  mutate(Source_country = paste(Original_source, Country))

table(data_SOM_OC$Source_country)



SOM_OC_observed <- ggplot(data_SOM_OC, aes(x = SOM_perc_combined, y = OC_perc_combined))+
  stat_poly_line()+
  stat_poly_eq(aes(label = paste(after_stat(eq.label),
                                 after_stat(rr.label), sep = "*\", \"*")))+
  geom_point()+
  facet_wrap(~Source_country)

SOM_OC_observed



# looks like Graversen data is in per mille, and not percent? 
#i.e. test divided by 10

data_SOM_OC_grav <- data_SOM_OC %>% 
  mutate(OC_perc_corr = case_when(Original_source == "Graversen et al 2022" ~ OC_perc_combined/10,
                                  TRUE ~ OC_perc_combined)) %>% 
  relocate(OC_perc_corr, .before = OC_perc_combined) %>% 
  filter(Original_source == "Graversen et al 2022" | Original_source == "Ruranska et al 2020"
         | Original_source == "Ruranska et al 2022" | Original_source == "Burden et al 2018")


## to send to Graversen 

Grav_SOM_OC_observed <- ggplot(data_SOM_OC_grav, aes(x = SOM_perc_combined, y = OC_perc))+
  geom_point()+
  labs(x = "Soil organic matter (%)", y = "Organic carbon (%)")+
  facet_wrap(~Source_country)

Grav_SOM_OC_observed




#### export figure
export_fig <- SOM_OC_observed
fig_main_name <- "SOM_OC_observed"

path_out = 'reports/04_data_process/figures/'
fig_name <- paste(Sys.Date(),fig_main_name, sep = "_")
export_file <- paste(path_out, fig_name, ".png", sep = '') 
ggsave(export_file, export_fig, width = 14.86, height = 8.46)


#### 2. explore conversion factors used ######
table(data0$Conv_factor)

data_conv_factors <- data0 %>% 
  filter(is.na(Conv_factor) == FALSE) %>% 
  group_by(Source, Country, Original_source) %>% 
  count(Conv_factor) 

library(gridExtra)
png("test.png", height = 50*nrow(data_conv_factors), width = 200*ncol(data_conv_factors))
grid.table(data_conv_factors)
dev.off()

#### last. export cleaned and converted data ####

path_out = 'reports/04_data_process/data/'

export_file <- paste(path_out, "data_cleaned_converted.csv", sep = '') 
export_df <- data4

write.csv(export_df, export_file, row.names = F)


