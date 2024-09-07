
#' @title Conservation priority score for a particular habitat
#'
#' @param data Data frame with the habitat details including habitat, species, area and IUCN status for
#' for each species
#' @param habitat A variable for habitat names. These can be water bodies, or unit were conservation priorities
#'      can be conducted in comparison to the other. For example, habitats can be lakes or the different habitat
#'      groups such as offshore, inshore or middle sections of the river. For rivers, habitats can be subcatchments of
#'      river segments or individuals river compared. The surface area or any unit used to measure the
#'      extend of the habitat should be particular to it and not generalaised across the habitats.
#' @param species A variable for species names, whether scientific or local names.
#' @param area A variable with the area of the habitat. Either measured in the field or using already made polygons.
#' @param iucn A variable for species IUCN categories based on IUCN RedList (IUCN 2001).
#' The package is currently tailored to IUCN Red List status assessments.
#' @param select Particular habitat name to compute the priority scores for.
#' @param plot To visualize the a bar graph of priority score for each habitat.
#'
#' @details
#' For all species were weighted based on the IUCN Red List status.
#' Highest and lowest weights assigned to extinct and least concern conservation categories, respectively.
#' The weights were assigned as follows: \strong{ET = 7}, \strong{EXw = 6}, \strong{CR = 5},
#' \strong{DD = 5}, \strong{NE = 5}, \strong{EN = 4}, \strong{VU = 3}, \strong{NT = 2},
#' and \strong{LC = 1}. The conservation priority scores are computed in \strong{(Basooma et al., 2022)}
#'
#' @seealso {\code{\link{clean_names}}}
#'
#' @return Conservation priority score for one habitat form the data.
#'
#' @importFrom stats complete.cases
#' @importFrom utils install.packages
#' @importFrom graphics barplot par
#' @importFrom methods is
#' @importFrom sf st_drop_geometry
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
#' area='surface_area',iucn='iucn', select='Victoria')
#'
#' library(sf)
#'
#' data('gbif')
#'
#' gbif
#'
#' victoria <- cpi_one(data=gbif, habitat='waterbody', species='species', area='surfacearea',
#' iucn='iucnstatus', select='Lake Victoria')
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

priorityindex <- function(data, habitat, species, area, iucn,
                          lat = NULL, lon =  NULL,
                          polygon = NULL,
                          select = NULL,
                          plot = FALSE,
                          full = FALSE,
                          map = FALSE){


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

  habitatvec <- as.character(unlist(data[,habitat]))#in case they are factors

  speciesvec <- as.character(unlist(data[,species]))

  iucnvec <- as.character(unlist(data[,iucn]))

  # handle area to whether its numeric and converted if not
  areavec <- unlist(data[,area])

  if(is.numeric(areavec)){
    areavec
  }else{
    #changes to numeric
    conv <- tryCatch(as.numeric(as.character(areavec)), warning = function(e) return(NULL))

    if(is.null(conv)) stop("The area was not succesfully converted and the index calculations are not possible. Check area data if it is numeric.") else conv
  }

  unihabiats <- unique(habitatvec)

  if(!is.null(select)) {

    if(all(select%in%unihabiats) ==TRUE) unihabiats <- select else stop("Selected ", select, " not found in the dataset for habitats.")

    }else{
    unihabiats
  }
  if(length(unique(habitatvec))<=1) stop("The number of habitats considered are less than or equal to 1 and rarity will be meaningless.")

  cpi <- sapply(unihabiats, function(z){

    #check if the habitat has species or wrong habitat name was entered

    #If right habitat name is provided, check if has unique area but also not zero or character


    habitat_area <- unique(areavec[which(habitatvec== z)])

    sphab <- unique(speciesvec[which(habitatvec== z)])

    if(length(habitat_area)>1){

      stop('Each habitat must have only one area measurement but for ',z, ' more than one was provided', call. = FALSE)

    }else if(is.na(habitat_area) || is.null(habitat_area)) {

      stop('Habitat area for ', z, ' is ', NA, ' so calculations cannot continue, check and correct.')

    }else if(habitat_area <=0) {

      stop('Habitat area for ', z, ' is Zero (', area, ') so calculations cannot continue, check and correct.')

    }else{
      habitat_area
    }
    if(length(sphab)<1) stop(z, ' has no species data found in the dataset.')

    #loop through all the species from one habitat

    #compute IUCN weight for each species from a habitat

    iuncwts <- sapply(sphab, function(x) {

      spcleannames <- clean_names(x)

      spindex <- which(speciesvec == spcleannames)

      #get the iucn of the species and clean it

      iucnsp <- unique(iucnvec[spindex])

      iucnval <- clean_iucn(iucnsp)

      if(length(iucnval)>1){

        stop(spcleannames, ' species must have only conservation status but ', length(iucn),' were provided. Check https://www.iucnredlist.org/ to confirm species threat status')

      }else{
        #Accepted IUCN names harmonized to one for each category

        iucnstd <- getiucn_std()

        tf=sapply(iucnstd, `%in%`, x = iucnval)

        if(all(tf == FALSE)){
          stop('The ', toupper(iucnval), ' for ', spcleannames, ' is invalid. Change to LC, NT, VU, CR, Exw, EX, NE, DD')
         }else{

          iucnfinal <- unlist(iucnstd[which(tf==TRUE)])[1]

        }
        wtsassigned = switch(iucnfinal, lc = 1, nt = 2, vu= 3, en=4, ce = 5, cr = 5, exw= 6, et = 7, ne = 5, dd = 5)
      }
    })

    #compute rarity

    rare <- sapply(sphab, function(y) {

      spindex <- which(speciesvec==y)

      #habitat were the species is found
      habitatspp <- length(unique(habitatvec[spindex]))

      #total habitat found
      habitattotal <- length(unique(habitatvec))

      ssr <- 1-(habitatspp/habitattotal)
      #print(ssr)

    })

    nominator <- sum(unlist(unlist(iuncwts)*unlist(rare)))

    denomnitor <- habitat_area * length(unique(iucnvec))

    prindex <- nominator/denomnitor

  })

  dataout <- as.data.frame(cpi)

  dataout[habitat] <- rownames(dataout)

  rownames(dataout) <- NULL

  dataout <- dataout[, c(2,1)]

  if(isTRUE(plot)){

    ggpkg <- tryCatch(find.package("ggplot2"), error = function(e) return(NULL))

    if(!is.null(ggpkg)){

      habitats <- NULL

      cpi <- NULL

      ggp <- ggplot2::ggplot(data = dataout, ggplot2::aes(x = dataout[,habitat], y = cpi))+
        ggplot2::geom_bar(stat = 'identity')+
        ggplot2::theme_bw()+
        ggplot2::theme(panel.grid.major = ggplot2::element_blank(),
                       panel.grid.minor = ggplot2::element_blank())+
        {if(length(unique(unihabiats))>7)ggplot2::coord_flip()}+
        ggplot2::scale_y_continuous(expand = ggplot2::expansion(mult = c(0, 0.02)))+
        ggplot2::labs(x = "Habitats", y = "Priorty scores")
      print(ggp)
    }else{
      message("ggplot2 is not installed and base plot will be used or install ggplot2 and run again.")

      plt <- dataout[order(dataout$cpi,decreasing = FALSE),]

      par(mar=c(5,7,4,2))

      pbl <- barplot(plt[,cpi],names.arg = plt[,habitat], las=1, horiz = TRUE,
                     cex.names = 0.6, cex.lab= 1, mgp=c(4,1,0.5),
                     xlab = "Priority scores", ylab = "Habitats", )
      print(pbl)
    }
  }

  #plot the map for priority index
  if(isTRUE(map)){

    if(is(data, 'sf')){

      coord_final_sf <- data

    }else{
      if(!is.null(lat) & !is.null(lon)){

        dfinal <- merge(data, dataout, by = habitat)

        coord_clean <- dfinal[complete.cases(dfinal[ , c(lat, lon)]), ]

        #Convert to sf data format

        coord_final_sf <- st_as_sf(coord_clean, coords = c(lon,lat), crs=st_crs(4326))


      }else{
        stop("if the data is not an sf file provide both the lon and lat colums for mapping.")
      }
    }

    #ploting the graph #check if ggplot2 is installed

    ggpkg2 <- tryCatch(find.package("ggplot2"), error = function(e) return(NULL))

    if(!is.null(ggpkg2)){

      #add with polgon of the habitats

      polycoord <- st_join(coord_final_sf, polygon)

      cpi <- NULL

      ggp2 <- ggplot2::ggplot()+

        ggplot2::geom_sf(data= polycoord, ggplot2::aes(fill=cpi))+

        ggplot2::scale_fill_viridis_c(direction = 1)+

        ggplot2::geom_sf_text(data = polycoord, ggplot2::aes(label = waterbody), size=2)+

        ggplot2::labs(x='Longitude', y='Latitude', fill='Priority scores')

      print(ggp2)
    }else{
    stop('To plot the map of the priority area, you must install ggplot2.')
    }
  }

  if(isTRUE(full)){

    dfinal <- merge(data, dataout, by = habitat)

  }else{
    dfinal <- dataout
  }
  return(dfinal)
}

