# dlcpr, R package for processing tracking data
This package is a data processing toolkit for tracking data obtained from DeepLabCut.


DeepLabCut is a software for tracking animal movement and pose estimation based on deep learning (https://github.com/AlexEMG/DeepLabCut). It is available on Python, and produces highly accurate tracking results with 50-200 training data.

![demo](https://user-images.githubusercontent.com/17682330/72917667-8a903b00-3d44-11ea-93a2-370357be680e.gif)

A bit tricky part is to pre-process raw trajectories before real analysis.  This package is a processing toolkit for that.


To install dlcpr package, 
```r
install.package("devtools") # if needed
devtools::install_github("HeathRossie/dlcpr")
```


## importing data
DeepLabCut (currently, I am using version 2.0.7.1) produces a tracking result like following.

![demo2](https://user-images.githubusercontent.com/17682330/72918441-f32be780-3d45-11ea-95c9-7e95fbae39d6.png)


Tracking example of "Rock-paper-scissors game" tracking can be found "data" section in this page. You can play around with it.


This format is incompatible with ordinary functions to read a csv file (such as `read.csv()` or `fread()`).


The function `read.dlc()` is modified version of fread() from data.table package to easily read a csv file from DeepLabCut.

```r
# import package
library(dlcpr)
# import also dependent package
library(data.table) 
library(zoo)

setwd("Your folder path")
d = read.dlc("filename.csv", fps = 30)
```

The arguments of `read.dlc()` is as follows;


| argument | mean |
----|---- 
| direc (optional) | you can specify the directory where csv files are stored. If not specified, current working directory will be used. |
| fps (optional) | frame-per-second of your camera. If specified, "time" column will be added. |
| spline | If TRUE, it drops frames of low likelihood, and interpolate them. Default is TRUE. |
| threshold | Threshold of likelihood. Default is .90 |


## importing all data in a directory
In most situations, we have several videos to analyze, resulting in multiple csv files.


`read.all()` function applies `read.dlc()` to all csv files.
```r
setwd("Your Folder Path")
files = list.files(pattern = ".csv")
files
```

`list.files()` is not a function from dlcpr package, but useful to get file names in the directory.
![demo3](https://user-images.githubusercontent.com/17682330/72967674-257b2a80-3dc2-11ea-97c2-2930590e67a6.png)

Then, read these csv files at once. 
```r
d = read.all(files, spline=TRUE, threshold = .9, fps=30)
```
![demo](https://user-images.githubusercontent.com/17682330/72969594-172f0d80-3dc6-11ea-8ea1-1bcbb8a8a663.png)

resulting in a data frame, wchich contains all trajectories.

Each time series of trajectories are indexed by `file` and `ser` columns. You can perform futher processes by using these variables.

```r
d$file
```
![demo4](https://user-images.githubusercontent.com/17682330/72968488-ea79f680-3dc3-11ea-88d4-a27100253b8b.png)


```r
d$ser
```
![demo4](https://user-images.githubusercontent.com/17682330/72968503-f06fd780-3dc3-11ea-9d75-d91080e97e39.png)


`ser` variable is serial numbers assigned to each time series.


For example, height of palm can be visualized as follows;

```r
library(ggplot2)
ggplot(d) +
  geom_line(aes(x=time, y=palm_y, colour=as.factor(ser)))
```
The arugumen `colour=as.factor(ser)` enables to depict lines for each time series.

![demo5](https://user-images.githubusercontent.com/17682330/72969041-06ca6300-3dc5-11ea-9a53-e46ee79e2051.png)


