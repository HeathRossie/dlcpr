#'This is modified function of fread from data.table package by adjusting to the format of DeepLabCut files
#'
#'@param [direc] optional: directory of csv files
#'@param [fps] optional: camera fps
#'@param [spline] if TRUE , drop frames of low likelihood frames and interpolate with smooth spline function. Since peformance of extrapolation is serverely bad, initial and last dropped frames would be NA. Default is TRUE.
#'@param [threshold] threshold for dropping frames if spine = TRUE. Default is .9
#'@return
#' data frame of trajectories
#'@export


read.dlc = function(fileName, direc = NULL, fps = NULL, spline = TRUE, threshold = .90){

  # change directory if specified
  if(length(direc) != 0){
    cd = getwd()
    setwd(direc)
  }

  d = data.table::fread(fileName, skip=2, data.table = FALSE)

  # rename variables
  colName = colnames(fread(fileName, skip=1, data.table = FALSE))
  colName[1] = "seq"
  for(i in 2:length(colName)){
    if(i %in% seq(2, length(colName), 3)){
      colName[i] = paste(colName[i], "_x", sep="")
    }else if(i %in% seq(3, length(colName), 3)){
      colName[i] = paste(colName[i], "_y", sep="")
    }else if(i %in% seq(4, length(colName), 3)){
      colName[i] = paste(colName[i], "_likeli", sep="")
    }
  }
  colnames(d) = colName

  # add filename variable
  d$file = fileName

  # if frame-per-second is specified, add time variable
  if(length(fps) != 0) d$time = d$seq * 1/fps

  # if spline = TRUE, drop low likelihood frames and spline interpolation would be applied
  if(spline){
    d = spline.lowlikli(d)
  }

  # show result
  print(paste("data process succeeded! file name : ", substr(fileName, 0, 45), "...",  sep=""  ))

  if(length(direc) != 0){
    setwd(cd)
  }

  return(d)
}
