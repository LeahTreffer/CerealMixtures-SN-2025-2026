process_row <- function(c1, c2, c3= NA, c4) {
  # Case 1: c1 & c2 exist, c3 missing → ignore (return NA for all)
  if (!is.na(c1) & !is.na(c2) & is.na(c3)) {
    return(c(c1, c2))
  }
  
  # Case 2: c1, c2, c3 exist → keep two most different values
  if (!is.na(c1) & !is.na(c2) & !is.na(c3)) {
    vals <- c(c1, c2, c3)
    # find the pair with largest absolute difference
    combs <- combn(vals, 2)
    diffs <- abs(combs[1,] - combs[2,])
    best_pair <- combs[, which.max(diffs)]
    # return sorted so column1 = smaller, column2 = larger
    return(sort(best_pair))
  }
  
  # Case 3: only c1 exists → compare with c4
  if (!is.na(c1) & is.na(c2) & is.na(c3) & !is.na(c4)) {
    if ((c4 - c1) > 0.005) {
      return(c(c1, NA))
    } else {
      return(c(NA, c1))
    }
  }
  
  # All other cases → leave as is
  return(c(c1, c2))
}