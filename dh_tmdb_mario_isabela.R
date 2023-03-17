## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## ----message=FALSE------------------------------------------------------------
library(httr2)
library(tidyverse)
library(purrr)
library(jsonlite)
library(xml2)
library(magrittr)
library(plotly)
library(lattice)


## -----------------------------------------------------------------------------
if (!require("remotes")) install.packages("remotes")
remotes::install_github("myanesp/tmdbR")
# And then load into your current session
library(tmdbR)


## -----------------------------------------------------------------------------
set_api_tmdb("/Users/isabelazeberio/Library/CloudStorage/OneDrive-UniversidadCarlosIIIdeMadrid/master/Data harvesting/token.txt")


## -----------------------------------------------------------------------------
top_rated_movies <- get_top_rated_movies()


## -----------------------------------------------------------------------------
top_rated_tv <- get_top_rated_tv()


## -----------------------------------------------------------------------------
# Get the top rated movies
top_movies <- get_streaming(top_rated_movies, "movie")
glimpse(top_movies)


## -----------------------------------------------------------------------------
prism <- c("#5F4690","#1D6996","#38A6A5","#0F8554","#73AF48","#EDAD08","#E17C05","#CC503E","#94346E",
                     "#6F4070","#994E95","#666666")



## -----------------------------------------------------------------------------
# Grouped barplot
ggplot(top_movies, aes(x = reorder(title, popularity), y = popularity, alpha = 0.7)) + 
  geom_bar(position="dodge", stat="identity", fill="#5F4690") +
  labs(x = "Movie Titles", y = "Popularity") +
  coord_flip() + 
  guides(alpha = FALSE) +
  theme_minimal()



## -----------------------------------------------------------------------------
# Get the top rated tv shows
top_rated_tv <- get_streaming(top_rated_tv, type = "tv")
glimpse(top_rated_tv)



## -----------------------------------------------------------------------------
ggplot(top_rated_tv, aes(x = reorder(title, popularity), y = popularity, alpha = 0.7)) + 
  geom_bar(position="dodge", stat="identity", fill="#1D6996" ) +
  labs(x = "Series Titles", y = "Popularity") +
  coord_flip() + 
  guides(alpha = FALSE) +
  theme_minimal()



## -----------------------------------------------------------------------------
top_rated_tv <- top_rated_tv[-which.max(top_rated_tv$popularity), ]

ggplot(top_rated_tv, aes(x = reorder(title, popularity), y = popularity, alpha = 0.7)) + 
  geom_bar(position="dodge", stat="identity", fill="#38A6A5" ) +
  labs(x = "Series Titles", y = "Popularity") +
  coord_flip() + 
  guides(alpha = FALSE) +
  theme_minimal()




## -----------------------------------------------------------------------------
# Get the trending media of the day
day <- get_trending_day()

# Get the trending media of the week
week <- get_trending_week()



## -----------------------------------------------------------------------------
# Remove the the mos popular for visualization purposes 
day <- day[-which.max(day$popularity), ]

tr_day <- ggplot(day, aes(x = reorder(title, popularity), 
                y = popularity, alpha = 0.7, fill= media_type,
                text = paste("Overview: ", overview))) + 
  geom_bar(position="dodge", stat="identity" ) +
  labs(x = "Media Contet", y = "Popularity") +
  coord_flip() + 
  guides(alpha = FALSE) +
  scale_fill_manual(values = c("#0F8554", "#EDAD08")) +
  guides(fill = guide_legend(title = "Media Type",
                             override.aes = list(alpha = 0.7))) +
  labs(title = "Trending Content of the Day") +
  theme_minimal()

ggplotly(tr_day, tooltip = c("y", "text", "fill")) %>%
  layout(title = "Trending Content of the Day",
         xaxis = list(title = "Popularity", automargin = TRUE),
         yaxis = list(title = "Media Content", automargin = TRUE),
         legend = list(title = "Media Type"))



## -----------------------------------------------------------------------------
# Remove the the mos popular for visualization purposes 
week <- week[-which.max(week$popularity), ]

tr_week <- ggplot(week, aes(x = reorder(title, popularity), 
                            y = popularity, alpha = 0.7, fill= media_type,
                            text = paste("Overview: ", overview))) + 
  geom_bar(position="dodge", stat="identity" ) +
  labs(x = "Media Content", y = "Popularity", fill = "Media Type") +
  coord_flip() + 
  scale_fill_manual(values = c("#CC503E", "#6F4070")) +
  guides(fill = guide_legend(title = "Media Type", override.aes = list(alpha = 0.7), fill = T)) +
  labs(title = "Trending Content of the Day") +
  theme_minimal()

ggplotly(tr_week, tooltip = c("y", "text", "fill")) %>%
  layout(title = "Trending Content of the Week",
         xaxis = list(title = "Popularity", automargin = TRUE),
         yaxis = list(title = "Media Content", automargin = TRUE),
         legend = list(title = "Media Type"))



## -----------------------------------------------------------------------------
get_movie_genres()
get_tv_genres()


## -----------------------------------------------------------------------------
movies_genres <- top_rated_movies %>%
  transform_genres()

series_genres <- top_rated_tv %>% 
  transform_genres()


## -----------------------------------------------------------------------------
unique(movies_genres$genres)
unique(series_genres$genres)



## -----------------------------------------------------------------------------
# Initialize empty columns for each genre
for (i in 1:4) {
  col_name <- paste0("genre", i)
  movies_genres[[col_name]] <- NA
}

# Loop over the rows of the data frame and split the "genres" column
for (i in 1:nrow(movies_genres)) {
  genres <- unlist(strsplit(as.character(movies_genres[i, "genres"]), ", "))
  num_genres <- length(genres)
  for (j in 1:num_genres) {
    col_name <- paste0("genre", j)
    movies_genres[i, col_name] <- genres[j]
  }
}


# Print the result
movies_genres 


## -----------------------------------------------------------------------------
m_genre <- ggplot(movies_genres, aes(x = reorder(title, popularity), 
                          y = popularity, fill = genre1, alpha = 0.7,
                          text = paste("Subgenres: ", genres))) +
  geom_bar(position="dodge", stat="identity") +
  labs(x = "Popularity", y = "Title", color = "Genre1") +
  scale_fill_manual(values = prism) +
  coord_flip() + 
  guides(alpha = FALSE) +
  theme_minimal()


ggplotly(m_genre, tooltip = c("y", "text")) %>%
  layout(title = "Most Popular Movies by Genre",
         xaxis = list(title = "Popularity", automargin = TRUE),
         yaxis = list(title = "Movies Title", automargin = TRUE),
         legend = list(title = "Genres"))




## -----------------------------------------------------------------------------
# initialize empty columns for each genre
for (i in 1:4) {
  col_name <- paste0("genre", i)
  series_genres[[col_name]] <- NA
}

# loop over the rows of the data frame and split the "genres" column
for (i in 1:nrow(series_genres)) {
  genres <- unlist(strsplit(as.character(series_genres[i, "genres"]), ", "))
  num_genres <- length(genres)
  for (j in 1:num_genres) {
    col_name <- paste0("genre", j)
    series_genres[i, col_name] <- genres[j]
  }
}

# print the result
series_genres



## -----------------------------------------------------------------------------
s_genre <- ggplot(series_genres, aes(x = reorder(title, popularity), 
                          y = popularity, fill = genre1, alpha = 0.7,
                          text = paste("Subgenres: ", genres))) +
  geom_bar(position="dodge", stat="identity") +
  labs(x = "Popularity", y = "Title", color = "Genre1") +
  scale_fill_manual(values = prism) +
  coord_flip() + 
  theme_minimal()


ggplotly(s_genre, tooltip = c("y", "text")) %>%
  layout(title = "Most Popular Series by Genre",
         xaxis = list(title = "Popularity", automargin = TRUE),
         yaxis = list(title = "Series Titles", automargin = TRUE),
         legend = list(title = "Genres"))




## -----------------------------------------------------------------------------
week %>% 
  transform_genres()

day %>% 
  transform_genres()



## -----------------------------------------------------------------------------
day %>% get_streaming_df()

day %>% transform_genres()


## -----------------------------------------------------------------------------
get_streaming_providers(804150, "movie", "US")
get_streaming_providers(238, "movie", "US")
get_streaming_providers(238, "movie", "ES")
get_streaming_providers(13, "movie", "AR")



## -----------------------------------------------------------------------------
get_details(238, "movie", "budget")
top_rated_movies %>% add_detail(c("revenue", "budget"))



## -----------------------------------------------------------------------------
movie_profits <- movies_genres %>% add_detail(c("revenue", "budget"))
movie_profits <-  movie_profits %>% mutate(profits = 
                                             ifelse(budget == 0 | revenue == 0, NA, revenue - budget))

# Subset the data to remove rows with missing profits
movies_subset <- movie_profits[!is.na(movie_profits$profits), ]


budget_profits <- ggplot(movies_subset, aes(x = budget, y = profits, 
                            size = revenue, color = genre1)) +
    geom_point(alpha = 0.7) +
    scale_size_continuous(range = c(2, 20), name = "Revenue") +
    scale_color_manual(values=prism) +
    labs(x = "Budget", y = "Profit", title = "Profit vs Budget Bubble Chart") +
    theme_minimal() +
    scale_x_continuous(labels = scales::comma) +
    scale_y_continuous(labels = scales::comma)



ggplotly(budget_profits, tooltip = c("y", "text", "x", "color", "size")) %>%
  layout(title = "Profit vs Budget Bubble Chart",
         xaxis = list(title = "Budget", automargin = TRUE),
         yaxis = list(title = "Profits", automargin = TRUE),
         legend = list(title = "Genres"))



  
  s_genre <- ggplot(series_genres, aes(x = reorder(title, popularity), 
                          y = popularity, fill = genre1, alpha = 0.7,
                          text = paste("Subgenres: ", genres))) +
  geom_bar(position="dodge", stat="identity") +
  labs(x = "Popularity", y = "Title", color = "Genre1") +
  scale_fill_manual(values = prism) +
  coord_flip() + 
  theme_minimal()


## -----------------------------------------------------------------------------
average_rating_by_genre <- movies_genres %>%
  group_by(genres, genre1) %>%
  summarize(average_vote_count = mean(vote_count, na.rm = TRUE))

# Print the results
average_rating_by_genre

ggplot(average_rating_by_genre, aes(x = reorder(genres, average_vote_count),
                                    y = average_vote_count, fill = average_vote_count)) +
  geom_col() +
  scale_fill_gradient(low = "#EDAD08", high = "#94346E", guide = "colorbar", 
                        na.value = "white", name = "Average Vote Count",
                        limits = c(0, max(average_rating_by_genre$average_vote_count, na.rm = TRUE))) +
  labs(title = "Average Movie Rating by Genre", x = "Genres", y = "Average Vote Count") +
  coord_flip() +
  theme_minimal()


## -----------------------------------------------------------------------------
serie_status <- top_rated_tv %>% add_detail("status")
serie_status


## -----------------------------------------------------------------------------
ggplot(serie_status, aes(x = status, y = popularity, fill = status)) + 
  geom_boxplot(alpha = 0.7) +
  scale_fill_manual(values = prism) +
  labs(title = "Series Status and Popularity",
       x = "Status", y = "Popularity") +
  theme_bw()


## -----------------------------------------------------------------------------
search_tmdb("castle")
search_tmdb("pitt")
search_tmdb("encanto")



## ----eval=FALSE, include=FALSE------------------------------------------------
## library(RSelenium)


## ----eval=FALSE, include=FALSE------------------------------------------------
## top_rated_movies <- "https://www.themoviedb.org/movie/top-rated"
## top_rated_series <- "https://www.themoviedb.org/tv/top-rated"
## 
## 
## remDr <- remoteDriver(browser = "firefox", port = 4445L)
## 
## remDr$open()
## 
## 
## remDr$navigate("https://www.themoviedb.org/tv/top-rated")
## 
## #remDr$sendKeysToElement(list(key = "down_arrow"))
## 
## remDr$findElement(using = "xpath", value = "//section//h2[contains('Filtros')]")$clickElement()
## 
## remDr$findElement(using = "xpath", value = '//*[@id="release_date_gte"]')$sendKeysToElement(list("01-01-2022"))
## start
## 
## remDr$findElement(using = "xpath", value = '//*[@id="release_date_lte"]')$sendKeysToElement(list("31-12-2022"))
## end
## 
## remDr$findElement(using = "xpath", value = "//section//p[contains(@a, 'load_more')]")$clickElement()
## close
## 
## page_source <- remDr$getPageSource()[[1]]
## 
## remDr$close()
## 
## top_rated_year <-
##   page_source %>%
##   read_html()


## ----eval=FALSE, include=FALSE------------------------------------------------
## 
## 
## top_rated_year <- function(year, type) {
## 
##   start <- paste("01-01", year, sep = "-")
##   end <- paste("31-12", year, sep = "-")
## 
##   if (type == "movie") {
##     endpoint <- "https://www.themoviedb.org/movie/top-rated"
##   } else if (type == "tv") {
##     endpoint <- "https://www.themoviedb.org/tv/top-rated"
##   } else {
##     stop("You have not provided a valid media type. It should be 'tv' or 'movie'")
##   }
## 
##   # Selenium part
## 
##   top_rated_year <-
##     page_source %>%
##     read_html()
## 
##   for (i in 1:20){
##     xpath_expr <- paste0("/html/body/div[1]/main/section/div/div/div/div[2]/div[2]/div/section/div/div/div[", i, "]/div[2]/h2/a/@href")
##     Sys.sleep(1)
##     top_rated_year <-
##       xml_find_all(xpath_expr) %>%
##       xml_text()
##     top_id <- gsub("/movie/", "", top_rated_year)
##     ids_movies[[i]] <- top_id
##   }
## 
##   for (i in 1:20){
##     xpath_expr <- paste0("/html/body/div[1]/main/section/div/div/div/div[2]/div[2]/div/section/div/div/div[", i, "]/div[2]/h2/a/@href")
##     Sys.sleep(1)
##     link <- top_rated_series %>%
##       read_html() %>%
##       xml_find_all(xpath_expr) %>%
##       xml_text()
##     link_num <- gsub("/tv/", "", link)
##     ids_tv[[i]] <- link_num
##     }
## }
## 

