upload_row <- function(x, projectURL, fileName) {
    fireData::upload(x = x, projectURL = projectURL, directory = paste0("main/", fileName))
}

download_df <- function(projectURL, fileName) {
  data.table::rbindlist(
    fireData::download(projectURL = projectURL, fileName = paste0("main/", fileName))
  )
}

make_chatid <- function(user1, user2) {
  sort(c(user1, user2)) |>
    paste(collapse = '-') |>
    stringr::str_remove_all('[-\\._@]') %>%
    paste0('chats/', .)
}


# x <- list(
#   user_id = 'johan.rosaperez@gmail.com',
#   user_name = 'Johan Rosa',
#   user_photo = 'https://lh3.googleusercontent.com/a-/AOh14Gj6yJ8GuN3CVXGz6EDXKM62_u2bnpMi9Xsr_iRzcWc=s96-c'
# )

# destination <- 'users'

# x <- list(
#   user_id = 'johan.rosaperez@gmail.com',
#   user_name = 'Johan Rosa',
#   time = Sys.time(),
#   message = 'Testing message'
# )
# 
# destination <- 'chats/johan.rosaperez@gmail.com-johan@appsilon.com'
# 
# make_chatid <- function(user1, user2) {
#   sort(c(user1, user2)) |>
#     paste(collapse = '-') |>
#     stringr::str_remove_all('[-\\._@]')
# }
# 
# make_chatid('johan.rosaperez@gmail.com', 'johan.rosaperez@gmail.com')
# 
# upload_row(x, projectURL = Sys.getenv('db_url'), fileName = destination)
# 
# download_df(projectURL = Sys.getenv('db_url'), fileName = destination)
