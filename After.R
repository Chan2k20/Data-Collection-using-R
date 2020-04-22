# load packages
library('stringr')
library('XML')
library('bitops')
library('RCurl')
library('rvest')


#Allow user to input a year
readYear <- function(){
  n <- readline(prompt = "Enter a year between 2010 and 2020:")
  while(as.integer(n) < 2010 || as.integer(n) > 2020){
    n <- readline(prompt = "Enter a year between 2010 and 2020:")
  }
  return(as.integer(n))
}

#Determine the volume based on the year
volume = (readYear() %% 10)+1
writeColNames = TRUE

while(volume <= 20){
  cat('Working on volume', volume, '\n')
  source('Scrapping.R')
  volume <- volume + 1
  writeColNames = FALSE
}