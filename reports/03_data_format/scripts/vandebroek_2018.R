## import data from Van de Broek et al. (2018), Mendeley data from Global Change Biology
## from 
## export for marsh soil C
# contact Tania Maxwell, tlgm2@cam.ac.uk
# 21.07.22

library(readxl)  
library(tidyverse)
library(measurements)


##read all excel sheets
#https://stackoverflow.com/questions/12945687/read-all-worksheets-in-an-excel-workbook-into-an-r-list-with-data-frames 
read_excel_allsheets <- function(filename, tibble = FALSE) {
  # I prefer straight data.frames
  # but if you like tidyverse tibbles (the default with read_excel)
  # then just pass tibble = TRUE
  sheets <- readxl::excel_sheets(filename)
  x <- lapply(sheets, function(X) readxl::read_excel(filename, col_names = F, sheet = X))
  if(!tibble) x <- lapply(x, as.data.frame)
  names(x) <- sheets
  x
}

##### importing bulk density ####

input_file01 <- "reports/03_data_format/data/core_level/VandeBroek_2018_Mendeley_Data/Bulk density.xlsx"


mysheets <- read_excel_allsheets(input_file01)

#remove the information list
mysheets_noinfo <- mysheets[-1]


###extracting the depth and average bulk density from each sheet - this is the 1st and 6th columns

columns <- c("...1", "...3")

bulkdensity0 <- lapply(mysheets_noinfo, '[', columns)

##adding a column with site name
bulkdensity1 <- Map(cbind, bulkdensity0, Site = names(bulkdensity0))

##renaming the columns
colnames <- c("Depth_m", "BD_reported_g_cm3", "Site")
bulkdensity2 <- lapply(bulkdensity1, setNames, colnames)

##convert from list to dataframe
bulkdensity_df0 <- do.call(rbind.data.frame, bulkdensity2)

# this splits up the list to different data frames - not to use
#list2env(bulkdensity1,envir=.GlobalEnv)



##renaming the rows
rownames(bulkdensity_df0) <- 1:nrow(bulkdensity_df0)


###removing useless rows
bulkdensity_df1 <- bulkdensity_df0 %>%
  arrange(Depth_m) %>% 
  slice(-c(108:143)) %>% 
  arrange(Site) %>% 
  mutate(BD_reported_g_cm3 = as.numeric(BD_reported_g_cm3))

bulkdensity_df2 <- bulkdensity_df1 %>% 
  separate(Depth_m, c("U_depth_m", "L_depth_m"), sep = ' - ')

##### importing soil carbon ####

input_file02 <- "reports/03_data_format/data/core_level/VandeBroek_2018_Mendeley_Data/Organic_carbon.csv"

soilcarbon0 <- read.csv(input_file02)

##renaming sites to match

soilcarbon1 <- soilcarbon0 %>% 
  mutate(Site = gsub("Young", "young",
                     gsub("Old", "old", Site)))

soilcarbon1$Site <- str_trim(soilcarbon1$Site)

  
### import locations

input_file03 <- "reports/03_data_format/data/core_level/VandeBroek_2018_Mendeley_Data/locations.csv"

locations0 <- read.csv(input_file03)

locations1 <- locations0 %>% 
  rename(lat_detail = Latitude,
         long_detail = Longitude,
         Latitude = Lat.DD,
         Longitude = Long.DD) %>% 
  mutate(accuracy_flag = "direct from dataset",
         accuracy_code = "1")

##replace all "low" with "young" and "high" with "old"

locations2 <- locations1 %>% 
  mutate(Site = gsub("low", "young",
                     gsub("high", "old", Site))) 

locations2$Site <- str_trim(locations2$Site)

###merge soil carbon

soilcarbon2 <- full_join(soilcarbon1,locations2, by = "Site") %>% 
  slice(1:301)


##### edit dataset with info ####


##### add informational  
source_name <- "Van de Broek et al 2018"
author_initials <- "MVdB"


soilcarbon3 <- soilcarbon2 %>% 
  mutate(Source = source_name,
         Source_abbr = author_initials,
         Site_name = paste(Source_abbr, Site),
         Country = "Belgium",
         Method = "EA",
         Year_collected = "2016") %>% 
  rename(OC_perc = OC......mass.spec.)


## edit depth

soilcarbon4 <- soilcarbon3 %>% 
  group_by(Site) %>% 
  mutate(U_depth_m = Depth..m. + 0.015,
         L_depth_m = Depth..m. - 0.015)


