## import data from Van de Broek et al. (2018), Mendeley data from Global Change Biology
## from 
## export for marsh soil C
# contact Tania Maxwell, tlgm2@cam.ac.uk
# 21.07.22

library(readxl)  
library(tidyverse)


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

columns <- c("...1", "...6")

bulkdensity0 <- lapply(mysheets_noinfo, '[', columns)

##adding a column with site name
bulkdensity1 <- Map(cbind, bulkdensity0, Site = names(bulkdensity0))

names(bulkdensity1)
list2env(bulkdensity1,envir=.GlobalEnv)

##### importing soil carbon ####

input_file02 <- "reports/03_data_format/data/core_level/VandeBroek_2018_Mendeley_Data/Bulk density.xlsx"


mysheets2 <- read_excel_allsheets(input_file02)

#remove the information list
mysheets_noinfo <- mysheets2[-1]


###extracting the depth and average bulk density from each sheet - this is the 1st and 6th columns

columns <- c("...1", "...6")

soilcarbon0 <- lapply(mysheets_noinfo, '[', columns)

##adding a column with site name
soilcarbon1 <- Map(cbind, soilcarbon0, Site = names(soilcarbon0))

