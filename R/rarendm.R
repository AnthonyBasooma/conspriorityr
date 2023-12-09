#' Endemicty and rarity priorty score for a selected habitat
#'
#' @param data The dataframe with the habitat details including habitat, species, area and IUCN status for
#' for each species
#' @param habitat Column for habitat names
#' @param species Column for species names, whether scientific or local names.
#' @param area Column with the area of the habitat. Either measured in the field or using already made polygons.
#' @param iucn Species IUCN categories based on IUCN Redlist. The package is currently tailored to
#' IUCN Red List status assessments.
#' @param hname Particular habitat name to compute the priority scores for.
#'
#' @details
#' For all species were weighted based on the IUCN Red List status.
#' Highest and lowest weights assigned to extinct and least concern conservation categories, respectively.
#' The weights were assigned as follows: ET = 7, EXw = 6, CR = 5, DD = 5,
#' NE = 5, EN = 4, VU = 3, NT = 2, and LC = 1.
#' The conservation priority scores are computed in Basooma et al., 2022
#'
#'
#' @return priority score for one habitat form the data. For multiple habitats use \link[conspriorityr]{cpi}
#' @export
#'
#' @examples
#'
#'\dontrun{
#' library(sf)
#'
#' data('gbif')
#'
#' gbif
#'
#' victoria <- cpi(data=gbif, habitat='waterbody',
#' species='species', area='surfacearea', iucn='iucnstatus', hname='Lake Victoria')
#'}
#'

rareend <- function(data, habitat, species, area, iucn, hname){


  if(missing(data)) stop('Data missing')

  if(!exists('data')) stop('Data file not loaded in the directory')

  if(any(names(data)==habitat)==FALSE) stop('Habitat name not in the data frame loaded')

  if(any(names(data)==species)==FALSE) stop('Species name not in the data frame loaded')

  if(any(names(data)==area)==FALSE) stop('Habitat area column name not in the data frame loaded')

  if(any(names(data)==iucn)==FALSE) stop('Habitat name not in the data frame loaded')

  if(is(data,'sf')) data <- st_drop_geometry(data) else data

  #Replace white null spaces with NAs and replace NAs

  data[data==""] <- NA

  na_values <- sapply(data, function(x) which(is.na(x)))

  if(any(sapply(na_values, length)>1)){

    data<- data[complete.cases(data[,c(species, area, habitat, iucn)]),]

  }else{
    data
  }

  habc <- unlist(data[,habitat])

  spc <- unlist(data[,species])

  iucnc <- unlist(data[,iucn])

  areac <- unlist(data[,area])

  #check if the habitat has species or wrong habitat name was entered

  sphab <- unique(spc[which(habc==hname)])

  if(length(sphab)<1) stop(hname, ' has no species data found in the dataset ')

  #If right habitat name is provided, check if has unique area but also not zero or character

  if(!is(areac, 'numeric')) stop('Only numeric values are accepted for habitat area')

  area <- unique(areac[which(habc==hname)])

  if(length(area)>1){

    stop('Each habitat must have only one area measurement but for ',hname, ' more than one was provided', call. = FALSE)

  }else if(is.na(area)) {

    stop('Habitat area for ', hname, ' is ', NA, ' so calculations cannot continue, check and correct.')

  }else if(area==0) {

    stop('Habitat area for ', hname, ' is Zero (', area, ') so calculations cannot continue, check and correct.')

  }else{
    area
  }

  ssr <- c()
  endsp <- c()

  for (i in sphab) {

    cls <- clean_names(i)

    idx <- which(spc==cls)

    iucndt <- unique(iucnc[idx])

    iucn <- clean_iucn(iucndt)

    if(length(iucn)>1){

      stop(cls, ' species must have only conservation status but ', length(iucn),' were provided.
           Check https://www.iucnredlist.org/ to confirm species threat status')

    }else{
      #Accepted IUCN names harmonized to one for each category

      iucnlist <- list(c('lc', 'least concern'),
                       c('en', 'endangered'),
                       c('dd', 'data deficient'),
                       c('vu','vulnerable'),
                       c('cr', 'critically endangered', 'ce'),
                       c('exw', 'extinct in the world'),
                       c('ex', 'extinct'),
                       c('not evalauted', 'ne'),
                       c('nt', 'near threatened'))

      tf=sapply(iucnlist, `%in%`, x = iucn)

      if(all(tf==FALSE)){
        stop('The ', toupper(iucn), ' for ', cls, ' is invalid. Change to LC, NT, VU, CR, Exw, EX, NE, DD')
      }else{
        iucndx <- which(tf==TRUE)
        if(iucndx==1){
          iucnf='lc'
        }else if(iucndx==2){
          iucnf='en'
        }else if(iucndx==3){
          iucnf='dd'
        }else if(iucndx==4){
          iucnf='vu'
        }else if(iucndx==5){
          iucnf='cr'
        }else if(iucndx==6){
          iucnf='exw'
        }else if(iucndx==7){
          iucnf='ex'
        }else if(iucndx==8){
          iucnf='ne'
        }else if(iucndx==9){
          iucnf='nt'
        }else{
          stop('No IUCN status detected')
        }

      }
      iucnwts = switch(iucnf, lc=1, nt=2, vu= 3, en=4, ce=5,
                       cr=5, exw= 6, et = 7, ne= 5, dd = 5)
    }
    endsp[i] <- iucnwts

    habA <- length(unique(habc[idx]))

    tothab <- length(unique(habc))


    ssr[i] <- 1-(habA/tothab)

  }

  endrare <- (sum(endsp) * sum(ssr))/(length(unique(iucnc))*area)

  return(endrare)
}
#'
#'@author Anthony Basooma (bas4ster@gmail.com)
#'
#'@references Basooma, A., Nakiyende, H., Olokotum, M., Balirwa, J. S.,
#'Nkalubo, W., Musinguzi, L., & Natugonza, V. (2022).
#'A novel index to aid in prioritizing habitats for site‐based conservation.
#'Ecology and Evolution, 12(3), e8762.
