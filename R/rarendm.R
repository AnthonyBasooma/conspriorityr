
#' @title Conservation priority score for a particular habitat
#'
#' @param data Data frame with the habitat details including habitat, species, area and IUCN status for
#' for each species
#' @param habitat A variable for habitat names
#' @param species A variable for species names, whether scientific or local names.
#' @param area A variable with the area of the habitat. Either measured in the field or using already made polygons.
#' @param iucn A variable for species IUCN categories based on IUCN RedList (IUCN 2001).
#' The package is currently tailored to IUCN Red List status assessments.
#' @param hname Particular habitat name to compute the priority scores for.
#'
#' @details
#' For all species were weighted based on the IUCN Red List status.
#' Highest and lowest weights assigned to extinct and least concern conservation categories, respectively.
#' The weights were assigned as follows: \strong{ET = 7}, \strong{EXw = 6}, \strong{CR = 5},
#' \strong{DD = 5}, \strong{NE = 5}, \strong{EN = 4}, \strong{VU = 3}, \strong{NT = 2},
#' and \strong{LC = 1}. The conservation priority scores are computed in \strong{(Basooma et al., 2022)}
#'
#' @seealso {\code{\link{rarity}}, \code{\link{cpi_all}}, \code{\link{clean_names}}}
#'
#' @return Conservation priority score for one habitat form the data.
#' For multiple habitats use \link[conspriorityr]{cpi_all}
#'
#' @export
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
#' victoriacpi <- cpi_one(data= df_final, habitat='habitats', species='species',
#' area='surface_area',iucn='iucn', hname='Victoria')
#'
#' library(sf)
#'
#' data('gbif')
#'
#' gbif
#'
#' victoria <- cpi_one(data=gbif, habitat='waterbody', species='species', area='surfacearea',
#' iucn='iucnstatus', hname='Lake Victoria')
#'}
#'
#'
#' @references
#'
#' \enumerate{
#' \item Basooma, A., Nakiyende, H., Olokotum, M., Balirwa, J. S., Nkalubo, W.,
#' Musinguzi, L., & Natugonza, V. (2022). A novel index to aid in prioritizing habitats
#' for site‐based conservation. Ecology and Evolution, 12(3), e8762.
#' \item Natural Resources. Species Survival Commission, & IUCN Species Survival Commission. (2001).
#' IUCN Red List categories and criteria. IUCN.
#' }
#'
#' @author Anthony Basooma (bas4ster@gmail.com)

cpi_one <- function(data, habitat, species, area, iucn, hname){


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
