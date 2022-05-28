
$(document).keyup(function(event) {
    if ($("#chat-message").is(":focus") && (event.keyCode == 13)) {
        $("#chat-send_message").click();
    }
});

function scrollToBottom(){
  var elem = document.getElementById('chat_body');
  elem.scrollTop = elem.scrollHeight;
}


