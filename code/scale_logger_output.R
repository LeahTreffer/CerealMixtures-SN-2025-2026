# format data from scale logger to match data sheet format
# scale logger used to take weights, outputs in long format
# want to pivot wide to have a column for the initial weight and column for weight after watering
# files stored on BOX: https://cornell.box.com/s/xly2hq92e6qt1lbzewc7viy3junnvz4k
# right now this requires manually downloading the files from BOX and adding them to the folder with the github project

# load in necessary functions 
library(readr)
library(readxl)
library(tidyr)
library(dplyr)
library(boxr)
process_row <- dget("code/process_row.R")
clean_up_function <- dget("code/clean_up_function.R")
combine_weights <- dget("code/combine_weights.R")

# Load in the file with plot ID and treatment target weight for the pots
# plot ID column needs to be Barcode_ID
target <- read_excel("data/Target_Weight_Georgia.xlsx")
#colnames(target)[1] <- "Barcode_ID" # run this if plot ID column is anything besides Barcode_ID

# set directory to wherever the csv files are located 
directory <- "data/scale_logger/Georgia"

# run function to clean up each days file and combine into one table
merged_data <- combine_weights(directory, target) # directory path, target file

# save file back to directory
write_csv(merged_data, 'data/Intermediate/pot_weights_Georgia1.csv')







########## extra unnecessary stuff 
data2 <- clean_up_function(data, target) # function to pivot and clean up data

# rename weigh columns with specfic date
data_clean <- data2%>%
  mutate(Initial_Weight_Oct_20 = column1_new,
         Watered_Weight_Oct_20 = column2_new)%>%
  dplyr::select(Barcode_ID, Initial_Weight_Oct_20, Watered_Weight_Oct_20) 
  
