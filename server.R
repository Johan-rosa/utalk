
shinyServer(function(input, output, session) {
  users_list <- download_df(db_url, "users")

  f <- FirebaseUI$
    new()$
    set_providers( 
      google = TRUE
    )$
    launch()

  db <- RealtimeDatabase$
    new()$
    ref("main/messages")$
    on_value("changed")
  
  observeEvent(f$get_signed_in(),{
    sidebar_server("sidebar", f, db, users_list)
    chat_server("chat", f, db, users_list)
  })

})
