# Load the required libraries
library(shiny)
library(shinydashboard)
library(dplyr)
library(leaflet)
library(leaflet.minicharts)
library(plotly)

# Clean up the environment
rm(list = ls())
gc()

# Set up the working directory
base.dir <- getwd()
base.dir <- substr(base.dir, 1, nchar(base.dir)-2)
data.dir <- file.path(base.dir, "data")

# Load the source data
generation <- read.csv(file.path(data.dir,'generation.csv'), header = T, stringsAsFactors = F)
interface.flow <-read.csv(file.path(data.dir,'interface.flow.csv'), header = T, stringsAsFactors = F)

# Identify the resource types
resource.type <- names(generation)[5:14]

# Identify the zones
zone.names <-unique(generation$Zone)

# Identify the interfaces
interface.names <-unique(interface.flow$Interface)

# Create the base map
tilesURL <- "http://server.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer/tile/{z}/{y}/{x}"

basemap <- leaflet(width = "100%", height = "400px") %>%
  addTiles(tilesURL)
