
library(shiny)
library(firebase)
library(magrittr)
library(lubridate)

source("setup.R")

shinyUI(
    tagList(
      tags$head(
      tags$link(rel="stylesheet", href="app_body.css"),
      tags$link(rel="stylesheet", href="chat.css"),
      tags$link(rel="stylesheet", href="sidebar.css"),
      tags$script(src = "sidebarchat_handler.js"),
    ),
    shinyjs::useShinyjs(),
    useFirebase(),
    firebaseUIContainer(),
    reqSignin(
      div(class="app",
          div(
            class="app_body",
            sidebar_ui("sidebar"),
            chat_ui("chat")
            )
          )
      )
    )
  )
