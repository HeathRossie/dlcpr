#'The function all csv files and combine
#'
#'@param [serialnumber] if TRUE, serial number variables are added, which index each set of trajectories
#'@param [direc] optional: directory of csv files
#'@param [fps] optional: camera fps
#'@param [spline] if TRUE , drop frames of low likelihood frames and interpolate with smooth spline function. Since peformance of extrapolation is serverely bad, initial and last dropped frames would be NA. Default is TRUE.
#'@param [threshold] threshold for dropping frames if spine = TRUE. Default is .9
#'
#'@return
#' data frame of trajectories. "ser" variable specify time series of trajectories, if serialnumber=TRUE.
#'@export

read.all = function(files, serialnumber = TRUE, direc = NULL, fps = NULL, spline = TRUE, threshold = .90){

  print("#-----------------------------------------------------------------------------------------#")
  print(paste("Importing data with comnfiguration as follows "))
  print(paste("Working directory : ", ifelse(length(direc)==0, getwd(), direc)))
  print(paste("Camera FPS : ", ifelse(length(fps)==0, "not specified", fps)))
  print(paste("Spline Interpolation :", ifelse(spline, "will be applied. That means frames of low likelihood would be dropped", "will not be applied")))
  if(spline) print(paste("Threshold :", threshold))
  print("#-----------------------------------------------------------------------------------------#")

  # apply read.dlc function to all files
  temp = lapply(files, function(file){
    read.dlc(file,
             fps = fps,
             direc = direc,
             spline = spline,
             threshold=threshold)
  })

  # and combine as a data frame
  d = do.call(rbind, temp)

  # if serialnumber is TRUE, add "ser" variable
  # this is a useful variable as serail numbers for further processing
  if(serialnumber == TRUE) d$ser = as.integer(as.factor(d$file))

  print("#-----------------------------------------------------------------------------------------#")
  print("All processes have been done !")
  print("Now, your research can truely starts !")
  print("#-----------------------------------------------------------------------------------------#")
  return(d)
}
