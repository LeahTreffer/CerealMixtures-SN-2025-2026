# loop through files in data that start with Weights_ to process them and merge into combined table

function(directory, target) {
  files <- list.files(path = directory, pattern = "\\.csv$", full.names = TRUE)
  merged_data <- NULL
  
  for (file in files) {
    data <- read.csv(file)
    date <- sub(".*Weights_([A-Za-z]{3}_\\d{2}).*", "\\1", basename(file))
    
    data2 <- clean_up_function(data, target)
    
    # Create dynamic column names
    initial_col <- paste0("Initial_Weight_", date)
    watered_col <- paste0("Watered_Weight_", date)
    
    data_clean <- data2 %>%
      mutate(
        !!initial_col := column1_new,
        !!watered_col := column2_new
      ) %>%
      select(Barcode_ID, all_of(initial_col), all_of(watered_col))
    
    # Merge by Barcode_ID (outer join)
    if (is.null(merged_data)) {
      merged_data <- data_clean
    } else {
      merged_data <- full_join(merged_data, data_clean, by = "Barcode_ID")
    }
  }
  
  return(merged_data)
}
