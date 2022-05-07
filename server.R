
shinyServer(function(input, output) {
  
  users_list <- download_df(db_url, 'users')
  
  f <- FirebaseUI$
    new()$
    set_providers( 
      #email = TRUE, 
      google = TRUE
    )$
    launch() # launch
  
  db <- RealtimeDatabase$
    new()$
    ref("main/messages")$
    on_value("changed")
  
  sidebar_server('sidebar', f, db, users_list)
  chat_server('chat', f, db, users_list)
  
})

