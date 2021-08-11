server <- function(input, output) {
    dt_options <- list(
        pageLength = 10,
        language = list(
            url = "//cdn.datatables.net/plug-ins/1.10.11/i18n/Portuguese-Brasil.json"
        )
    )

    dt_data <- eventReactive(input$dt_select, {
        dt <- master_df %>% filter_name(input$game_select)
        interval <- input$true_date

        if (!is.null(interval))
            dt <- dt %>% filter_date(interval)

        return(dt)
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
        column <- dt_column()

        data.frame(
            Nome         = input$game_select,
            Media        = column %>% mean(),
            Mediana      = column %>% median(),
            Moda         = (-table(column) %>% sort() %>% names())[1],
            MaiorValor   = column %>% max(),
            MenorValor   = column %>% min(),
            DesvioPadrao = column %>% sd()
        ) %>%
        t() %>%
        as.data.frame() %>%
        return()
    })

    get_interval <- function(mindate, maxdate) {
        if (is.null(input$true_date))
            return(c(mindate, maxdate))

        interval <- input$true_date

        if (input$true_date[1] %>% is.na())
            interval[1] <- mindate

        if (input$true_date[2] %>% is.na())
            interval[2] <- maxdate

        return(interval)
    }


    output$charts <- renderDataTable(
        dt_data() %>% as.data.frame(),
        options = dt_options
    )

    output$info <- renderDataTable(
        dt_info() %>% as.data.frame(),
        options = dt_options
    )

    output$timedate <- renderUI({
        dt <- master_df %>% filter_name(input$game_select)

        maxdate <- dt$year %>% max() %>% paste("12", "31", sep = "-")
        mindate <- dt$year %>% min() %>% paste("01", "01", sep = "-")

        curr_interval <- get_interval(mindate, maxdate)

        dateRangeInput(
            "true_date",
            "Período de Análise",
            end       = curr_interval[2],
            start     = curr_interval[1],
            max       = maxdate,
            min       = mindate,
            format    = "MM, yyyy",
            separator = "até",
            language  = "pt-BR",
            startview = "decade",
            weekstart = 0
        )
    })
}
