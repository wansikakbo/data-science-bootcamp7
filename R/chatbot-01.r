# Run > "Rscript bot01.r"
# =====================
mbot <- function(){
  while(TRUE){
    questions <- list(
      q1 = c("[1] What's your name?", "Hello, ", ""),
      q2 = c("[2] What's your dog name?", "i love it, ", "doggy"),
      q3 = c("[3] What're you doing?", "", "!?. That's interesting."),
      q4 = c("[4] where're you going?", "", "!?. Me too."),
      q5 = c("[5] Can we go togeter?", "", "!?. Haha, i'm just kidding.")
    )
    print("==========")
    print("Type 'exit' to stop chating")
    print("==========")
    for(q in questions){ 
      print(q[1])  
      input <- readLines("stdin", n=1)
      if(input=='exit')
        break 
      print(paste(q[2], input, q[3])) 
    } 
    if(input=='exit'){
      print("Are you leaving? Ok, goodbye.")
      break
    }
  }

}
mbot()
