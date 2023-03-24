## ----setup, include=FALSE------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## ----message=FALSE-------------------------------------------------------------------------------------------------
library(httr2)
library(tidyverse)
library(purrr)
library(jsonlite)
library(xml2)
library(magrittr)
library(plotly)
library(lattice)


## ------------------------------------------------------------------------------------------------------------------
if (!require("remotes")) install.packages("remotes")
remotes::install_github("myanesp/tmdbR")
# And then load into your current session
library(tmdbR)


## ------------------------------------------------------------------------------------------------------------------
set_api_tmdb("../../token.txt")


## ------------------------------------------------------------------------------------------------------------------
top_rated_movies <- get_top_rated_movies()


## ------------------------------------------------------------------------------------------------------------------
top_rated_tv <- get_top_rated_tv()


## ------------------------------------------------------------------------------------------------------------------
# Get the top rated movies
top_movies <- get_streaming(top_rated_movies, "movie")
glimpse(top_movies)


## ------------------------------------------------------------------------------------------------------------------
prism <- c("#5F4690","#1D6996","#38A6A5","#0F8554","#73AF48","#EDAD08","#E17C05","#CC503E","#94346E",
                     "#6F4070","#994E95","#666666")




## ------------------------------------------------------------------------------------------------------------------
# Get the top rated tv shows
top_rated_tv <- get_streaming(top_rated_tv, type = "tv")
glimpse(top_rated_tv)


## ------------------------------------------------------------------------------------------------------------------
top_rated_tv <- top_rated_tv[-which.max(top_rated_tv$popularity), ]


## ------------------------------------------------------------------------------------------------------------------
# Get the trending media of the day
day <- get_trending_day()


## ------------------------------------------------------------------------------------------------------------------
movies_genres <- top_rated_movies %>%
  transform_genres()

series_genres <- top_rated_tv %>% 
  transform_genres()


## ------------------------------------------------------------------------------------------------------------------
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


## ------------------------------------------------------------------------------------------------------------------
m_genre <- ggplot(movies_genres, aes(x = reorder(title, popularity), 
                          y = popularity, fill = genre1, alpha = 0.7,
                          text = paste("Subgenres: ", genres))) +
  geom_bar(position="dodge", stat="identity") +
  labs(x = "Popularity", y = "Title", color = "Genre1") +
  scale_fill_manual(values = prism) +
  coord_flip() + 
  guides(alpha = FALSE) +
  theme_minimal()


movies <- ggplotly(m_genre, tooltip = c("y", "text")) %>%
  layout(title = "Most Popular Movies by Genre",
         xaxis = list(title = "Popularity", automargin = TRUE),
         yaxis = list(title = "Movies Title", automargin = TRUE),
         legend = list(title = "Genres"))




## ------------------------------------------------------------------------------------------------------------------
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



## ------------------------------------------------------------------------------------------------------------------
s_genre <- ggplot(series_genres, aes(x = reorder(title, popularity), 
                          y = popularity, fill = genre1, alpha = 0.7,
                          text = paste("Subgenres: ", genres))) +
  geom_bar(position="dodge", stat="identity") +
  labs(x = "Popularity", y = "Title", color = "Genre1") +
  scale_fill_manual(values = prism) +
  coord_flip() + 
  theme_minimal()


series <- ggplotly(s_genre, tooltip = c("y", "text")) %>%
  layout(title = "Most Popular Series by Genre",
         xaxis = list(title = "Popularity", automargin = TRUE),
         yaxis = list(title = "Series Titles", automargin = TRUE),
         legend = list(title = "Genres"))


## ------------------------------------------------------------------------------------------------------------------
get_streaming_providers(804150, "movie", "US")
get_streaming_providers(238, "movie", "US")
get_streaming_providers(238, "movie", "ES")
get_streaming_providers(13, "movie", "AR")



## ------------------------------------------------------------------------------------------------------------------
get_details(238, "movie", "budget")
top_rated_movies %>% add_detail(c("revenue", "budget"))



## ------------------------------------------------------------------------------------------------------------------
movie_profits <- movies_genres %>% add_detail(c("revenue", "budget"))
movie_profits <-  movie_profits %>% mutate(profits = 
                                             ifelse(budget == 0 | revenue == 0, NA, revenue - budget))

# Subset the data to remove rows with missing profits
movies_subset <- movie_profits[!is.na(movie_profits$profits), ]


budget_profits <- ggplot(movies_subset, aes(x = budget, y = profits, 
                            size = revenue, color = genre1,
                            text = paste("Title: ", title))) +
    geom_point(alpha = 0.7) +
    scale_size_continuous(range = c(2, 20), name = "Revenue") +
    scale_color_manual(values=prism) +
    labs(x = "Budget", y = "Profit", title = "Profit vs Budget Bubble Chart") +
    theme_minimal() +
    scale_x_continuous(labels = scales::comma) +
    scale_y_continuous(labels = scales::comma)



bubble_chart <- ggplotly(budget_profits, tooltip = c("y", "text", "x", "color", "size")) %>%
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



## ------------------------------------------------------------------------------------------------------------------
search_tmdb("castle")
search_tmdb("pitt")
search_tmdb("encanto")




## ------------------------------------------------------------------------------------------------------------------
#options(knitr.duplicate.label = 'allow')
#purl("dh_tmdb_mario_isabela.Rmd")

