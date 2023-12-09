#' Computes conservation priority scores for more than one habitat based on Basooma et al., 2022
#'
#' @param data A data frame with all the details of habitats, surface area,
#' species names and threat status should be provided.
#' @param habitat A column with the different habitat names considered.
#' @param species A column with all species names in the habitat.
#' @param area The habitat area or measure of coverage that can used for conservation selection.
#' @param iucn A column with the speciea threat classes or category such as vulnerable.
#' @param plot To visualize the a bar graph of priority score for each habitat.
#'
#' @importFrom sf st_drop_geometry
#' @importFrom graphics barplot par
#' @importFrom methods is
#' @importFrom stats complete.cases
#'
#' @return Dataframe with habitat priority scores.
#'
#' @details
#' The priority index is a novel conservation metric which weights the waterbody or habitat depending
#' on the species richness and rareness among the water bodies considered.
#' In addition, the species International Union Conservation for Nature status
#' is weighted where a critically endangered is weighted 5, endangered = 4,
#' vulnerable = 3, near threatened = 2, least concern = 1. Based on the assumption
#' by IUCN that both data deficient and not evaluated should considered threatened
#' until their status is established, all their weights was 5.
#' The surface area of the water body or habitat considered in the computation.
#'
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' data('gbif')
#'
#' gbif
#'
#' kyoga <- cpi(data=gbif, habitat='waterbody',
#' species='species', area='surfacearea', iucn='iucnstatus', plot=NULL)
#'
#' }
#'
#'
cpi <- function(data, habitat, species, area, iucn, plot=NULL){

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

    cpifinal[ii] <- rareend(data = data, habitat = habitat, species = species,
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

#' @keywords conservation priority index
#'
#' @references Basooma et al. 2022. Using the novel priority index in prioritising
#' the selection of inland water bodies for site-based fish conservation.
#' Ecology and Evolution Volume12, Issue3 March 2022 e8762
#' https://doi.org/10.1002/ece3.8762


