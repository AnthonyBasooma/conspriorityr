#' @title Cleans species names with redundant white spaces and character case differences
#'
#' @param species Species name to be cleaned
#'
#'
#' @return Cleaned species name
#'
#' @export
#'
#' @seealso {\code{\link{priorityindex}}, \code{\link{clean_names}}}
#'
#' @examples
#'
#' sp <- clean_names(species='Lates Niloticus')
#'
clean_names <- function(species){

  sp1 <- gsub('\\s+', replacement = ' ', x=species)

  str1 <- unlist(strsplit(sp1, " "))[1]

  strother <- paste0(unlist(strsplit(sp1, " "))[-1], collapse = ' ')

  spclean <- paste0(paste0(toupper(strtrim(str1, 1)), substring(str1, 2)),' ',strother)

  if(grepl('[a-zA-Z]', x= spclean)!=TRUE) stop('The species name should have atleast some alphabets not puctuation only')

  return(spclean)
}
