
#' Computes the species rarity scores based on the number habitats is recorded in.
#'
#' @param data Data frame with all species and habitats names in the area of study.
#' @param habitat A column with the habitat names.
#' @param species A column with species names.
#' @param sp The species names in question. Either scientific or local but must be in the data.
#'
#' @details
#' The rarity computed for each species based on (Basooma et al., 2022). The SSR = 1-(Ws/Wt) where Ws is
#' the number of habitats were the species is found and Wt is the total number habitats considered. Rarity
#' scores ranges from 0 to 1; where 0 means the species is common to all habitats and 1 is endemic to only one
#' habitat among the habitats.
#'
#'
#' @return Rarity or endemic score.
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' library(sf)
#'
#' data('gbif')
#'
#' gbif
#'
#' rarity_lates <- rarity(data= gbif, habitat='waterbody',
#' species='species', sp='Lates niloticus')
#'
#' }
#'
#'
rarity <- function(data, habitat, species, sp){

  if(missing(data)) stop('Data missing', call. = FALSE)

  if(!exists('data')) stop('Data file not loaded in the directory')

  if(any(names(data)==habitat)==FALSE) stop('Habitat name not in the data frame loaded')

  if(any(names(data)==species)==FALSE) stop('Species column not in the data frame loaded')


  if(is(data,'sf'))  data <- st_drop_geometry(data) else data

  data[data ==""] <- NA

  na_values <- sapply(data, function(x) which(is.na(x)))

  if(any(sapply(na_values, length)>1)){

    data<- data[complete.cases(data[,c(species,habitat)]),]

  }else{
    data
  }


  habc <- unlist(data[, habitat])

  spdata <- as.character(unlist(data[,species]))

  idx <- which(spdata==sp)

  habA <- length(unique(habc[idx]))

  tothab <- length(unique(habc))

  ssr <- 1-(habA/tothab)

  return(ssr)
}

#'@author Anthony Basooma (bas4ster@gmail.com)
#'@references Basooma, A., Nakiyende, H., Olokotum, M., Balirwa, J. S.,
#'Nkalubo, W., Musinguzi, L., & Natugonza, V. (2022).
#'A novel index to aid in prioritizing habitats for site‐based conservation.
#'Ecology and Evolution, 12(3), e8762.
