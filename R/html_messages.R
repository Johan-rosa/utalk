html_messages <- function(user_name, time, message, user_email, logged_user_email) {

  message_class <- ifelse(user_email == logged_user_email, 'chat_message chat_reciever', 'chat_message')

  tagList(
    p(
      class= message_class,
      span(class='chat_name', stringr::str_to_title(user_name)),
      message,
      span(class='chat_timestamp', time)
      )
  )
}