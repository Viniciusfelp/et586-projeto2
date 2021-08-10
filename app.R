library(shiny)
library(shinydashboard)
library(magrittr)
library(lubridate)

source("dataset.R")
source("ui.R")
source("server.R")

shinyApp(ui, server)
