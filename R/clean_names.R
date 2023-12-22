#' @title Cleans species names with redundant white spaces and character case differences
#'
#' @param species Species name to be cleaned
#'
#' @importFrom stringr str_to_sentence
#'
#' @return Cleaned species name
#'
#' @export
#'
#' @seealso {\code{\link{cpi_one}}, \code{\link{cpi_all}}, \code{\link{clean_names}}}
#'
#' @examples
#'
#' sp <- clean_names(species='Lates Niloticus')
#'
clean_names <- function(species){

  sp1 <- gsub('\\s+', replacement = ' ', x=species)

  sp <- stringr::str_to_sentence(sp1)

  if(grepl('[a-zA-Z]', x=sp)!=TRUE) stop('The species name should have atleast some alphabets not puctuation only')

  return(sp)
}
