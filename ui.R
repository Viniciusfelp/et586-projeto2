data_config <- box(
    width = 12,
    status = "warning",
    solidHeader = TRUE,
    title = "Configure Dataset",
    selectInput(
        "game_select",
        "Selecione o Jogo",
        game_names
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

sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem("Métricas", tabName = "metricas", icon = icon("dice-one")),
        menuItem("Comparações", tabName = "comp", icon = icon("dice"))
    )
)

body <- dashboardBody(
    tabItems(
        tabItem(tabName = "metricas",
            data_config %>% fluidRow(),
            data_info %>% fluidRow(),
            data_table  %>% fluidRow()
        ),
        tabItem(tabName = "comp",
        )
    )
)

ui <- dashboardPage(header, sidebar, body)
