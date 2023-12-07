#' Title
#'
#' @param data
#' @param habitat
#' @param species
#' @param area
#' @param iucn
#' @param plot
#'
#' @return
#' @export
#'
#' @examples
cpi <- function(data, habitat, species, area, iucn, plot=NULL){


  if(is(data,'sf')){
    data <- data %>% st_drop_geometry()
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


#=========000
rarity <- function(data, habitat, species, sp){

  if(is(data,'sf')){
    data <- data %>% st_drop_geometry()
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


plt = function(ht, names){
  cpipol <- cpipol[order(cpipol$ht,decreasing = FALSE),]
  barplot(cpipol$ht,names.arg = cpipol$names, las=2, horiz = TRUE, cex.names = 0.6,
          xlab = "Priority scores", ylab = "Sites")

}
