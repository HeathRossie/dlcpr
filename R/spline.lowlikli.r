#'Smooth spline function
#'
#'@param
#' fileName: charcters of a file name
#'@return
#' data frame of trajectories
#'@export

spline.lowlikli = function(d, threshold = .90){
  liklirows = grep("likeli", names(d))
  # remove low likelihood row
  for(i in liklirows){
    d[d[,i] < threshold, c(i-2, i-1)] = NA

    # check consecutive NAs
    len = rle(is.na(d[,i-2]))
    xx = d[,i-2]
    yy = d[,i-1]

    # if initial rows are dropped cut them not to extrapolate
    if(is.na(d[1, i-2])){initial_NA = len$lengths[len$values][1]
    xx = xx[-(1:initial_NA)]
    yy = yy[-(1:initial_NA)]
    }else{initial_NA = 0}

    # if last rows are dropped cut them not to extrapolate
    if(is.na(d[nrow(d), i-2])){
      last_NA = len$lengths[len$values][length(len$lengths[len$values])]
      xx = xx[-((length(xx)- last_NA + 1):length(xx))]
      yy = yy[-((length(yy)- last_NA + 1):length(yy))]
    }else{last_NA = 0}

    # smooth spline interpolation
    d[,i-2] = c(rep(NA, initial_NA), zoo::na.spline(xx), rep(NA, last_NA))
    d[,i-1] = c(rep(NA, initial_NA), zoo::na.spline(yy), rep(NA, last_NA))
  }

  return(d)
}
