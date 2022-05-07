html_messages <- function(user_name, time, message, user_id, logged_user_id) {
  
  message_class <- ifelse(user_id == logged_user_id, 'chat_message chat_reciever', 'chat_message')
  
  tagList(
    p(
      class= message_class,
      span(class='chat_name', stringr::str_to_title(user_name)),
      message,
      span(class='chat_timestamp', time)
      )
  )
}

# x <- list(
#   'user_id' = 1123,
#   'user_name' = 'johan',
#   'time' = Sys.time(),
#   'message' = 'Hello world'
# )
# 
# append(
#   as.data.frame(x),
#   list(logged_user_name = 'Johan')
# )
