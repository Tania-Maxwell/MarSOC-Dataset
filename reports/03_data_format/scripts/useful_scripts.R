### useful scripts for data reformatting


#### reformat columns
rename_with(~ gsub("..", "_", .x, fixed = TRUE)) %>% #replacing .. in columns by _
  rename_with(~ gsub(".", "_", .x, fixed = TRUE)) %>%  #replacing . in columns by _



#### deg min sec to dec deg ####

input_data_main02 <- input_data_main01 %>% 
  mutate(lat_detail = "28°01.626",
         long_detail = "12°16.558",
         lat = gsub("°", " ",
                    gsub("\\.", " ", lat_detail)),
         long = gsub("°", " ",
                     gsub("\\.", " ", long_detail)),
         lat_dec_deg = measurements::conv_unit(lat, from = "deg_min_sec", to = "dec_deg"), #N , Keep positive
         long_dec_deg = measurements::conv_unit(long, from = "deg_min_sec", to = "dec_deg"), #W , convert to neg
         Latitude = as.numeric(lat_dec_deg),
         Longitude = as.numeric(long_dec_deg)*-1,
         accuracy_flag = "direct from dataset",
         accuracy_code = "1",
         Site = "Lacustrine_lagoon_THIII")

#### reformat dates ####

mutate(Date = lubridate::dmy(Collection_Date)) %>% 
  mutate(Year_collected = lubridate::year(Date), #separate Year, Month, Day
         Month = lubridate::month(Date), 
         Day = lubridate::day(Date)) %>% 


#### separate depth code ####

separate(Depth_range___cm_, c("U_depth_cm", "L_depth_cm"), sep = '-') %>%  #separate upper and lower depth
  mutate(U_depth_m = as.numeric(U_depth_cm)/100,
         L_depth_m = as.numeric(L_depth_cm)/100) %>% 
  
  
  
#### bind datasets #### 
input_data01 = plyr::rbind.fill(input_data_inner02, input_data_main02)


#### check location points ####


mapWorld <- borders("world", colour="gray50", fill="white")

mp <- ggplot() + 
  mapWorld +
  ylim(-60,80)+
  geom_point(data = input_data03, aes(x = Longitude, y = Latitude, 
                                      color = Site), alpha = 0.5)
mp

#https://r-spatial.org/r/2018/10/25/ggplot2-sf.html 
library(ggplot2)
library(sf) #to map
library(rnaturalearth) #privides map of countries of world
library(rnaturalearthdata) 




##### export data

export_data <- input_data4 %>% 
  select(Source, Site_name, Location, Core, Habitat_type, Latitude, Longitude, 
         accuracy_flag, accuracy_code, Country, Year_collected, Depth_to_bedrock_m, U_depth_m, L_depth_m, 
         Method, Conv_factor, OC_perc, SOM_perc, BD_reported_g_cm3)


## export

path_out = 'reports/03_data_format/data/exported/'

export_file <- paste(path_out, source_name, ".csv", sep = '') 
export_df <- export_data_marsh

write.csv(export_df, export_file)

