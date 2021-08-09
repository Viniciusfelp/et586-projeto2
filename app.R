library(shiny)
library(shinydashboard)
library(magrittr)

source("dataset.R")
source("ui.R")
source("server.R")

shinyApp(ui, server)
