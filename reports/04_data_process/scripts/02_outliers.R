## contiuation of script 01_data_clean.R
## includes outlier figures
## and removal of outliers

rm(list=ls()) # clear the workspace
library(tidyverse)

setwd("~/07_Cam_postdoc/MarSOC-Dataset")
input_file01 <- "reports/04_data_process/data/data_cleaned.csv"

data0 <- read.csv(input_file01)

str(data0)

#### 1.  add horizon depth to visualize outliers ####

data1 <- data0 %>% 
  mutate(Horizon_mid_depth_cm = (U_depth_m + (L_depth_m-U_depth_m)/2)*100) %>% 
  mutate(Horizon_bin_cm = case_when(Horizon_mid_depth_cm >= 0 & 
                                      Horizon_mid_depth_cm <= 15~ "0-15cm",
                                    Horizon_mid_depth_cm > 15 & 
                                      Horizon_mid_depth_cm <= 30 ~ "15-30cm",
                                    Horizon_mid_depth_cm > 30 &
                                      Horizon_mid_depth_cm <= 50  ~ "30-50cm",
                                    Horizon_mid_depth_cm > 50 &
                                      Horizon_mid_depth_cm <= 100 ~ "50-100cm",
                                    Horizon_mid_depth_cm > 100 ~ "100cm and up")) %>% 
  mutate(Horizon_bin_cm = as.factor(Horizon_bin_cm),
         Horizon_bin_cm = fct_relevel(Horizon_bin_cm, "100cm and up", 
                                      "50-100cm", "30-50cm", "15-30cm",
                                      "0-15cm" 
         ) )


#### 2. find outliers ####

##### OC_perc_combined ###

## for this, only measured OC is used for the outlier test

#test for finding number of outliers
qnt_OC <- quantile(data1[ ,"OC_perc_combined"], probs=c(.05, .95), na.rm=T) #finding the quantiles of 5% and 95% for the column desired
H_OC<-2.2*IQR(data1[,"OC_perc_combined"], na.rm=T) #creating a variable H which is 2.2 times the interquartile range. See Kardol et al. 2018 --> they give a statistical ref.
#replace values above the 2nd quantile + H, and below 1st quantile - H
outliers1_OC <-  data1[data1[, "OC_perc_combined"] > (qnt_OC[2] + H_OC), "OC_perc_combined"]
outliers2_OC <- data1[data1[,"OC_perc_combined"] < (qnt_OC[1] - H_OC), "OC_perc_combined"]

limit_OC <- qnt_OC[2] + H_OC
#H1.5<-1.5*IQR(data1[,"OC_perc_combined"], na.rm=T) #creating a variable H which is 1.5 times the interquartile range. See Kardol et al. 2018 --> they give a statistical ref.
sum(!is.na(outliers1_OC)) #n of not previously NA values (i.e. not from missing) ABOVE limit


##### SOM_perc_combined ###

#test for finding number of outliers
qnt_SOM <- quantile(data1[ ,"SOM_perc_combined"], probs=c(.05, .95), na.rm=T) #finding the quantiles of 5% and 95% for the column desired
H_SOM<-2.2*IQR(data1[,"SOM_perc_combined"], na.rm=T) #creating a variable H which is 2.2 times the interquartile range. See Kardol et al. 2018 --> they give a statistical ref.
#replace values above the 2nd quantile + H, and below 1st quantile - H
outliers1_SOM <-  data1[data1[, "SOM_perc_combined"] > (qnt_SOM[2] + H_SOM), "SOM_perc_combined"]
outliers2_SOM <- data1[data1[,"SOM_perc_combined"] < (qnt_SOM[1] - H_SOM), "SOM_perc_combined"]

limit_SOM <- qnt_SOM[2] + H_SOM
#H1.5<-1.5*IQR(data1[,"SOM_perc_combined"], na.rm=T) #creating a variable H which is 1.5 times the interquartile range. See Kardol et al. 2018 --> they give a statistical ref.
sum(!is.na(outliers1_SOM)) #n of not previously NA values (i.e. not from missing) ABOVE limit


##### BD_reported_combined ###

#test for finding number of outliers
qnt_BD <- quantile(data1[ ,"BD_reported_combined"], probs=c(.05, .95), na.rm=T) #finding the quantiles of 5% and 95% for the column desired
H_BD<-2.2*IQR(data1[,"BD_reported_combined"], na.rm=T) #creating a variable H which is 2.2 times the interquartile range. See Kardol et al. 2018 --> they give a statistical ref.
#replace values above the 2nd quantile + H, and below 1st quantile - H
outliers1_BD <-  data1[data1[, "BD_reported_combined"] > (qnt_BD[2] + H_BD), "BD_reported_combined"]
outliers2_BD <- data1[data1[,"BD_reported_combined"] < (qnt_BD[1] - H_BD), "BD_reported_combined"]

limit_BD <- qnt_BD[2] + H_BD
#H1.5<-1.5*IQR(data1[,"BD_reported_combined"], na.rm=T) #creating a variable H which is 1.5 times the interquartile range. See Kardol et al. 2018 --> they give a statistical ref.
sum(!is.na(outliers1_BD)) #n of not previously NA values (i.e. not from missing) ABOVE limit

##### N_perc ###

#test for finding number of outliers
qnt_N <- quantile(data1[ ,"N_perc"], probs=c(.05, .95), na.rm=T) #finding the quantiles of 5% and 95% for the column desired
H_N<-2.2*IQR(data1[,"N_perc"], na.rm=T) #creating a variable H which is 2.2 times the interquartile range. See Kardol et al. 2018 --> they give a statistical ref.
#replace values above the 2nd quantile + H, and below 1st quantile - H
outliers1_N <-  data1[data1[, "N_perc"] > (qnt_N[2] + H_N), "N_perc"]
outliers2_N <- data1[data1[,"N_perc"] < (qnt_N[1] - H_N), "N_perc"]

limit_N <- qnt_N[2] + H_N
#H1.5<-1.5*IQR(data1[,"N_perc"], na.rm=T) #creating a variable H which is 1.5 times the interquartile range. See Kardol et al. 2018 --> they give a statistical ref.
sum(!is.na(outliers1_N)) #n of not previously NA values (i.e. not from missing) ABOVE limit


data2 <- data1 %>% 
  mutate(Notes = case_when(OC_perc_combined > limit_OC ~ "Outlier - OC removed from test",
                           SOM_perc_combined > limit_SOM ~ "Outlier - SOM removed from test",
                           BD_reported_combined > limit_BD ~ "Outlier - BD removed from test",
                           N_perc > limit_N ~ "Outlier - N removed from test"))

#### 3. visualize outlier rule for all data ####

OC_check_all <- data1 %>%
  filter(Source != "CCRCN") %>% ## these are the checks for the data paper
  # filter(Data_type == "Meta-analysis") %>%
  # filter(Source == "Copertino et al under review") %>%
  ggplot(aes(x = Horizon_bin_cm, y = OC_perc_combined))+
  coord_flip()+
  geom_jitter()+
  # geom_hline(aes(yintercept = qnt[2]+H), color = 'purple',
  #            linetype = 'dashed', size = 1)+
  geom_hline(aes(yintercept = qnt_OC[2]+H_OC), color = 'darkgreen',
             linetype = 'dashed', size = 1.5)+
  geom_hline(aes(yintercept = qnt_OC[1]), color = 'gold',
             linetype = 'dashed', size = 1.5)+
  geom_hline(aes(yintercept = qnt_OC[2]), color = 'gold',
             linetype = 'dashed', size = 1.5)+
  theme_bw()+
  labs(title = "Green: 2.2x the interquartile range, Yellow: 0.05 and 0.95 quantiles",
       x = "Soil depth (mid-point of layer)",
       y = "OC (%)")+
  theme(legend.position = "none",
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 12),
        axis.text = element_text(size = 10, color = 'black'),
        axis.title = element_text(size = 12, color = 'black'))
OC_check_all

SOM_check_all <- data1 %>%
  filter(Source != "CCRCN") %>% ## these are the checks for the data paper
  # filter(Data_type == "Meta-analysis") %>%
  # filter(Source == "Copertino et al under review") %>%
  ggplot(aes(x = Horizon_bin_cm, y = SOM_perc_combined))+
  coord_flip()+
  geom_jitter()+
  # geom_hline(aes(yintercept = qnt[2]+H), color = 'purple',
  #            linetype = 'dashed', size = 1)+
  geom_hline(aes(yintercept = qnt_SOM[2]+H_SOM), color = 'darkgreen',
             linetype = 'dashed', size = 1.5)+
  geom_hline(aes(yintercept = qnt_SOM[1]), color = 'gold',
             linetype = 'dashed', size = 1.5)+
  geom_hline(aes(yintercept = qnt_SOM[2]), color = 'gold',
             linetype = 'dashed', size = 1.5)+
  theme_bw()+
  labs(title = "Green: 2.2x the interquartile range, Yellow: 0.05 and 0.95 quantiles",
       x = "Soil depth (mid-point of layer)",
       y = "SOM (%)")+
  theme(legend.position = "none",
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 12),
        axis.text = element_text(size = 10, color = 'black'),
        axis.title = element_text(size = 12, color = 'black'))
SOM_check_all


BD_check_all <- data1 %>%
  filter(Source != "CCRCN") %>% ## these are the checks for the data paper
  # filter(Data_type == "Meta-analysis") %>%
  # filter(Source == "Copertino et al under review") %>%
  ggplot(aes(x = Horizon_bin_cm, y = BD_reported_combined))+
  coord_flip()+
  geom_jitter()+
  # geom_hline(aes(yintercept = qnt[2]+H), color = 'purple',
  #            linetype = 'dashed', size = 1)+
  geom_hline(aes(yintercept = qnt_BD[2]+H_BD), color = 'darkgreen',
             linetype = 'dashed', size = 1.5)+
  geom_hline(aes(yintercept = qnt_BD[1]), color = 'gold',
             linetype = 'dashed', size = 1.5)+
  geom_hline(aes(yintercept = qnt_BD[2]), color = 'gold',
             linetype = 'dashed', size = 1.5)+
  theme_bw()+
  labs(title = "Green: 2.2x the interquartile range, Yellow: 0.05 and 0.95 quantiles",
       x = "Soil depth (mid-point of layer)",
       y = "Bulk density (g cm-3)")+
  theme(legend.position = "none",
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 12),
        axis.text = element_text(size = 10, color = 'black'),
        axis.title = element_text(size = 12, color = 'black'))
BD_check_all


###### export ####

path_out = 'reports/04_data_process/figures/outliers/'
export_fig <- BD_check_all # also for OC_check_all, SOM_check_all
export_file <- paste(path_out, "BD_check_all.png", sep = '')
ggsave(export_file, export_fig, width = 7.85, height = 4.77)



#### 4. visualize outlier rule for per depth ####

##### OC_perc_combined ###
# 
# data_quantiles_OC <- data1 %>% 
#   group_by(Horizon_bin_cm) %>% 
#   summarise(qnt1 = quantile(OC_perc_combined, probs=c(.05), na.rm=T),
#             qnt2 = quantile(OC_perc_combined, probs=c(.95), na.rm=T),
#             H = 2.2*IQR(OC_perc_combined, na.rm=T),
#             lower_outlier = qnt1 - H,
#             upper_outlier = qnt2 + H)
# 
# 
# OC_check <- data1 %>% 
#   filter(Source != "CCRCN") %>%
#   # filter(Data_type == "Meta-analysis") %>% 
#   # filter(Source == "Copertino et al under review") %>% 
#   ggplot(aes(x = Horizon_bin_cm, y = OC_perc_combined))+
#   coord_flip()+
#   geom_jitter()+
#   geom_hline(data = data_quantiles_OC, aes(yintercept = upper_outlier,
#                                         group = Horizon_bin_cm, 
#                                         color = Horizon_bin_cm),
#              linetype = 'dashed', size = 1)+
#   theme_bw()+
#   labs(title = "Dashed line is 2.2x the interquartile range",
#        x = "Soil depth (mid-point of layer)",
#        y = "OC (%)")+
#   facet_grid(~Horizon_bin_cm) +  
#   theme(legend.position = "none",
#         legend.title = element_text(size = 12),
#         legend.text = element_text(size = 12),
#         axis.text = element_text(size = 10, color = 'black'),
#         axis.title = element_text(size = 12, color = 'black'))
# OC_check
# 
# ##### SOM_perc_combined ###
# 
# data_quantiles_SOM <- data1 %>% 
#   group_by(Horizon_bin_cm) %>% 
#   summarise(qnt1 = quantile(SOM_perc_combined, probs=c(.05), na.rm=T),
#             qnt2 = quantile(SOM_perc_combined, probs=c(.95), na.rm=T),
#             H = 2.2*IQR(SOM_perc_combined, na.rm=T),
#             lower_outlier = qnt1 - H,
#             upper_outlier = qnt2 + H)
# 
# SOM_check <- data1 %>% 
#   filter(Source != "CCRCN") %>%
#   # filter(Data_type == "Meta-analysis") %>% 
#   # filter(Source == "Copertino et al under review") %>% 
#   ggplot(aes(x = Horizon_bin_cm, y = SOM_perc_combined))+
#   coord_flip()+
#   geom_jitter()+
#   geom_hline(data = data_quantiles_SOM, aes(yintercept = upper_outlier,
#                                         group = Horizon_bin_cm, 
#                                         color = Horizon_bin_cm),
#              linetype = 'dashed', size = 1)+
#   theme_bw()+
#   labs(title = "Dashed line is 2.2x the interquartile range",
#        x = "Soil depth (mid-point of layer)",
#        y = "SOM (%)")+
#   facet_grid(~Horizon_bin_cm) +  
#   theme(legend.position = "none",
#         legend.title = element_text(size = 12),
#         legend.text = element_text(size = 12),
#         axis.text = element_text(size = 10, color = 'black'),
#         axis.title = element_text(size = 12, color = 'black'))
# SOM_check
# 
# ##### BD_reported_combined ###
# 
# data_quantiles_BD <- data1 %>% 
#   group_by(Horizon_bin_cm) %>% 
#   summarise(qnt1 = quantile(BD_reported_combined, probs=c(.05), na.rm=T),
#             qnt2 = quantile(BD_reported_combined, probs=c(.95), na.rm=T),
#             H = 2.2*IQR(BD_reported_combined, na.rm=T),
#             lower_outlier = qnt1 - H,
#             upper_outlier = qnt2 + H)
# 
# BD_check <- data1 %>% 
#   filter(Source != "CCRCN") %>%
#   ggplot(aes(x = Horizon_bin_cm, y = BD_reported_combined))+
#   coord_flip()+
#   geom_jitter()+
#   geom_hline(data = data_quantiles_BD, aes(yintercept = upper_outlier,
#                                         group = Horizon_bin_cm, 
#                                         color = Horizon_bin_cm),
#              linetype = 'dashed', size = 1)+
#   theme_bw()+
#   labs(title = "Dashed line is 2.2x the interquartile range",
#        x = "Soil depth (mid-point of layer)",
#        y = "Bulk density (g cm-3)")+
#   facet_grid(~Horizon_bin_cm) +  
#   theme(legend.position = "none",
#         legend.title = element_text(size = 12),
#         legend.text = element_text(size = 12),
#         axis.text = element_text(size = 10, color = 'black'),
#         axis.title = element_text(size = 12, color = 'black'))
# BD_check
# 

##### export ####
# path_out = 'reports/04_data_process/figures/outliers/'
# 
# export_fig <- OC_check
# export_file <- paste(path_out, "outliers_OC_all_2.2.png", sep = '') 
# ggsave(export_file, export_fig, width = 8.53, height = 5.20)
# 

#### 5. remove outliers from dataset ####

## here, we are only replacing the original value with an NA

## function to remove outliers

remove_outliers <- function(df, col){
  #function to remove the outliers every time - they are not removed from the original file
  #input: the original data frame, col = the column on which to remove outliers
  #output: the data frame with NAs where the outliers were
  qnt <- quantile(df[ ,col], probs=c(.05, .95), na.rm=T) #finding the quantiles of 5% and 95% for the column desired
  H<-2.2*IQR(df[,col], na.rm=T) #creating a variable H which is 2.2 times the interquartile range. See Kardol et al. 2018 --> they give a statistical ref.
  #replace values above the 2nd quantile + H, and below 1st quantile - H
  df[!is.na(df[,col]) & df[,col] > (qnt[2] + H) , col] <- NA
  df[!is.na(df[,col]) & df[,col] < (qnt[1] - H) , col] <- NA #also need a function for values LOWER than 2.2* IQR
  return(df)
}


data_outliers_removed <- data2 


data_outliers_removed <- remove_outliers(df = data_outliers_removed, col = "OC_perc_combined")
data_outliers_removed <- remove_outliers(df = data_outliers_removed, col = "SOM_perc_combined")
data_outliers_removed <- remove_outliers(df = data_outliers_removed, col = "BD_reported_combined")
data_outliers_removed <- remove_outliers(df = data_outliers_removed, col = "N_perc")


### percent of values removed from both CCRCN and this dataset
#OC percent 
n_outliers_OC <-(sum(!is.na(data1$OC_perc_combined))- sum(!is.na(data_outliers_removed$OC_perc_combined)))
n_outliers_OC/length(data1$OC_perc_combined)*100  

#SOM percent 
n_outliers_SOM <- (sum(!is.na(data1$SOM_perc_combined))- sum(!is.na(data_outliers_removed$SOM_perc_combined)))
n_outliers_SOM/length(data1$SOM_perc_combined)*100  

#BD percent 
n_outliers_BD <- (sum(!is.na(data1$BD_reported_combined))- sum(!is.na(data_outliers_removed$BD_reported_combined)))
n_outliers_BD/length(data1$BD_reported_combined)*100  

#N percent 
n_outliers_N <- (sum(!is.na(data1$N_perc))- sum(!is.na(data_outliers_removed$N_perc)))
n_outliers_N/length(data1$N_perc)*100  

#### 6. last checks: OC to BD and SOM to BD relationships ####

SOM_OC <- data_outliers_removed %>% 
 # filter(is.na(Conv_factor == TRUE)) %>% 
  filter(is.na(SOM_perc_combined) == FALSE & is.na(OC_perc_combined) == FALSE) %>% 
  droplevels() %>% 
    ggplot(aes(x = SOM_perc_combined, y = OC_perc_combined, color= Original_source))+
  theme_bw()+
  geom_point()+
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = 'purple', size =1) + 
  labs(x = "SOM (%)", y = "OC (%)")



###### export outliers fig #####
path_out = 'reports/04_data_process/figures/outliers/'

##studies with SOM to OC
export_fig <- SOM_OC
fig_main_name <- "SOM_OC"
export_file <- paste(path_out, fig_main_name, ".png", sep = '')
ggsave(export_file, export_fig, width = 15.36, height = 8.14)



##### add flag to remove OC > SOM ####
data_outliers_removed1 <- data_outliers_removed %>% 
  mutate(Notes = case_when(OC_perc_combined > SOM_perc_combined ~ 
                             "Outlier - SOC greater than SOM",
                           TRUE ~ Notes))

# # to remove
# data_outliers_removed1 <- data_outliers_removed %>% 
#   # if SOM and SOC are not NA, then only keep values with SOM > SOC 
#   filter(case_when(is.na(SOM_perc_combined) == FALSE
#                    & is.na(OC_perc_combined) == FALSE ~ 
#                      SOM_perc_combined > OC_perc_combined, 
#                    # if SOM and OC are either NA, keep those values
#                    is.na(SOM_perc_combined) == TRUE | 
#                      is.na(OC_perc_combined) == TRUE ~ TRUE )) 




test<- data_outliers_removed1 %>% 
  filter(!grepl("Outlier", Notes, ignore.case = TRUE))
  # if SOM and SOC are not NA, then only keep values with SOM > SOC 
  # filter(case_when(is.na(SOM_perc_combined) == FALSE
  #                  & is.na(OC_perc_combined) == FALSE ~ 
  #                    SOM_perc_combined < OC_perc_combined)) 



SOM_OC_removed <- data_outliers_removed1 %>% 
  filter(!grepl("Outlier", Notes, ignore.case = TRUE)) %>% 
  ggplot(aes(x = SOM_perc_combined, y = OC_perc_combined))+
  theme_bw()+
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = 'purple', size =1) + 
  geom_point()+
  labs(x = "SOM (%)", y = "OC (%)")

SOM_OC_removed



##### remove erronious BD and OC value #####

OC_BD <- ggplot(data_outliers_removed1, aes(x = OC_perc_combined, y = BD_reported_combined))+
  theme_bw()+ 
  geom_point()+
  labs(x = "OC (%)", y = "BD (g cm-3)")

OC_BD

SOM_BD <- ggplot(data_outliers_removed1, aes(x = SOM_perc_combined, y = BD_reported_combined))+
  theme_bw()+ 
  geom_point()+
  geom_vline(xintercept = 100, linetype = "dashed", color = 'purple', size =1) + 
  labs(x = "SOM (%)", y = "BD (g cm-3)")

SOM_BD

###### export outliers fig #####
path_out = 'reports/04_data_process/figures/outliers/'

##studies with SOM to OC # also change to SOM_BD
export_fig <- OC_BD
fig_main_name <- "OC_BD"
export_file <- paste(path_out, fig_main_name, ".png", sep = '')
ggsave(export_file, export_fig, width = 7.15, height = 5.43)


### remove the odd BD vs OC value
data_outliers_removed2 <- data_outliers_removed1 %>%
  mutate(Notes = case_when((BD_reported_combined > 1.5 & OC_perc_combined > 40) ~ 
                             "Outlier - BD and OC values do not match",
                           TRUE ~ Notes))
  
  # # if BD and SOC are not NA, then remove values with BD >1.5 ande OC > 40 (see visual outlier)
  # filter(case_when(is.na(BD_reported_combined) == FALSE
  #                  & is.na(OC_perc_combined) == FALSE ~ 
  #                    !(BD_reported_combined > 1.5 & OC_perc_combined > 40),
  #                  # if BD and OC are either NA, keep those values
  #                  is.na(BD_reported_combined) == TRUE | 
  #                    is.na(OC_perc_combined) == TRUE ~ TRUE))


BD_OC_removed <- data_outliers_removed2 %>% 
  filter(!grepl("Outlier", Notes, ignore.case = TRUE)) %>% 
  ggplot(aes(x = OC_perc_combined, y = BD_reported_combined))+
  theme_bw()+
  geom_point()+
  labs(x = "OC (%)", y = "BD (g cm-3)")

BD_OC_removed


###### replace SOM > 100, <0 with NA ####

data_outliers_removed3 <- data_outliers_removed2 %>%
  mutate(Notes = case_when(SOM_perc_combined > 100 ~ 
                             "Outlier - BD and OC values do not match",
                           TRUE ~ Notes))
  # filter(case_when(is.na(SOM_perc_combined) == FALSE  ~ 
  #                    !(SOM_perc_combined > 100),
  #                  # if BD and OC are either NA, keep those values
  #                  is.na(SOM_perc_combined) == TRUE ~ TRUE))

SOM_removed <- data_outliers_removed3 %>% 
  filter(!grepl("Outlier", Notes, ignore.case = TRUE)) %>% 
  ggplot(aes(x = SOM_perc_combined, y = BD_reported_combined))+
  theme_bw()+
  geom_point()+
  geom_vline(xintercept = 100)+
  labs(x = "SOM (%)", y = "BD (g cm-3)")

SOM_removed


###### check OC vs N ####
OC_N <- data_outliers_removed3 %>% 
  filter(is.na(OC_perc_combined) == FALSE & is.na(N_perc) == FALSE) %>% 
  droplevels() %>% 
  ggplot(aes(x = OC_perc_combined, y = N_perc, color= Original_source))+
  theme_bw()+
  geom_point()+
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = 'purple', size =1) + 
  labs(x = "OC (%)", y = "N (%)")
OC_N

data_outliers_removed4 <- data_outliers_removed3 %>% 
  mutate(Notes = case_when(N_perc > OC_perc_combined ~ 
                             "Caution - N greater than OC",
                           TRUE ~ Notes))

#### 7. export cleaned data ####

path_out = 'reports/04_data_process/data/'

export_file <- paste(path_out, "data_cleaned_outliersremoved.csv", sep = '') 
export_df <- data_outliers_removed4

write.csv(export_df, export_file, row.names = F)


###### NOTE: this step is now done in the global-model-map repository
# reports/02_data_process/01_uniqueID_locations

### export for GEE


# export_df_GEE <- data_outliers_removed3 %>% 
#   filter(!grepl("Outlier", Notes, ignore.case = TRUE)) %>% 
#   filter(is.na(Latitude) == FALSE & is.na(Longitude) == FALSE) %>%
#   distinct(Latitude, Longitude, .keep_all = TRUE)
# 
# setwd("C:/Users/Tania/OneDrive - University of Cambridge/Documents/07_Cam_postdoc/global-marshC-map/reports/02_data_process/data")
# 
# file_name <- paste(Sys.Date(),"data_cleaned_outliersremoved_forGEE", sep = "_")
# export_file_GEE <- paste(file_name, ".csv", sep = '')
# 
# write.csv(export_df_GEE, export_file_GEE, row.names = F)




