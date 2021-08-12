library(shiny)
library(shinydashboard)
library(magrittr)
library(lubridate)
library(DT)
library(ggplot2)

source("dataset.R")
source("ui.R")
source("server.R")

shinyApp(ui, server)
