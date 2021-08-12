master_df <- read.csv("SteamCharts.csv")

game_names <- unique(master_df$gamename)

get_date <- function(year, month) {
    paste(month, "15th,", year) %>% mdy() %>% return()
}

master_df$date <- get_date(year = master_df$year, month = master_df$month)

filter_name <- function(df, name) {
    df[df$gamename == name,] %>% return()
}

filter_date <- function(df, interval) {
    df[
        interval[1] <= df$date &
        interval[2] >= df$date,
    ] %>%
    return()
}

filter_data <- function(df, name = NULL, interval = NULL) {
    dt <- master_df

    if (!is.null(name))
        dt <- dt[dt$gamename == name,]

    if (!is.null(interval))
        dt <- dt[interval[1] <= dt$date & dt$date <= interval[2],]

    return(dt)
}
