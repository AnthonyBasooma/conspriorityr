

#' @title Endemicity or rarity scores for a particular species.
#'
#' @param data Data frame with all species and habitats names in the area of study.
#' @param habitat A variable with the habitat names.
#' @param species A variable with species names.
#' @param sp The species names in question. Either scientific or local but must be in the data.
#'
#' @details
#' The rarity computed for each species based on \strong{(Basooma et al., 2022)}.
#' The \emph{SSR = 1-(Ws/Wt)} where Ws is the number of habitats were the species
#' is found and Wt is the total number habitats considered. Rarity scores ranges
#' from \strong{0 to 1}; where \strong{0} means the species is common to all habitats and 1 is
#' endemic to only one habitat among the habitats \strong{(Basooma et al., 2022)}.
#'
#' @return Species rarity scores.
#'
#' @export
#'
#' @seealso {\code{\link{cpi_one}}, \code{\link{cpi_all}}, \code{\link{clean_names}}}
#'
#'
#' @keywords species rarity or endemicity
#'
#' @references Basooma, A., Nakiyende, H., Olokotum, M., Balirwa, J. S., Nkalubo, W.,
#' Musinguzi, L., & Natugonza, V. (2022). A novel index to aid in prioritizing habitats
#' for site‐based conservation. Ecology and Evolution, 12(3), e8762.
#'
#' @author Anthony Basooma (bas4ster@gmail.com)
#'
#' @examples
#'
#' \dontrun{
#'
#' #species record id
#' id <- seq(1, 30, 1)
#' #lakes to be prioritized for conservation
#' habitats <- rep(c('Kyoga','Victoria','Albert'), 10)
#' #surface area for each lake
#' surface_area <- rep(c(1821.6, 33700, 2850), 10) #Uganda surface area in Uganda
#'
#' #species recorded in each lake
#' species <- c(rep('Haplochromine latifasciatus', 2),
#'             rep('Lates macropthalmous', 1),
#'             rep('Haplochromis phytophagus',1),
#'             rep('L. niloticus',21),
#'             rep('Clarias gariepinus', 5))
#' #final dataframe
#' df_final <- data.frame(id, habitats, surface_area, species)
#' #Assign each species the IUCN categories based on IUCN RedList
#' df_final$iucn <- ifelse(species=='Clarias gariepinus', 'LC',
#'                         ifelse(species=='L. niloticus', 'LC',
#'                               ifelse(species=='Haplochromis phytophagus', 'DD',
#'                                     ifelse(species=='Lates macropthalmous','EN',
#'                                            ifelse(species=='Haplochromine latifasciatus',
#'                                            'CR', NA)))))
#'
#' cgariepinus <- rarity(data= df_final, habitat='habitats', species='species',
#' sp='Clarias gariepinus')
#'
#' cgariepinus
#'
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

#' @author Anthony Basooma \email{bas4ster@@gmail.com}
#'
#' @references Basooma, A., Nakiyende, H., Olokotum, M., Balirwa, J. S., Nkalubo, W., Musinguzi, L.,
#' & Natugonza, V. (2022). A novel index to aid in prioritizing habitats for site‐based conservation.
#' Ecology and Evolution, 12(3), e8762.
#'

