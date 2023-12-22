
# Internal function to check for IUCN categories

#' @title Checks and standardizes species threat status to match the analysis protocol.
#'
#' @param iucn The species International Union for Conservation Redlist. Internal use not exported
#'
#' @return string
#'
#'
clean_iucn <- function(iucn){

  if(missing(iucn)) stop('IUCN names missing')

  tiucn <- tolower(iucn)

  act <- iconv(tiucn, from = 'UTF-8', to = 'ASCII//TRANSLIT')

  act1 <- gsub("[[:punct:]]", "", act)

  spc <- gsub("[^[:alnum:]]", " ", act1)

  spiucn <- trimws(gsub("\\s+"," " ,spc), which = 'both')

  return(spiucn)
}

