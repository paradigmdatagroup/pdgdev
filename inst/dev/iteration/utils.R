make_my_list <- function() {
  require(stringr)
  require(snakecase)
  words <- sample(snakecase::to_random_case(stringr::words),
              size = 5, replace = FALSE)
  sentences <- sample(snakecase::to_random_case(stringr::sentences), 
              size = 3, replace = FALSE)
  letters <- sample(snakecase::to_random_case(LETTERS),
              size = 10, replace = FALSE)
  list(
    'words' = words,
    'sentences' = sentences,
    'letters' = letters
  )
}

make_mixed_list <- function() {
  list(
    'booleans' = rep(
      x = sample(c(TRUE, FALSE), size = 2, replace = FALSE),
      times = 2
    ),
    'integers' = as.integer(sample(1:10, size = 5, replace = FALSE)),
    'doubles' = round(rnorm(n = 5, mean = 3, sd = 0.2), digits = 3),
    'strings' = sample(x = stringr::words, size = 5, replace = FALSE),
    'dates' = c(lubridate::as_date(lubridate::today() - 10), 
                lubridate::as_date(lubridate::today() - 50),
                lubridate::as_date(lubridate::today() - 100)
      )
  )
}