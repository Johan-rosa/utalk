
files <- list.files('modules', full.names = 'TRUE')
files <- c(files, list.files('R', full.names = 'TRUE'))

lapply(files, source)
