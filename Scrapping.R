library(rvest)
library(xml2)
library(XML)
library(stringr)

#Allow user to input a year
readYear <- function(){
  n <- readline(prompt = "Enter a year between 2010 and 2020:")
  while(as.integer(n) < 2010 || as.integer(n) > 2020){
    n <- readline(prompt = "Enter a year between 2010 and 2020:")
  }
  return(as.integer(n))
}
volume = (readYear() %% 10)+1

base_url <- "https://mobilednajournal.biomedcentral.com"
vol_url = paste("/articles?tab=keyword&searchType=journalSearch&sort=PubDate&volume=", volume, sep="")
vol_url = paste(vol_url, "&page=1", sep="")
conURL = paste(base_url, vol_url, sep="")

#Determine number of pages
initSearchPage = readLines(conURL)
noOfPage = str_extract_all(initSearchPage[grep("<p class=\"u-text-sm u-reset-margin\">", initSearchPage)][1],"\\d+")[[1]]
maxPageCount = noOfPage[2]

#Find the links of every article in each page and store it in a vector called "articleURLS"
articleURLs <- c()
for (i in 1:maxPageCount){                        
  pageURL <- paste(base_url,'/articles?tab=keyword&searchType=journalSearch&sort=PubDate&volume=',volume, "&page=", i,sep = "")
  html <- paste(readLines(pageURL), collapse = "\n")
  matched <- str_match_all(html, "<a itemprop=\"url\" data-test=\"title-link\" href=\"(.*?)\"")
  for(x in 1:(length(matched[[1]])/2)){
    articleURLs <- c(articleURLs, paste(base_url, matched[[1]][x, 2], sep=""))
  }
}

# Extracting Information from articleurls

title <- c()
author <- c()
pubDate <- c()
abstract <- c()
keywords <- c()
fulltext <- c()
affiliations<-c()
coauth <- c()

for(x in 1:length(articleURLs))
{
  currentpage <- articleURLs[x] 	#1 was used to test the first article
  webpage <- readLines(currentpage)
  htmlpage <- htmlParse(webpage, asText=TRUE)
  test1 <- xpathSApply(htmlpage, "//*[@id=\"main-content\"]/main/article/div/h1", xmlValue)
  title <- c(title, paste(test1, collapse = ", "))
  test2 <- xpathSApply(htmlpage, "//*[@id=\"article-info-content\"]/div/div/ul[2]/li", xmlValue)
  keywords <- c(keywords, paste(test2, collapse = ", "))
  test3 <- xpathSApply(htmlpage, "//*[@id=\"main-content\"]/main/article/div/ul/li/span/a", xmlValue)
  author <- c(author, paste(test3, collapse = ", "))
  test4 <- xpathSApply(htmlpage, "//*[@id=\"main-content\"]/main/article/div/ul/li[3]/a/time", xmlValue)
  pubDate <- c(pubDate, paste(test4, collapse = ", "))
  test5 <- xpathSApply(htmlpage, "//*[@id=\"Abs1-content\"]/p", xmlValue)
  abstract <- c(abstract, paste(test5, collapse = ", "))
  test6 <- xpathSApply(htmlpage, "//*[@id=\"author-information-content\"]/ol", xmlValue)
  affiliations <- c(affiliations, paste(test6, collapse = ", "))
  # test7 <- xpathSApply(htmlpage, "//*[@id=\"main-content\"]/main/article", xmlValue)
  # fulltext <- c(fulltext, paste(test7, collapse = ", "))
  text <- unlist(xpathApply(htmlpage, '//p | ///h1 | ///h2 | ///h3 | //*[@class="c-author-list js-list-authors js-etal-collapsed"]', xmlValue))
  text <- gsub('\\n', '', text)
  text <- paste(text, collapse = ': ')
  text <- str_remove(text, "Advertisement:")
  fulltext <- c(fulltext, text) 
  htmlwebpage <- read_html(articleURLs[x])
  coauth <- c(coauth, html_text(html_nodes(htmlwebpage, 'a#corresp-c1')))
  }

for(i in 1:length(title))
{
  DF <- data.frame(title[i], author[i], coauth[i], pubDate[i], abstract[i], keywords[i], fulltext[i])
  names <- c('Title', 'Authors', 'Corresponding Author', 'Publication Date', 'Abstract', 'Keywords', 'Full Text')
  if(i == 1){
    write.table(DF, file="summary.txt", sep="\t", col.names = names ,row.names = F)
  }else{
    write.table(DF, file="summary.txt", sep="\t", row.names = FALSE, col.names = FALSE, append = TRUE)
  }
}
library(writexl)
DF <- data.frame(title, author, coauth, pubDate, abstract,keywords)
#DF1<-data.frame(fulltext)
write_xlsx(DF,"summary.xlsx")
