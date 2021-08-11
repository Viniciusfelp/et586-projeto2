master_df <- read.csv("SteamCharts.csv")

game_names <- unique(master_df$gamename)

get_date <- function(year, month) {
    paste(month, "15th,", year) %>% mdy() %>% return()
}


filter_name <- function(df, name) {
    df %>% subset(gamename == name) %>% return()
}

filter_date <- function(df, interval) {
    df %>%
    subset(get_date(year, month) >= interval[1]) %>%
    subset(get_date(year, month) <= interval[2]) %>%
    return()
}
