#' Title
#'
#' @param species
#'
#' @return
#' @export
#'
#' @examples
clean_names <- function(species){

  sp1 <- gsub('\\s+', replacement = ' ', x=species)

  sp <- stringr::str_to_sentence(sp1)

  return(sp)
}
