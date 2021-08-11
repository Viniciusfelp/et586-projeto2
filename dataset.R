master_df <- read.csv("SteamCharts.csv")

game_names <- unique(master_df$gamename)

filter_name <- function(df, name) {
    df %>% subset(gamename == name) %>% return()
}
