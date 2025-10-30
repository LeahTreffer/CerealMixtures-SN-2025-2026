crop_n_rotate <- function(x){
  require(EBImage)
  img <- readImage(x, all = TRUE)
  # find center coordinates
  dims_orig <- dim(img)
  
  cx_original <- dims_orig[[1]]/2
  cy_original <- dims_orig[[2]]/2
  
  repeat{
    dev.new(height = 7, width = 8, units = "in")
    plot(rgbImage(img[,,1], img[,,2], img[,,3]))
    cat("Beginning in what should be the top left corner if the\n rhizobox were upright, click clockwise around the box\n")
    pts <- locator(4)
    
    points(pts$x, pts$y, col = "red", pch = 19, cex = 2)
    text(pts$x, pts$y, labels = 1:4, col = "yellow", pos = 3, cex = 1.5)
    happiness_question <- readline("are you happy with these points (y/n): ")
    if (happiness_question == "y"){
      dev.off()
      break
    } else if (happiness_question != "n"){
      cat("Only y or n please!")
    }
    
  }
  # Calculate angles from multiple edges 
  
  top_angle <- atan2(pts$y[2] - pts$y[1], pts$x[2] - pts$x[1])
  bottom_angle <- atan2(pts$y[3] - pts$y[4], pts$x[3] - pts$x[4])
  left_side_angle <- atan2(pts$y[4] - pts$y[1], pts$x[4] - pts$x[1]) - pi/2
  right_side_angle <- atan2(pts$y[3] - pts$y[2], pts$x[3] - pts$x[2]) - pi/2

  
  # Average angles with weird math
  angles <- c(top_angle, bottom_angle, left_side_angle, right_side_angle)
  
  just_angle <- atan2(mean(sin(angles)), mean(cos(angles)))
  angle <- - atan2(mean(sin(angles)), mean(cos(angles)))* 180/pi
  
  cat(sprintf("Rotating by %.2f degrees\n", angle))
  
  # img2 <- img[xmin:xmax, ymin:ymax,]
  
  # Rotate all channels
  img_rotated <- rotate(img, angle, bg.col = "black")
  
  dims_rotated <- dim(img_rotated)
  cx_rotated <- dims_rotated[[1]]/2
  cy_rotated <- dims_rotated[[2]]/2
  
  # point translation
  points_translated_x <- pts$x - cx_original
  points_translated_y <- pts$y - cy_original 
  
  points_translated <- data.frame(x = points_translated_x, y = points_translated_y)
  points_translated$x_trans <- points_translated$x * cos(just_angle) - points_translated$y * sin(just_angle) + cx_rotated
  points_translated$y_trans <- points_translated$x * sin(just_angle) + points_translated$y * cos(just_angle) + cy_rotated
  
  # perform crop 
  img_cropped <- img_rotated[min(points_translated$x_trans):max(points_translated$x_trans), min(points_translated$y_trans):max(points_translated$y_trans),]
  
  display(img_cropped[,,3], method = "raster")
  return(img_rotated)
}
