function (ids, target) 
{
  merged_data <- NULL
  for (i in seq_len(nrow(ids))) {
    file_name <- ids$name[i]
    file_id <- ids$id[i]
    
    data <- box_read_csv(file_id)
    date <- sub(".*Weights_([A-Za-z]{3}_\\d{2}).*", "\\1", 
                basename(file_name))
    data2 <- clean_up_function(data, target)
    initial_col <- paste0("Initial_Weight_", date)
    watered_col <- paste0("Watered_Weight_", date)
    data_clean <- data2 %>% mutate(`:=`(!!initial_col, column1_new), 
                                   `:=`(!!watered_col, column2_new)) %>% select(Barcode_ID, 
                                                                                all_of(initial_col), all_of(watered_col))
    if (is.null(merged_data)) {
      merged_data <- data_clean
    }
    else {
      merged_data <- full_join(merged_data, data_clean, 
                               by = "Barcode_ID")
    }
  }
  return(merged_data)
}
