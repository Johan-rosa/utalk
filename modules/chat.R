chat_variable <- reactiveValues(sent = NULL)

chat_ui <- function(id) {
 ns <- shiny::NS(id)
 tagList(
   shinyjs::useShinyjs(),
   div(
     tags$head(includeScript("www/returnClick.js")),
     class = "chat", 
     # Chat header
     div(
       class = "chat_header",
       uiOutput(ns("chat_avatar")),
       div(
         class = "chat_header_info",
         uiOutput(ns("chat_name")),
         p(paste0("Last seen ", Sys.Date())) #TODO logic to register and display user last seen
         ),
       div(
         class = "chat_header_icons",
         icon(class = "magnifying-glass", name = "search"),
         icon(class = "paperclip", name = "paperclip"),
         icon(class = "ellipsis-vertical", name = "ellipsis-v")
         )
       ),

     # Chat Body
     div(
       class = "chat_body",
       id = "chat_body",
       uiOutput(ns("chat_messages")),
       ),
     div(
       class="chat_footer",
       icon(name = "grin-alt", class = "face-grin-wide"),
       textInput(inputId = ns("message"), label = "", placeholder = "Type a message"),
       actionButton(ns("send_message"), label = "", icon = icon(name = "send"))
     )
     )
 )
}


chat_server <- function(id, f, db, users_list) {
  moduleServer(id, function(input, output, session) {
  
    # Setting chat information
    selected_chat <- reactive({
      ifelse(
        is.null(input$selected_chat), 
        users_list$user_email[users_list$user_email != user_email()][1],
        users_list$user_email[users_list$user_id == input$selected_chat]
        )
      })

    chat_id <- reactive({
      make_chatid(selected_chat(), user_email())
    })
    
    output$chat_avatar <- renderUI({
      tags$img(
        class="avatar",
        src = users_list$user_photo[users_list$user_email == selected_chat()]
        )
    })

    output$chat_name <- renderUI({
      h3(users_list$user_name[users_list$user_email == selected_chat()])
    })

    # Register user information
    user_name <- shiny::eventReactive(f$get_signed_in(), {
      f$get_signed_in()[["response"]][["displayName"]]
    })

    user_email <- shiny::eventReactive(f$get_signed_in(), {
      f$get_signed_in()[["response"]][["email"]]
    })

    # Messages logic
    last_message <- shiny::reactive({
      list(
        "user_email" = user_email(),
        "user_name" = user_name(),
        "time" = Sys.time(),
        "message" = input$message
      )
    })

    get_chat <- reactive({
      list(
        signed_in = f$get_signed_in(),
        send_message = input$send_message
      )
    })

    observe({
      chat_variable$sent <<- input$send_message
    })
    
    observeEvent(selected_chat(), {
      print(glue::glue("{user_email()} selected: {selected_chat()}"))
      register_chat_check(user_email(), selected_chat(), db_url)
    }, ignoreInit = TRUE, ignoreNULL = TRUE)

    observeEvent(chat_variable$sent, {
      shinyjs::runjs(glue::glue("Shiny.setInputValue('sidebar-update_sidebar', {chat_variable$sent})"))
      output$chat_messages <- renderUI({
        purrr::pmap(
          download_df(db_url, chat_id()) %>%
            dplyr::mutate(logged_user_email = user_email()),
          html_messages
          )
      })
      
      shinyjs::runjs("scrollToBottom()")
      
    }, ignoreNULL = FALSE)
    
    observeEvent(input$send_message, {

      if(input$message != "") {
        upload_row(last_message(), db_url, chat_id())
      }
      
      print(glue::glue("{user_email()} sent messge to: {selected_chat()}"))
      send_notification(user_email(), selected_chat(), db_url)

      updateTextInput(session, "message", value = "")
    }, ignoreNULL = FALSE)

  })
}