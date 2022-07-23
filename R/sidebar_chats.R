# TODO don not reveal user email in the UI
# Add logic for new messages recieved
sidebar_chats_html <- function(user_photo, user_id, user_name) {
  shiny::div(
    class = 'sidebar_chat',
    onclick = 'sentChatId(this.id)',
    id = user_id,
    shiny::div(
      class='sidebar_chat_avatar',
      shiny::img(src = user_photo)
    ),
    shiny::div(
      class='sidebar_chat_info',
      shiny::h4(user_name)
    )#,
    # shiny::div(
    #   class='new_message',
    #   icon("envelope")
    #   )
  )
}
