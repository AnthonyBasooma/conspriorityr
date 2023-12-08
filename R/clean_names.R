#' Checks the species names to match databses such as FishBase.
#'
#' @param species Species name to be cleaned
#'
#' @importFrom stringr str_to_sentence
#'
#' @return string
#'
#'
#' @export
#'
#' @examples
#'
#' sp <- clean_names(species='Lates Niloticus')
#'
clean_names <- function(species){

  sp1 <- gsub('\\s+', replacement = ' ', x=species)

  sp <- str_to_sentence(sp1)

  return(sp)
}
