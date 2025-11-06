pull_date <- function(x){
  # x = tiff file you are interested in
  require(exifr)
  require(lubridate)
# 
  get_metadata <- read_exif(x)
  get_metadata
  create_date <- get_metadata$FileModifyDate |> lubridate::ymd_hms()
}
