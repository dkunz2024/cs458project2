#install.packages("tidyverse") #run once to install
library(tidyverse)

#get raw data from CSV
setwd("C:/Users/Denton/Documents/.School/cs458/project2")
dataAll <- read.csv("vehicles.csv")

#construct our dataset
dataset <- dataAll %>% 
  select(make, model, UCity, UHighway, year, fuelCost08, trany, engId) %>% 
  rename(fuelCost=fuelCost08, transmission=trany, cityMPG=UCity, hwyMPG=UHighway, engine=engId)

#get all of the rows with any missing information
missing <- !complete.cases(dataset)
missing.df <- dataset[missing,]

#change make, model, transmission into categorical variables
dataset$make <- as.factor(dataset$make)
dataset$model <- as.factor(dataset$model)
dataset$transmission <- as.factor(dataset$transmission)
dataset$engine <- as.factor(dataset$engine)

#get the average city, hwy, and overall mpg of each make
node_info <- dataset %>% 
  select(make, cityMPG, hwyMPG, year, engine) %>% 
  group_by(make) %>% 
  summarise(
    count = n(),
    'Average City' = mean(cityMPG),
    'Average Highway' = mean(hwyMPG),
    'Average' = (mean(cityMPG)+mean(hwyMPG))/2)

#stole from online to get the most common element of a vector
getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

engine_by_make <- dataset %>% 
  select(make, engine) %>% 
  filter(engine!=0) %>% 
  group_by(make) %>% 
  reframe(
    'Engine' = unique(engine))

#create make x engine matrix where we store 1 for every engine type used by that make
make_x_engine <- matrix(0, nrow = 2765, ncol = 144, byrow = FALSE)

for (i in 1:nrow(engine_by_make)){
  i_make <- engine_by_make[i,1]
  i_engine <- engine_by_make[i,2]
  make_x_engine[i_make, i_engine]
}
