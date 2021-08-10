server <- function(input, output) {
    dt_options <- list(
        pageLength = 10,
        language = list(
            url = "//cdn.datatables.net/plug-ins/1.10.11/i18n/Portuguese-Brasil.json"
        )
    )

    dt_data <- eventReactive(input$dt_select, {
        subset(master_df, master_df$gamename == input$game_select) %>% return()
    })

    dt_column <- eventReactive(input$dt_select, {
        dt <- dt_data()

        if (input$col_select == "Número médio de jogadores simultâneos")
            return(dt$avg)

        if (input$col_select == "Maior número de jogadores simultâneos")
            return(dt$peak)

        return(dt$gain)
    })

    dt_info <- eventReactive(input$dt_select, {
        data <- dt_column()

        info <- data.frame(
            Nome         = input$game_select,
            Media        = data %>% mean(),
            Mediana      = data %>% median(),
            Moda         = (-table(data) %>% sort() %>% names())[1],
            MaiorValor   = data %>% max(),
            MenorValor   = data %>% min(),
            DesvioPadrao = data %>% sd()
        )

        return(info)
    })

    output$charts <- renderDataTable(
        dt_data() %>% as.data.frame(),
        options = dt_options
    )

    output$info <- renderDataTable(
        dt_info() %>% as.data.frame(),
        options = dt_options
    )

    output$timedate <- renderUI({
        dt <- dt_data()

        minyear <- min(dt$year)
        maxyear <- max(dt$year)

        maxdate <- paste(maxyear, "12", "15", sep = "-")
        mindate <- paste(minyear, "01", "15", sep = "-")

        dateRangeInput(
            "true_date",
            "Período de Análise",
            end       = maxdate,
            max       = maxdate,
            start     = mindate,
            min       = mindate,
            format    = "MM-yyyy",
            separator = " - ",
            language  = "pt-BR"
        )
    })
}
