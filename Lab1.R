## Introduction to Data Journalism
## Coding Lab 1

# working with R --------------------------
x <- c(4, 4, 5, 6, 7, 2, 9)     
length(x) ; mean(x)
plot(x)  # plot the vector


# look that the women dataset
data(women)
class(women)
print(women)
summary(women)
plot(women)

# fit a regression
women.lm <- lm(weight~height, data=women)
class(women.lm)
print(women.lm)
summary(women.lm)
plot(women.lm)

# managing the workspace
getwd()
ls()
rm(x)

# getting help
help(median)
??median

# working with packages
install.packages("vcd")  # requires an internet connection
library(vcd)
help(package="vcd")
data(package="vcd")
help(Arthritis)
Arthritis
example(Arthritis)

# importing data
districts <- read.csv("district means grade equivalent std.csv")

library(readxl)
tstops <- read_excel("tstops_jan2014.xlsx")

# working data sets
dim(tstops)
ncol(tstops)
nrow(tstops)
str(tstops)
summary(tstops)
View(tstops)
save(tstops, file="tstops.rdata")
rm(tstops)
load(file="tstops.rdata")

# data structures --------------------------

# vectors
a <- c(1, 2, 5, 3, 6, -2, 4)
b <- c("one", "two", "three")
c <- c(TRUE, TRUE, TRUE, FALSE, TRUE, FALSE)

# identifying vector elements
a <- c(1, 2, 5, 3, 6, -2, 4)
a[3]
a[c(1, 3, 5)]
a[2:6]

# data frames
patientID   <- c(111, 208, 113, 408)
age         <- c(25, 34, 28, 52)
sex         <- c(1, 2, 1, 1)
diabetes    <- c("Type1", "Type2", "Type1", "Type1")
status      <- c(1, 2, 3, 1)
patientdata <- data.frame(patientID, age, sex, diabetes, status)
patientdata

# specifying the elements of a data frame
patientdata[1:2]
patientdata[c("diabetes", "status")]
patientdata$age

patientdata[2:3, 1:2]

# factors
patientdata$sex <- factor(patientdata$sex, 
             levels=c(1, 2),
             labels=c("Male", "Female"))

patientdata$status <- factor(patientdata$status, ordered=TRUE,
                         levels=c(1, 2, 3),
                         labels=c("Poor", "Improved", "Excellent"))

patientdata
str(patientdata)

# lists
g <- "My First List"
h <- c(25, 26, 18, 39)
j <- matrix(1:10, nrow = 5)
k <- c("one", "two", "three")

mylist <- list(title = g, ages = h, j, k)
 
mylist

# specifying components and elements of a list
mylist[[2]] 
mylist[["ages"]]
mylist[[2]][2]
mylist[[3]][2,2]


# data management with dplyr -------------------------
library(dplyr)

# subset data by selecting rows
df1 <- filter(mtcars, cyl==4, mpg > 20)
df2 <- filter(mtcars, cyl==4 & mpg > 20) # same
df3 <- filter(mtcars, cyl %in% c(4, 6) | am ==1)

# subset data by selecting columns (variables)
df1 <- select(mtcars, mpg, cyl, wt)
df2 <- select(mtcars, mpg:qsec, carb)
df3 <- select(mtcars, -am, -carb)

# reorder rows
df1 <- arrange(mtcars, cyl)
df2 <- arrange(mtcars, cyl, mpg)
df3 <- arrange(mtcars, cyl, desc(mpg))

# create new variables (add new columns)
df1 <- mutate(mtcars,
              power = disp * hp,
              am = factor(am,
                      levels=c(0, 1),
                      labels = c("automatic", "manual"))
 )
 
# rename variables (columns)
df1 <- rename(mtcars,
             displacement = disp,
             transmission = am)
 

# aggregate data by groups
df <- group_by(mtcars, cyl, gear)
df2 <- summarise(df, 
                 disp_n = n(),
                 disp_mean = mean(disp),
                 disp_sd = sd(disp)
)

df2 <- summarise_each(df, funs(mean))
df3 <- summarise_each(df, funs(min, max))
View(df3)

# puting it all together
df <- select(mtcars, cyl, disp, mpg)
df <- filter(df, mpg > 20)
df <- arrange(df, cyl, desc(mpg))

df <- select(mtcars, cyl, disp, mpg) %>%
  filter(mpg > 20) %>%
  arrange(cyl, desc(mpg))

