#' Title
#'
#' @param iucn
#'
#' @return
#' @export
#'
#' @examples
clean_iucn <- function(iucn){

  tiucn <- tolower(iucn)

  act <- iconv(tiucn, from = 'UTF-8', to = 'ASCII//TRANSLIT')

  act1 <- gsub("[[:punct:]]", "", act)

  spc <- gsub("[^[:alnum:]]", " ", act1)

  iucn <- trimws(gsub("\\s+"," " ,spc), which = 'both')

  return(iucn)
}
