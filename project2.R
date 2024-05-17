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

#node info csv for gephi
write.csv(node_info,"node_info.csv", row.names = FALSE)

#stole from online to get the most common element of a vector
getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

#filter out engine==0 since there are 12000 of them out of 46000
#most likely signifies a lack of actual engine ID
engine_by_make <- dataset %>% 
  select(make, engine) %>% 
  filter(engine!=0) %>% 
  group_by(make) %>% 
  reframe(
    'Engine' = unique(engine))

#add columns for the numeric of the factors (will be used in python)
engine_by_make <- engine_by_make %>% 
  mutate('MakeID'=as.numeric(make))
engine_by_make <- engine_by_make %>% 
  mutate('EngineID'=as.numeric(Engine))

#create csv for further processing in python
write.csv(engine_by_make,"engine_by_make.csv", row.names = FALSE)