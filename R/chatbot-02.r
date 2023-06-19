# Run > "Rscript bot02.r"
# =====================
mbot <- function(){
  while(TRUE){
    options <- c("[1] Hammer", "[2] Scissor", "[3] Paper")
    print("==========")
    print("==========")
    print("What's your chioce?")
    print(options)
    
    input <- readLines("stdin", n=1)
    if(input=='exit')
      break
 
    if(input < "1" | input > "3")   
      next 
    
    yourchioce = as.numeric(input) 
    botchoice <- sample(1:3, 1) # random 1 from 1-3

    print(paste("Your choice, ", options[yourchioce]))
    print(paste("Bot choice, ", options[botchoice])) 
    print("")  
    fight = yourchioce-botchoice
    if(fight == 0)
      print("**** Draw!! ****")
    else if(fight == 1 | fight == -2)
      print("**** You Lost!! ****")
    else if(fight == 2 | fight == -1)
      print("**** You Win!! ****")
    else
      print("**** Try again!! ****")
      
    print("")
    print("Type 'exit' to quit the game")
    
  }

}
mbot()
