# dlcpr, R package for processing tracking data
This package is data processing toolkits for tracking data from DeepLabCut

DeepLabCut is a software for tracking animal movement and pose estimation based on deep learning (https://github.com/AlexEMG/DeepLabCut). It is available on Python, and produces tracking results easily.

![demo](https://user-images.githubusercontent.com/17682330/72917667-8a903b00-3d44-11ea-93a2-370357be680e.gif)

Despite easiness to use DeepLabCut, a more tricky part is to pre-process raw trajectory data before real analysis. 
This package is a processing toolkit for that.

To install dlcpr package, 
```r
devtools::install_github("HeathRossie/dlcpr")
```


## importing data
DeepLabCut (currently, I am using version 2.0.7.1) produces a tracking result like following.

![demo2](https://user-images.githubusercontent.com/17682330/72918441-f32be780-3d45-11ea-95c9-7e95fbae39d6.png)

This format is incompatible with ordinary function to read a csv file (such as read.csv() or fread()).

The function read.dlc() is modified version of fread() from data.table package to easily read a csv file from DeepLabCut.

```r
# import package
library(dlcpr)
# import also dependent package
library(data.table) 
library(zoo)

setwd("Your folder path")
d = read.dlc("filename.csv", fps = 30)
```

The arguments of read.dlc() is as follows;

direc (optional): you can specify the directory where csv files are stored. If not specified, current working directory will be used.

fps (optional): frame-per-second of your camera. If specified, "time" column will be added.

spline: If TRUE, it drops frames of low likelihood, and interpolate them. Default is TRUE

threshold: Threshold of likelihood. Default is .90


A toy example of "Rock-paper-scissors game" tracking can be found "data" section in this page. You can play around with it.



