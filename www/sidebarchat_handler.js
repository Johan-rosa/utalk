function sentChatId(element_id){
  $(`#${element_id} .new_message`).hide()
  Shiny.setInputValue('chat-selected_chat', element_id)
}
