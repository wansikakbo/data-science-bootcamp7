#print(installed.packages())
library(rvest) 
library(tidyverse) 
library(glue)   

options = c("Comedy","Drama","Family","Short","Animation","Romance","Adventure","Fantasy","Music","Action")
  
print("Check IMDB Top rating:") 
print(data.frame(Genres=options))  
input <- readline("Please select genres.. ")

yourchioce <- if(str_detect(input,"\\d+")) options[as.numeric(input)] else input

genres <- if(exists("yourchioce")) tolower(yourchioce) else 'comedy'
url <- glue("https://www.imdb.com/search/title/?genres={genres}&explore=title_type,genres")

elem <- url %>% 
  read_html() %>% 
  html_elements("div.lister-item-content") %>% 
  head(20)

mydf = data.frame()
for(e in elem){  
    nv = e %>% html_elements("p:last-of-type > [name=nv]") %>% html_attr("data-value", "0")   
    row <- data.frame(
      title = e %>% html_elements("h3.lister-item-header") %>% html_text2(), 
      rating = e %>% html_elements("div.ratings-imdb-rating") %>% html_attr("data-value", "0")  %>% ifelse(length(.), ., "0"),
      certificate = e %>% html_elements(".certificate") %>% html_text2() %>% ifelse(length(.), ., "-"), 
      runtime = e %>% html_elements(".runtime") %>% html_text2() %>% ifelse(length(.), ., "-"), 
      genre = e %>% html_elements(".genre") %>% html_text2() %>% ifelse(length(.), ., "-"),
      votes = ifelse(is.na(nv[1]), "0", nv[1]),
      gross = ifelse(is.na(nv[2]), "0", nv[2])
    ) 
    mydf <- mydf %>% bind_rows(row)
}

print(paste("source:",url))
print(paste("Check IMDB Top rating genres:",yourchioce))
View(mydf)
 
