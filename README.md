# Data Harvesting Project
Mario Yanes (@myanesp) and Isabela Zeberio (@isazeberio)

## How to replicate

The first thing you have to do is to obtain an unique API key from [The Movie Database website](https://www.themoviedb.org/).
You have to register for a free account, and in Settings of your profile, apply for the API. You have to fill information about you and they provide the API in a few moments. 

Once you have the API, you can clone this repo and store the API (a 32-character string) inside it, in `.txt` file. This step is important
to do exactly as mentioned as it is required to obtain the data in this work.

Another requirement, besides it is indicated also in the R markdown of the final project, is the installation of the library [`tmdbR`](https://github.com/myanesp/tmdbR).
This library was created for us especifically for this project, so it's part of it (and almost the core). You can check the repository of the package [here](https://github.com/myanesp/tmdbR), and installing by executing, in R, `remotes::install_github("myanesp/tmdbR")`. Nonetheless, the library as today only covers the endpoints used by us on this project, but our intention is to continue developing it to add the missing variables and to adapt it to the API v4 version.  

## Limitations
As reported on the final project, the Selenium part was painful to do. Sometimes it doesn't start, but right after it does, but then stop to recognize commands. Besides that, we want to mantain the code that we would use to extract the ids of the top rated movies filtered by year.

The library `tmdbR` was planned and made for this project, so some functions may experiment bugs if its use goes beyond it. For example, the function `add_detail()` only works if the variable/s that you want are a character or a list, but not if they are a dataframe. We will work on that.

## Credits
This project was made using the API of TMDB, but also information from JustWatch, a streaming information provider of media, which useful information was incorporated through the TMDB API.
