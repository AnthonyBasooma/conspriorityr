#' Title
#'
#' @param data
#' @param habitat
#' @param species
#' @param area
#' @param iucn
#' @param hname
#'
#' @return
#' @export
#'
#' @examples
rareend <- function(data, habitat, species, area, iucn, hname){

  if(missing(data)) stop('Data is not provided')

  if(!exists('data')) stop('Data file not loaded in the directory')


  if(is(data,'sf')){
    data <- data %>% st_drop_geometry()
  }else{
    data
  }

  habc <- data[,habitat]

  spc <- data[,species]

  iucnc <- data[,iucn]

  areac <- data[,area]

  if(!is(areac, 'numeric')) stop('Only numeric values are accepted for habitat area')

  ssr <- c()
  endsp <- c()

  sphab <- unique(spc[which(habc==hname)])

  area <- unique(areac[which(habc==hname)])

  for (i in sphab) {

    cls <- clean_names(i)

    idx <- which(spc==cls)

    iucndt <- unique(iucnc[idx])

    iucn <- clean_iucn(iucndt)

    if(length(iucn)>1){

      stop('Species must have only conservation status.
           check https://www.iucnredlist.org/ to confirm species threat status')

    }else if(!iucn %in% c('lc','nt','vu','en', 'ce','cr', 'et','ne','dd','exw')){

      stop(toupper(iucn),' assigned species not accepted.
           Change to LC, NT, VU, CR, Exw, EX, NE, DD')

    }else{
      iucnwts = switch(iucn, lc=1, nt=2, vu= 3, en=4, ce=5,
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
