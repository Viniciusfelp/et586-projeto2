################################### MÉTRICAS ###################################

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
    uiOutput("timedate"),
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


################################# COMPARAÇÕES ##################################

data_config_comp <- box(
    width = 12,
    status = "warning",
    solidHeader = TRUE,
    title = "Configure Dataset",
    selectizeInput(
        "game_select_comp",
        "Selecione os Jogos",
        game_names,
        options = list(
            maxItems = 2,
            placeholder = "Selecione 2 jogos",
            onInitialize = I("function() { this.setValue(''); }")
        )
    ),
    selectInput(
        "col_select_comp",
        "Selecione o que analisar",
        c(
            "Número médio de jogadores simultâneos",
            "Maior número de jogadores simultâneos",
            "Número de novos jogadores no último mês"
        )
    ),
    uiOutput("timedate_comp"),
    actionButton("dt_select_comp", "Submeter")
)

line_graph <- box(
    title = "Gráfico de Linha",
    width = 12,
    solidHeader = TRUE,
    plotOutput("line_graph")
)

bar_graphs <- box(
    title = "Gráfico de Barras",
    width = 12,
    solidHeader = TRUE,
    plotOutput("bar_graph_1"),
    plotOutput("bar_graph_2")
)

scatter_plot <- box(
    title = "Scatterplot",
    width = 12,
    solidHeader = TRUE,
    plotOutput("scatterplot")
)


################################# GERAL ########################################

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
            data_info   %>% fluidRow(),
            data_table  %>% fluidRow()
        ),
        tabItem(tabName = "comp",
            data_config_comp %>% fluidRow(),
            line_graph       %>% fluidRow(),
            bar_graphs       %>% fluidRow(),
            scatter_plot     %>% fluidRow()
        )
    )
)

ui <- dashboardPage(header, sidebar, body)
