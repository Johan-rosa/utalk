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

sidebar_server <- function(id, f, db, users_list) {
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

    output$sidebar_chats <- renderUI({
      req(user_email())
      purrr::pmap(
        users_list[!users_list$user_email == user_email(), c("user_id", "user_name", "user_photo")],
        sidebar_chats_html
        )
      })

  })
}
