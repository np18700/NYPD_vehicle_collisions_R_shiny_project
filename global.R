library(DT)
library(shiny)
library(googleVis)
library(dplyr)
library(ggplot2)
library(readr)
library(leaflet)
library(leaflet.extras)
library(shinydashboard)
library(plotly)
library(tidyverse)
library(RColorBrewer)
library(scales)
library(lattice)
library(maps)
library(ggthemr)


vehicle_data <- read.csv('data/sample1.csv', stringsAsFactors = FALSE)

choice = unique(sort(vehicle_data$BOROUGH))
choice1 = unique(sort(vehicle_data$YEAR))

choice2 <- colnames(vehicle_data)[-22]
factor <- unique(vehicle_data$CONTRIBUTING.FACTOR.VEHICLE.1)

clean_data= vehicle_data[ ,c(1,2,3,24,6,7,10,11,20,22)]
quotes <- read.csv("data/quotes.csv")
quote <- unique(quotes$Alert.today...Alive.tomorrow.)
