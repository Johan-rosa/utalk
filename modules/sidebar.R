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
    user_name <- shiny::eventReactive(f$get_signed_in(), {
      f$get_signed_in()[["response"]][["displayName"]]
    })

    user_id <- shiny::eventReactive(f$get_signed_in(), {
      f$get_signed_in()[["response"]][["email"]]
    })

    user_photo <- shiny::eventReactive(f$get_signed_in(), {
      f$get_signed_in()[["response"]][["photoURL"]]
    })

    user_info <- reactive({
      list(
        user_id = user_id(),
        user_name = user_name(),
        user_photo = user_photo()
      )
    })

    observe({
      req(user_id())
      
      if(!user_id() %in% users_list$user_id) {
        upload_row(user_info(), db_url, "users")
      }

    output$user_photo <- shiny::renderUI({
      shiny::img(src = users_list$user_photo[users_list$user_id == user_id()], class="avatar")
      })
    })

    # TODO make it render the chats after login
    output$sidebar_chats <- renderUI({
      req(user_id())
 
      purrr::pmap(
        users_list[!users_list$user_id == user_id(), ],
        sidebar_chats_html
        )
      })
    
  })
}
