#' @noRd
getiucn_std <- function(){
  ilist <- list(c('lc', 'least concern'),c('en', 'endangered'),
                   c('dd', 'data deficient'),c('vu','vulnerable'),
                   c('cr', 'critically endangered', 'ce'),
                   c('exw', 'extinct in the world'),c('ex', 'extinct'),
                   c('ne','not evalauted'),c('nt', 'near threatened'))
  return(ilist)
}
