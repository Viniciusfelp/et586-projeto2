server <- function(input, output) {
    std_date_interval <- function() {
        dateRangeInput(
            "true_date_comp",
            "Período de Análise",
            end       = Sys.Date(),
            start     = "2012-01-01",
            max       = Sys.Date(),
            min       =  "2012-01-01",
            format    = "MM, yyyy",
            separator = "até",
            language  = "pt-BR",
            startview = "decade",
            weekstart = 0
        )
    }

    dt_options <- list(
        pageLength = 10,
        language = list(
            url = "//cdn.datatables.net/plug-ins/1.10.11/i18n/Portuguese-Brasil.json"
        )
    )

    dt_column <- eventReactive(input$dt_select, {
        dt <- filter_data(
            master_df,
            name     = input$game_select,
            interval = input$true_date
        )

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

    get_interval <- function(mindate, maxdate, interval_option) {
        if (is.null(interval_option))
            return(c(mindate, maxdate))

        interval <- interval_option

        if (interval_option[1] %>% is.na())
            interval[1] <- mindate

        if (interval_option[2] %>% is.na())
            interval[2] <- maxdate

        return(interval)
    }

    comp_line_graph <- eventReactive(input$dt_select_comp, {
        name1 <- input$game_select_comp[1]
        name2 <- input$game_select_comp[2]

        df <- master_df[
            master_df$gamename == name1 |
            master_df$gamename == name2,
        ] %>%
        filter_date(input$true_date_comp)

        aux <- df$avg %>% na.omit() %>% as.numeric()
        aux1 <- min(aux)
        aux2 <- max(aux)

        df %>%
        ggplot(aes(date, avg, group = 1)) +
        geom_path(aes(colour = gamename), data = filter_name(df, name1)) +
        geom_path(aes(colour = gamename), data = filter_name(df, name2)) +
        ylab("Número médio de jogadores") +
        coord_cartesian(ylim = c(aux1, aux2)) +
        theme_bw() +
        scale_x_date(date_labels = "%b, %Y")
    })

    comp_bar_graph <- eventReactive(input$dt_select_comp, {
        name1 <- input$game_select_comp[1]
        name2 <- input$game_select_comp[2]

        df <- master_df[
            master_df$gamename == name1 |
            master_df$gamename == name2,
        ] %>%
        filter_date(input$true_date_comp)

        df %>%
        ggplot(aes(x = date, y = avg, group = 1)) +
        geom_bar(
            aes(fill = gamename),
            stat = "identity",
            data = filter_name(df, name1)
        ) +
        geom_bar(
            aes(fill = gamename),
            stat = "identity",
            data = filter_name(df, name2)
        ) +
        ylab("Número médio de jogadores") +
        xlab("") +
        theme_bw() +
        scale_x_date(date_labels = "%b, %Y")
    })

    output$charts <- renderDataTable(
        master_df %>%
        filter_data(name = input$game_select, interval = input$true_date) %>%
        as.data.frame(),
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

        curr_interval <- get_interval(mindate, maxdate, input$true_date)

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

    output$timedate_comp <-  renderUI({
        if (length(input$game_select_comp) < 2)
            return(std_date_interval())

        dt1 <- master_df %>% filter_name(input$game_select_comp[1])
        dt2 <- master_df %>% filter_name(input$game_select_comp[2])

        minyear <- c(dt1$year %>% max(), dt2$year %>% max()) %>% min()
        maxyear <- c(dt1$year %>% min(), dt2$year %>% min()) %>% max()

        maxdate <- minyear %>% paste("12", "31", sep = "-")
        mindate <- maxyear %>% paste("01", "01", sep = "-")

        curr_interval <- get_interval(mindate, maxdate, input$true_date_comp)

        dateRangeInput(
            "true_date_comp",
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

    output$line_graph <- renderPlot(comp_line_graph())

    output$bar_graph <- renderPlot(comp_bar_graph())
}
