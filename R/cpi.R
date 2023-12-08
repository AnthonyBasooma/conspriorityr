#' Conservation
#'
#' @param data A dataframe with all the details, of which the habitat names, surface, species names and threat status should be provided.
#' @param habitat A column with the different habitat names considered.
#' @param species A column with all species names in the habitat.
#' @param area The habitat area or measure of coverage that can used for conservation selection.
#' @param iucn A column with the speciea threat classes or category such as vulnerable.
#' @param plot To visualise the a bar graph of priority score for each habitat.
#'
#' @importFrom sf st_drop_geometry
#' @importFrom graphics barplot
#' @importFrom methods is
#'
#' @return Dataframe with species scores
#' @export
#'
#' @examples
#'
#' victoria <- cpi(data=gbif, habitat='habitat', species='species', area='area', iucn='iucn')
#'
cpi <- function(data, habitat, species, area, iucn, plot=NULL){

  if(is(data,'sf')){
    data <- st_drop_geometry(data)
  }else{
    data
  }
  habc <- data[,habitat]

  hbu <- unique(habc)
  cpifinal <- length(hbu)
  habitats <- length(hbu)

  for (ii in 1:length(hbu)) {
    cpifinal[ii] <- rareend(data = data, habitat = habitat, species = species,
                            area = area, iucn = iucn,
                            hname = hbu[ii])
    habitats[ii] <- hbu[ii]
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





