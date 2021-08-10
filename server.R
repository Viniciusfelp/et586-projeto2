get_date <- function(year, month) {
    paste(month, "15th,", year) %>% mdy() %>% return()
}

server <- function(input, output) {
    dt_options <- list(
        pageLength = 10,
        language = list(
            url = "//cdn.datatables.net/plug-ins/1.10.11/i18n/Portuguese-Brasil.json"
        )
    )

    dt_data <- eventReactive(input$dt_select, {
        dt <- master_df %>% subset(gamename == input$game_select)

        if (input$true_date %>% is.null()) {
            return(dt)

        } else {

            interval <- input$true_date

            dt %>%
            subset(get_date(year, month) >= interval[1]) %>%
            subset(get_date(year, month) <= interval[2]) %>%
            return()
        }
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

        return(info %>% t() %>% as.data.frame())
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
        dt <- master_df %>% subset(gamename == input$game_select)

        minyear <- min(dt$year)
        maxyear <- max(dt$year)

        maxdate <- paste(maxyear, "12", "15", sep = "-")
        mindate <- paste(minyear, "01", "15", sep = "-")

        enddate   <- maxdate
        startdate <- mindate

        if (!input$true_date %>% is.null()) {
            if (!input$true_date[1] %>% is.na())
                startdate <- input$true_date[1]

            if (!input$true_date[2] %>% is.na())
                enddate   <- input$true_date[2]
        }

        dateRangeInput(
            "true_date",
            "Período de Análise",
            end       = enddate,
            max       = maxdate,
            start     = startdate,
            min       = mindate,
            format    = "MM-yyyy",
            separator = " - ",
            language  = "pt-BR"
        )
    })
}
