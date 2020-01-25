#'Calculating velocity by 3rd ordered approximation
#'
#'@param [d] data frame created by read.dlc() or read.all()
#'@param [vec] a vector to calcurate velocity. Normally, a column of d
#'@return
#' velocity estimated with 3rd order approximation
#'@export

get_velocity = function(d, vec){
  d$vec = vec

  # check serial number variable
  if(length(d$ser)==0){
    print("Error : No serial number")
    print("Please serialnumber=TRUE when applying read.dlc or read.all")
  }else{

    calc = function(d){
      # denominator
      if(length(d$time) != 0){
        time = (diff(xx)*2)[1]
      }else{
        time = 2
        print("There is no 'time' variable, so use 2 instead")
      }

      v = (d$vec[3:length(d$vec)]-d$vec[1:(length(d$vec)-2)])/time
      v = c(NA, v, NA)
      return(v)
    }

    temp = split(d, d$ser)
    temp = lapply(temp, calc)
    v = unlist(temp)
  }

  if(!("v" %in% ls())) v = NULL
  return(v)
}

