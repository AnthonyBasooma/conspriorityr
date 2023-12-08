#' Checks and standardizes species threat status .
#'
#' @param iucn The species International Union for C.
#'
#' @return string
#'
#' @export
#'
#' @examples
#'
#' sp <- clean_iucn(iucn='cr')
#'
clean_iucn <- function(iucn){

  tiucn <- tolower(iucn)

  act <- iconv(tiucn, from = 'UTF-8', to = 'ASCII//TRANSLIT')

  act1 <- gsub("[[:punct:]]", "", act)

  spc <- gsub("[^[:alnum:]]", " ", act1)

  spiucn <- trimws(gsub("\\s+"," " ,spc), which = 'both')

  return(spiucn)
}

