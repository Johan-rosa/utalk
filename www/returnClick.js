
$(document).keyup(function(event) {
    if ($("#chat-message").is(":focus") && (event.keyCode == 13)) {
        $("#chat-send_message").click();
        
        //let chat_window = document.getElementById('chat-chat_messages')
        //chat_window.scrollTop = chat_window.scrollHeight;
    }
});


