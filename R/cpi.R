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
#' @importFrom graphics barplot
#' @importFrom methods is
#'
#' @return Dataframe with species scores
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
#' victoria <- cpi(data=gbif, habitat='lakes',
#' species='species', area='area', iucn='iucn')
#'
#' }
#'
#'
cpi <- function(data, habitat, species, area, iucn, plot=NULL){

  if(is(data,'sf')){
    data <- st_drop_geometry(data)
  }else{
    data
  }
  habc <- data[,habitat]

  uniqe_habitat <- unique(habc)
  cpifinal <- length(uniqe_habitat)
  habitats <- length(uniqe_habitat)

  for (ii in 1:length(uniqe_habitat)) {
    cpifinal[ii] <- rareend(data = data, habitat = habitat, species = species,
                            area = area, iucn = iucn,
                            hname = uniqe_habitat[ii])
    habitats[ii] <- uniqe_habitat[ii]
  }
  if(!is.null(plot)){
    df <- data.frame(sites= habitats, cpi= cpifinal)
    plt <- df[order(df$cpi,decreasing = FALSE),]

    barplot(plt$cpi,names.arg = plt$sites, las=2, horiz = TRUE,
            cex.names = 0.6,
            xlab = "Priority scores", ylab = "Sites")
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


