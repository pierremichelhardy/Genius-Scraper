library(rvest)
library(tidyverse)
library(readxl)
library(RSelenium)

music <- read_excel("Rolling Music.xlsx")
y <- 2:5
z <- 3:6

# set up stuff
rD <- rsDriver(browser=c("chrome"), chromever="77.0.3865.40")
driver <- rD$client

# first page to go
driver$navigate("https://genius.com/Babymetal-shanti-shanti-shanti-lyrics")

for(i in 1:nrow(music) {
  tryCatch({
    # driver$navigate("https://genius.com")
    # next song
    x <- music[i,4]
    x <- as.character(x)
    
    # search term 
    element <- driver$findElement(using = "css",".quick_search--header")
    #.quick_search--header
    # .YZEcC
    # .mini_card-info
    element$sendKeysToElement(list(x))

    # pause
    #t <- sample(z, 1)
    #Sys.sleep(t)
    #element$sendKeysToElement(list(key="tab"))
    element$sendKeysToElement(list(key="enter"))
    t <- sample(y, 1)
    Sys.sleep(t)
    
    # click
    element <- driver$findElement(using="css",".mini_card-info")
    element$clickElement()
    
    # pause
    t <- sample(y, 1)
    Sys.sleep(t)
    
    # Scroll
    element <- driver$findElement(using = "css","body")
    element$sendKeysToElement(list(key = "page_down"))
    element$sendKeysToElement(list(key = "page_down"))
    element$sendKeysToElement(list(key = "page_down"))
    
    # Take
    t <- sample(y, 1)
    Sys.sleep(t)
    elements <- driver$findElements(using = "css",".metadata_with_icon-tags-primary_tag")
    #genre <- element$getElementText()[[1]]
    genre <- c()
    for(ele in elements){
      genre <- append(genre,ele$getElementText()[[1]])
    }
    genre <- paste0(genre[1:length(genre)],collapse=",")
    
    # log
    music[i,3] <- genre
    
    print(i)
    
  }, error=function(e){cat("Whoops", conditionMessage(e),"\n")})
}

write.csv(music, file="music w genre 100.csv")


################################################

driver$close()

rD$server$stop()
