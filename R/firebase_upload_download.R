#' Upload row to Firebase
#' 
#' With this function you can storage observations into firebase
#' real time database. Just provide the data, the project url and where to
#' store it. If the storage directory already exist, it will add another observation
#'
#' @param x a list with the data to save
#' @param projectURL string with the firebase project url
#' @param fileName directory in firebase
#'
#' @export
#'
#' @examples
#' x <- list(
#'   user_id = 'your_email@email.com',
#'   user_name = 'Your Name',
#'   user_photo = 'User phtoto url'
#' )
#' upload_row(x, projectURL = Sys.getenv('db_url'), fileName = "users")
#' 
upload_row <- function(x, projectURL, fileName) {
    fireData::upload(
      x = x, 
      projectURL = projectURL, 
      directory = paste0("main/", fileName)
    )
}

#' Download data from firebase
#' 
#' Download a data.frame from firebase providing the project url and
#' the directory the data is stored
#'
#' @param projectURL string with the firebase project url
#' @param fileName existing directory in your firebase realtime data base 
#'
#' @return a tibble
#' @export
#'
#' @examples
#' download_df(projectURL = Sys.getenv('db_url'), fileName = "users")
download_df <- function(projectURL, fileName) {
  data.table::rbindlist(
    fireData::download(
      projectURL = projectURL,
      fileName = paste0("main/", fileName)
    )
  )
}

#' Create id for chats
#' 
#' Given two users emails, this functions creates a chat id useful for task like
#' storing chat data.
#'
#' @param user1 user 1 email
#' @param user2 user 2 email
#'
#' @return a string
#' @export
#'
#' @examples make_chatid("user1", "user2")
make_chatid <- function(user1, user2) {
  sort(c(user1, user2)) |>
    paste(collapse = '-') |>
    stringr::str_remove_all('[-\\._@]') %>%
    paste0('chats/', .)
}

make_user_id <- function(user_id){
  prefix <- user_id |> 
    stringr::str_extract("^.+@") |> 
    stringr::str_remove_all("[^\\w]")
  
  prefix_token <- stringr::str_split(prefix, '') |> unlist()
  code_content <-  c(seq_along(prefix_token), prefix_token)
  sample(code_content, length(code_content), replace = FALSE) |>
    paste(collapse = "")
}

send_notification <- function(user, selected_chat, projectURL) {
  userkey <- stringr::str_remove_all(selected_chat, "[@\\.]")
  endpoint <- paste("notifications", userkey, sep = "/")
  notification_info <- list(
    sender = user,
    time = Sys.time()
  )
  upload_row(notification_info, projectURL = projectURL, fileName = endpoint)
}

remove_notification <- function(user, selected_chat, projectURL) {
  userkey <- stringr::str_remove_all(selected_chat, "[@\\.]")
  endpoint <- paste("remove_notifications", userkey, sep = "/")
  notification_info <- list(
    sender = user,
    time = Sys.time()
  )
  upload_row(notification_info, projectURL = projectURL, fileName = endpoint)
}