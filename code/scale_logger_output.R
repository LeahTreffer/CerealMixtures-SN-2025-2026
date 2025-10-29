# format data from scale logger to match data sheet format
# scale logger used to take weights, outputs in long format
# want to pivot wide to have a column for the initial weight and column for weight after watering
# files stored on BOX: https://cornell.box.com/s/xly2hq92e6qt1lbzewc7viy3junnvz4k

# load in necessary functions 
library(readr)
library(readxl)
library(tidyr)
library(dplyr)
process_row <- dget("code/process_row.R")
clean_up_function <- dget("code/clean_up_function.R")
combine_weights <- dget("code/combine_weights.R")

# Load Data
target <- read_excel("data/Target_Weight_Georgia.xlsx")

# set directory to wherever th csv files are located 
directory <- "data"

merged_data <- combine_weights(directory, target) # directory path, target file









##########
data2 <- clean_up_function(data, target) # function to pivot and clean up data

# rename weigh columns with specfic date
data_clean <- data2%>%
  mutate(Initial_Weight_Oct_20 = column1_new,
         Watered_Weight_Oct_20 = column2_new)%>%
  dplyr::select(Barcode_ID, Initial_Weight_Oct_20, Watered_Weight_Oct_20) 
  
