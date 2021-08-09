server <- function(input, output) {
    dt_options <- list(
        pageLength = 10,
        language = list(
            url = "//cdn.datatables.net/plug-ins/1.10.11/i18n/Portuguese-Brasil.json"
        )
    )

    dt_data <- eventReactive(input$dt_select, {
        dt_data <- read.csv("SteamCharts.csv")
        dt <- subset(dt_data, dt_data$gamename == input$game_select)

        return(dt)
    })

    output$charts <- renderDataTable(
        dt_data() %>% as.data.frame(),
        options = dt_options
    )
}
