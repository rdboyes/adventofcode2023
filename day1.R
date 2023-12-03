library(tidyverse)
library(stringi)

input <- tibble(input = read_lines("data/1.txt")) 

strings = rev(c("one"   = "1",
                "two"   = "2",
                "three" = "3",
                "four"  = "4",
                "five"  = "5",
                "six"   = "6",
                "seven" = "7",
                "eight" = "8",
                "nine"  = "9"))

strings_rev <- strings
names(strings_rev) <- stri_reverse(names(strings))

solve <- function(input, r1 = "[0-9]", r2 = "[0-9]"){
  input |> 
    mutate(first_number = str_extract(input, r1)) |> 
    mutate(last_number = str_extract(stri_reverse(input), r2)) |> 
    mutate(across(first_number:last_number,
                  ~str_replace_all(., c(strings, strings_rev)))) |> 
    mutate(combined = as.integer(paste0(first_number, last_number))) |> 
    summarize(answer = sum(combined)) |> 
    pull()
}
  
input |> solve()
  
input |> solve(paste0("[0-9]|", paste(names(strings), 
                                      collapse = "|")),
               paste0("[0-9]|", paste(stri_reverse(names(strings)), 
                                      collapse = "|")))

