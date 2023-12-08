
#' Computes the species endemicity weights based on the number habitats is recorded in.
#'
#' @param data Data frame with all species and habitats names in the area of study.
#' @param habitat A column with the habitat names.
#' @param species A column with species names.
#' @param sp The species names in question. Either scientific or local but must be in the data.
#'
#' @return value, rarity or endemic score.
#'
#' @export
#'
#' @examples
#'
#' rarity_lates <- rarity(data= gbif, habitat='habitat', species='species', sp='Lates niloticus')
#'
rarity <- function(data, habitat, species, sp){

  if(is(data,'sf')){
    data <- st_drop_geometry(data)
  }else{
    data = data
  }

  habc <- data[, habitat]

  #cls <- clean_names(spp)

  spdata <- data[,species]

  idx <- which(spdata==sp)

  habA <- length(unique(habc[idx]))

  tothab <- length(unique(habc))

  ssr <- 1-(habA/tothab)

  return(ssr)
}
