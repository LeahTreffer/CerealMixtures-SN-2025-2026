# Built from scale_logger_outpot workflow, but directly pulls files from BOX

# format data from scale logger to match data sheet format
# scale logger used to take weights, outputs in long format
# want to pivot wide to have a column for the initial weight and column for weight after watering
# files stored on BOX: https://cornell.box.com/s/xly2hq92e6qt1lbzewc7viy3junnvz4k
# BOX dosn't have file paths like other repositories, so can't just call the files from thier folder, have to have thier specific BOX id

# Load in functions
library(boxr)
library(readr)
library(readxl)
library(tidyr)
library(dplyr)
process_row <- dget("code/process_row.R")
clean_up_function <- dget("code/clean_up_function.R")
combine_weights <- dget("code/combine_weights_BOX.R")

# Load in the file with plot ID and treatment target weight for the pots
# plot ID column needs to be Barcode_ID
target <- read_excel("data/Target_Weight_Georgia.xlsx")
#colnames(target)[1] <- "Barcode_ID" # run this if plot ID column is anything besides Barcode_ID

# Navigate to the folder with desired files and get the ids to load
box_ls()
# Cereal Mixtures 2025 folder id : 326957031709
box_ls(326957031709)
# partial data folder id : 347018586431
box_ls(347018586431)
# scale logger output folder id : 348737531753
box_ls(348737531753)
# Georgia1 folder id: 348738179743
box_ls(348738179743)

Georgia_weights <- box_ls(348738179743) # list of files within scale_logger/Georgia folder
#ids <- sapply(Georgia_weights, function(x) x$id) # string of ids
#name <- sapply(Georgia_weights, function(x) x$name) 
# df <- box_read_csv(ids[1]) # read in file directly from BOX
Georgia_weights_df <- data.frame(
  name = sapply(Georgia_weights, function(x) x$name),
  id   = sapply(Georgia_weights, function(x) x$id),
  stringsAsFactors = FALSE
)

# run function to clean up each days file and combine into one table
merged_data <- combine_weights(Georgia_weights_df, target)

# save file back to BOX directory
# Create a temporary file
tmp_file <- tempfile(fileext = ".csv")  # temp CSV file
# Write the object to the temporary file
write.csv(merged_data, tmp_file, row.names = FALSE)
# Rename temp file to the desired upload name
tmp_file_renamed <- file.path(tempdir(), "Georgia1_Weights.csv")
file.rename(tmp_file, tmp_file_renamed)
# Upload the temporary file to Box
folder_id <- 347018586431  # Save to the partial_data folder
box_ul(folder_id, tmp_file_renamed) # name file
# Optionally remove the temporary file (not strictly necessary)
unlink(tmp_file)
