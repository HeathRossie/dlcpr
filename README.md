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


## Current functionality

| function | usage |
----|---- 
| read.dlc | read csv file, exported from DeepLabCut |
| read.all | apply read.dlc() to multiple csv files and combine into one data frame |
| get_velocity | estimate velocity by 3rd order approximation |


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


| argument |  |
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



## Estimate velocity
A function `get_velocity()` estimates velocity by 3rd order approximation.  

![demo](https://user-images.githubusercontent.com/17682330/73118967-bb968880-3f5b-11ea-9512-1617757f6fd0.png)  
where v, p, Δt represent velocity, position, time step, respectively.  
The first and last frames are dropped and NA is assigned.


For examole, checking derivation of sin(x) equals to cos(x), since velocity is the first derivative of position.


```r
# d is a data.frame created by read.dlc() or read.all()
d$sin = sin(d$time)
plot(d$sin)
d$vel = get_velocity(d, d$sin)
d$cos = cos(d$time)

# black line represents estimated values and read line represents cosine function
ggplot(d) +
  geom_line(aes(x=time, y=vel)) +
  geom_line(aes(x=time, y=cos), colour="red", lty=2) +
  xlim(0, 10) + xlab("time") + ylab("velocity")

```

![demo](https://user-images.githubusercontent.com/17682330/73118924-15e31980-3f5b-11ea-8b95-7f0be9c5452b.png)



In more realistic situations, we usually have several time series of trajectories.  
`get_velocity()` automatically split the data according to `ser` variable (serial number), estimate velocity of each time series, and combine them.


For example, in the case that we have three time series in a data frame, which means that `read.all()` function read three csv files, 

![demo](https://user-images.githubusercontent.com/17682330/73119079-3613d800-3f5d-11ea-9242-d0a1b1afde64.png)


we can simply apply `get_velocity()` to the data frame.

```r
d$vel_palm_x = get_velocity(d, d$palm_x)
d$vel_palm_y = get_velocity(d, d$palm_y)
d$vel_palm = sqrt(d$vel_palm_x^2 + d$vel_palm_y^2)

ggplot(d) +
  geom_line(aes(x=time, y=vel_palm, colour=as.factor(d$ser))) + 
  ylab("velocity (pixel/second)")
```

![demo](https://user-images.githubusercontent.com/17682330/73119032-aa9a4700-3f5c-11ea-9624-d056634e658d.png)



| argument |  |
----|---- 
| d | data frame created by read.dlc() or read.all() |
| vec | a vector that you are interested in estimating velocity | 

