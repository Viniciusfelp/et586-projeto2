data_config <- box(
    width = 12,
    status = "warning",
    solidHeader = TRUE,
    title = "Configure Dataset",
    selectInput(
        "game_select",
        "Selecione o Jogo",
        c(
            "Counter-Strike: Global Offensive",
            "Dota 2",
            "PLAYERUNKOWN'S BATTLEGROUNDS",
            "Apex Legends",
            "Rust"
        )
    ),
    selectInput(
        "col_select",
        "Selecione o que analisar",
        c(
            "Número médio de jogadores simultâneos",
            "Maior número de jogadores simultâneos",
            "Número de novos jogadores no último mês"
        )
    ),
    actionButton("dt_select", "Submeter")
)

data_info <- box(
    width = 12,
    dataTableOutput("info")
)

data_table <- box(
    width = 12,
    dataTableOutput("charts")
)


header <- dashboardHeader()

sidebar <- dashboardSidebar()

body <- dashboardBody(
    data_config %>% fluidRow(),
    data_info %>% fluidRow(),
    data_table  %>% fluidRow()
)

ui <- dashboardPage(header, sidebar, body)
