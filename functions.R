library(tidyverse)
library(xml2)
library(magrittr)
library(httr2)

get_streaming_providers <- function(id, country, api_key) {
  req <- request("https://api.themoviedb.org/3") %>% 
    req_url_path_append("/movie/") %>%
    req_url_path_append(id) %>% 
    req_url_path_append("/watch/providers") %>% 
    req_url_query(api_key = api_key) 
  
  resp_req <- req %>% 
    req_perform()
  
  resp_body_streaming <-
    resp_req %>%
    resp_body_json(simplifyVector = TRUE) %>%
    as_tibble()
  
  streaming_providers <- resp_body_streaming$results[[country]]$flatrate$provider_name
  if (length(streaming_providers) == 0) {
    streaming_providers <- NA
    return(paste("You can watch the requested movie in", country, "on", c(streaming_providers)))
  } else {
    return(paste("The provided movie is not available on the country you have selected."))
  }
  
}