sidebar_ui <- function(id) {
 ns = shiny::NS(id)

 tagList(
   div(
     class="sidebar",
     div(class="sidebar_header",
         uiOutput(ns("user_photo"))
         ),
     div(class="sidebar_search",
         div(
           class="sidebar_search_container",
           icon(class = "magnifying-glass", name = "search"),
           textInput(ns("chat_search"), placeholder = "Search or start a new chat", label = "")
           )
         ),
     div(class="sidebar_body",
         uiOutput(ns("sidebar_chats"))
      )
    )
 )
}

sidebar_server <- function(id, f, db, users_list, sbt = NULL) {
  moduleServer(id, function(input, output, session) {
    # Register user information
    user_name <- shiny::reactive({
      f$get_signed_in()[["response"]][["displayName"]]
    })

    user_email <- shiny::reactive({
      f$get_signed_in()[["response"]][["email"]]
    })

    user_photo <- shiny::reactive({
      f$get_signed_in()[["response"]][["photoURL"]]
    })

    user_info <- reactive({
      list(
        user_email = user_email(),
        user_name = user_name(),
        user_photo = user_photo()
      )
    })

    observe({
      req(user_email())
      if(!user_email() %in% users_list$user_email) {
        upload_row(
          append(user_info(), list(user_id = make_user_id(user_email))), 
          db_url, "users")
      }

    output$user_photo <- shiny::renderUI({
      shiny::img(src = users_list$user_photo[users_list$user_email == user_email()], class="avatar")
      })
    })
    
    user_list_r <- eventReactive(input$update_sidebar, {
      req(user_email())

      userkey <- stringr::str_remove_all(user_email(), "[\\W\\s]")
      save_down_df <- purrr::possibly(
        download_df, data.frame(sender = character(), last_check = lubridate::ymd_hms()))
      
      checks <- save_down_df(
            db_url,
            paste("notifications", userkey, 'check', sep = "/")
          ) 
      
      received <- save_down_df(
            db_url,
            paste("notifications", userkey, 'received', sep = "/")
          )
      
      if(nrow(checks) > 0 & nrow(received) > 0) {
        checks <- checks |>
          dplyr::group_by(sender) |>
          dplyr::summarise(last_check = max(time))
        
        received <- received |>
          dplyr::group_by(sender) |>
          dplyr::summarise(last_message_time = max(time))
        
        notification_summary <- dplyr::left_join(checks, received, by = "sender") |>
          dplyr::mutate(
            notification = (last_check < last_message_time |
              (is.na(last_check) & !is.na(last_message_time)))
          )
        
        print(user_email())
        print(notification_summary)
        
        sidebar <- users_list[!users_list$user_email == user_email(), ] |>
          dplyr::left_join(notification_summary, by = c("user_email" = "sender")) |>
          dplyr::select(user_id, user_name, user_photo, notification) |>
          dplyr::mutate(notification = ifelse(is.na(notification), FALSE, notification))
        
        return(sidebar)
      }
      
      users_list[!users_list$user_email == user_email(), ] |>
        dplyr::select(user_id, user_name, user_photo) |>
        dplyr::mutate(notification = FALSE)
    })

    output$sidebar_chats <- renderUI({
      req(user_email(), user_list_r())
      purrr::pmap(
        user_list_r(),
        sidebar_chats_html
        )
      }) |>
      bindCache(user_email(), user_list_r())

  })
}
