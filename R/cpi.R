#' @title Computes conservation priority scores for more than one habitat.
#'
#' @param data A data frame with all the details of habitats, surface area,
#' species names and threat status should be provided.
#' @param habitat A variable with the different habitat names considered.
#' @param species A variable with all species names in the habitat.
#' @param area A variable habitat area or measure of coverage that can used for conservation selection.
#' @param iucn A variable with the species threat classes or category such as vulnerable.
#' @param plot To visualize the a bar graph of priority score for each habitat.
#'
#' @importFrom sf st_drop_geometry
#' @importFrom graphics barplot par
#' @importFrom methods is
#' @importFrom stats complete.cases
#'
#' @return Data frame with habitat priority scores.
#'
#' @details
#' The priority index is a novel conservation metric which weights the water body or habitat depending
#' on the species richness and rareness among the water bodies considered \strong{(Basooma et al., 2022)}.
#' The weights were assigned as follows: \strong{ET = 7}, \strong{EXw = 6}, \strong{CR = 5},
#' \strong{DD = 5}, \strong{NE = 5}, \strong{EN = 4}, \strong{VU = 3}, \strong{NT = 2},
#' and \strong{LC = 1}.
#' The conservation priority scores are computed in \strong{(Basooma et al., 2022)}
#' The surface area of the water body or habitat considered in the computation .
#'
#' @export
#'
#' @seealso {\code{\link{cpi_one}}, \code{\link{rarity}}, \code{\link{clean_names}}}
#'
#' @examples
#'
#' \dontrun{
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
#' cpihabt <- cpi_all(data=df_final, habitat='habitats', species='species', area='surface_area',
#'  iucn='iucn', plot=NULL)
#'
#'
#' cpihabts_plt <- cpi_all(data=df_final, habitat='habitats', species='species',
#' area='surface_area', iucn='iucn', plot=TRUE)
#'
#'
#'
#' data('gbif')
#' gbif
#'
#' cpihabts <- cpi_all(data=gbif, habitat='waterbody',
#' species='species', area='surfacearea', iucn='iucnstatus', plot=NULL)
#'
#' }
#'
#' @keywords conservation priority index
#'
#' @references Basooma, A., Nakiyende, H., Olokotum, M., Balirwa, J. S., Nkalubo, W.,
#' Musinguzi, L., & Natugonza, V. (2022). A novel index to aid in prioritizing habitats
#' for site‐based conservation. Ecology and Evolution, 12(3), e8762.
#'
#' @author Anthony Basooma (bas4ster@gmail.com)
#'
cpi_all <- function(data, habitat, species, area, iucn, plot=NULL){

  if(missing(data)) stop('Data missing', call. = FALSE)

  if(!exists('data')) stop('Data file not loaded in the directory')

  if(any(names(data)==habitat)==FALSE) stop('Habitat name not in the data frame loaded')

  if(any(names(data)==species)==FALSE) stop('Species name not in the data frame loaded')

  if(any(names(data)==area)==FALSE) stop('Habitat area column name not in the data frame loaded')

  if(any(names(data)==iucn)==FALSE) stop('Habitat name not in the data frame loaded')

  if(is(data,'sf')) data <- st_drop_geometry(data) else data

  #Replace white spaces with NAs and remove NAs

  data[data==""] <- NA

  na_values <- sapply(data, function(x) which(is.na(x)))

  if(any(sapply(na_values, length)>1)){

    data<- data[complete.cases(data[,c(species, area, habitat, iucn)]),]

  }else{
    data
  }

  habc <- unlist(data[,habitat])

  unique_habitat <- unlist(unique(habc))

  cpifinal <-  c()

  habitats <- c()

  for (ii in 1:length(unique_habitat)) {

    habitatnames <- as.character(unique_habitat[ii])

    cpifinal[ii] <- cpi_one(data = data, habitat = habitat, species = species,
                            area = area, iucn = iucn,
                            hname = habitatnames)

    habitats[ii] <- habitatnames
  }
  if(!is.null(plot)){

    df <- data.frame(sites= habitats, cpi= cpifinal)
    plt <- df[order(df$cpi,decreasing = FALSE),]

    par(mar=c(5,7,4,2))

    barplot(plt$cpi,names.arg = plt$sites, las=1, horiz = TRUE,
            cex.names = 0.6, cex.lab= 1,mgp=c(4,1,0.5),
            xlab = "Priority scores", ylab = "Sites", )
  }else{
    df <- data.frame(sites= habitats, cpi= cpifinal)
  }
  return(df)
}



