clean_up_function <- function(data, target) {
  data$Value <- gsub("kg\\s*\\??[GN]", "", data$Weight, ignore.case = TRUE)
  data$Value <- as.numeric(data$Value)

  df_wide <- data %>%
    select(Barcode_ID, Value)%>%
    group_by(Barcode_ID) %>%
    mutate(n = row_number()) %>%      
    pivot_wider(
      names_from = n,
      values_from = Value,
      names_prefix = "Weight_"
    )%>%
    mutate(Barcode_ID = as.numeric(Barcode_ID)) %>%
    arrange(Barcode_ID)

  df <- merge(df_wide, target, by='Barcode_ID')

  data2 <- df %>%
    rowwise() %>%
    mutate(
      new_cols = list(process_row(Weight_1, Weight_2, if("Weight_3" %in% names(df)) Weight_3 else NA, Target_weight)),
      column1_new = new_cols[[1]],
      column2_new = new_cols[[2]]
    ) %>%
   ungroup() %>%
    dplyr::select(-new_cols)

  return(data2)
}
