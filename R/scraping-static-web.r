library(rvest) 
library(tidyverse) 
library(glue)   

chkurl <- "https://www.suksapanpanit.com/หนังสือ-แบบพิมพ์/แบบพิมพ์?page=1&sort=p.price&order=DESC"

lastlink <- chkurl %>% 
  read_html() %>% 
  html_elements("ul.pagination > li:last-of-type > a") %>% 
  html_attr("href", "") 

lastpage <- str_match(lastlink, "page=([0-9]+)")
lastpage_no <- as.numeric(lastpage[1,2])

mydf = data.frame()
no = 0
for(page in 1:lastpage_no){
  url <- glue("https://www.suksapanpanit.com/หนังสือ-แบบพิมพ์/แบบพิมพ์?page={page}&sort=p.price&order=DESC")

  elem <- url %>% 
    read_html() %>% 
    html_elements("div.product-equa") 
    
    for(e in elem){  
        no <- no + 1
        name <- e %>% html_elements(".name > a") 
        price <- e %>% html_elements(".price") %>% html_text2() %>% str_match(., "([,0-9]+)\\.?([0-9]*)")
        link <- name %>% html_attr("href", "#")   
        row <- data.frame(
          no = no,
          product_id = str_match(link, "product_id=([0-9]+)")[1,2],
          title = name %>% html_text2(),
          price = price[1,1],
          image = e %>% html_elements("img") %>% html_attr("src", "#"),
          link = link
        ) 
        mydf <- mydf %>% bind_rows(row)
    } 
} 

print(paste("source:",chkurl))
print("รายการสินค้าแบบพิมพ์ขององค์การค้าของ สกสค.")
View(mydf)
 
 
 
