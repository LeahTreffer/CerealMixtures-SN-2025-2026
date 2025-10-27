# format data from scale logger to match data sheet format
# scale logger used to take weights, outputs in long format
# want to pivot wide to have a column for the initial weight and column for weight after watering
# files stored on BOX: https://cornell.box.com/s/xly2hq92e6qt1lbzewc7viy3junnvz4k

library(readr)
data <- read_csv("data/Weights_Oct_20.csv")

# 