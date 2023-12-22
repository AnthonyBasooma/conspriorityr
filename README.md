
<!-- README.md is generated from README.Rmd. Please edit that file -->

## Package: conspriorityr

<!-- badges: start -->

[![R-CMD-check](https://github.com/AnthonyBasooma/conspriorityr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/AnthonyBasooma/conspriorityr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

## Introduction

Funding biodiversity conservation strategies are usually minimal, thus
prioritizing habitats at high risk should be conducted. We developed and
tested a conservation priority index (CPI) that ranks habitats to aid in
prioritizing them for conservation (Basoom et al., 2022). This package
contains has fucntion to compute the rarity, conservation scores for a
particular habitat or several habitats.

## Installation

### Install the recent version from Github

``` r
#For windows operating system
#
install.packages('remotes')

install_github("AnthonyBasooma/conspriorityr")
library(conspriorityr)
```

``` r
#Mac
remotes::install_github("AnthonyBasooma/conspriorityr@HEAD")
library(conspriorityr)
```

## Usage

### Conservation prioritsation vs financial constraints

- Example: Prioritizing the conservation of a waterbody with
  conservation significance but with limited resources in the Lake Kyoga
  system in Uganda

<!-- -->

    #> Warning: package 'sf' was built under R version 4.3.1
    #> Linking to GEOS 3.11.2, GDAL 3.6.2, PROJ 9.2.0; sf_use_s2() is TRUE
    #> Warning: package 'dplyr' was built under R version 4.3.1
    #> 
    #> Attaching package: 'dplyr'
    #> The following objects are masked from 'package:stats':
    #> 
    #>     filter, lag
    #> The following objects are masked from 'package:base':
    #> 
    #>     intersect, setdiff, setequal, union
    #> Warning: package 'ggplot2' was built under R version 4.3.1

- Data sources

``` r

#Obtain hydrosheds basins for Africa and extract the Kyoga lakes system (Lehner et al., 2008)
#https://data.hydrosheds.org/file/hydrobasins/standard/hybas_af_lev01-12_v1c.zip
#Kyoga lakes extracted for analysis

kyoga <- st_read(dsn=system.file('extdata/hydrosheds', 'kyoga.shp', 
                                 package = 'conspriorityr'), quiet = TRUE)


#Species occurences archived in the package
data('gbif')

species_occurences <- gbif
```

- Data cleaning and merging

``` r

#Remove any NAs in the latitudes/longitudes
species_clean <- species_occurences[complete.cases(species_occurences$decimalLatitude),]

#Convert to sf data format

species_clean_sf <- species_clean %>% st_as_sf(coords = c('decimalLongitude','decimalLatitude'), crs=st_crs(4326))

#head(species_clean_sf)

#Filter out records within the kyoga lakes
species_clean_kyoga <- sf:: st_filter(species_clean_sf, kyoga) 

#clean habitat names
```

### Testing functionalites

- Rarity ranges from 0 : Present in all habitats to 1: found in only one
  system

``` r

#Rarity of Haplochromis avium in the Kyoga system

haplo_rare <- rarity(data = species_clean_kyoga%>% st_drop_geometry(), habitat = 'waterbody',species = 'species',
              sp = 'Haplochromis squamulatus')

haplo_rare
#> [1] 0.8888889

#Conservation priority score for Kyoga main
kyogamain <- cpi_one(data = species_clean_kyoga%>% st_drop_geometry(), habitat = 'waterbody', species = 'species',area = 'surfacearea',iucn = 'iucnstatus',
                 hname = 'Lake Kyoga')
kyogamain
#> [1] 0.3888523
# #CPI for Agu

agu <- cpi_one(data = species_clean_kyoga %>% st_drop_geometry(), habitat = 'waterbody', species = 'species',area = 'surfacearea',iucn = 'iucnstatus', hname = 'Lake Agu')
agu
#> [1] 31.71759

#CPI Agu 31.717 vs 0.38: Which signifies that in case of less resources Lake Agu should be prioritised for conservation due to number of threatened and endemic species per unit surface area
```

## Compute for many waterbodies or habitats

``` r
cpiall <- cpi_all(data = species_clean_kyoga%>% st_drop_geometry(), habitat = 'waterbody',
             species='species', area = 'surfacearea', iucn = 'iucnstatus')


## Considering polygons for visualization

#Merge polygon data with species occurences 

species_clean_kyogapoly <- sf::st_join(kyoga, species_clean_kyoga)#%>% st_drop_geometry()


#Compute priority scores for Lake Agu

cpiagu_poly <- cpi_one(data = species_clean_kyogapoly%>% st_drop_geometry(), habitat = 'waterbody', species = 'species', area = 'surfacearea', iucn = 'iucnstatus',
                  hname = 'Lake Agu')

#Compute for all water bodies 

cpipol<- cpi_all(data = species_clean_kyogapoly%>% st_drop_geometry(), 
             habitat = 'waterbody',
             species='species', area = 'surfacearea', iucn = 'iucnstatus')
```

## Visualization

``` r

cpipol1 <- cpipol %>% rename(waterbody =sites)

cpipolmap <- merge(species_clean_kyogapoly, y=cpipol1, by="waterbody", all.x=F) %>%
  dplyr::select(cpi, waterbody)


finalresult <- unique.data.frame(cpipolmap)

#All waterbodies 

ggplot()+
  geom_sf(data= finalresult, aes(fill=cpi))+
  scale_fill_viridis_c(direction = 1)+
  geom_sf_text(data = finalresult, aes(label = waterbody), size=2)+
  labs(x='Longitude', y='Latitude', fill='Priority scores')
#> Warning in st_point_on_surface.sfc(sf::st_zm(x)): st_point_on_surface may not
#> give correct results for longitude/latitude data
```

<img src="man/figures/README-visualize-1.png" width="100%" />

``` r

#Only water bodies with cpi > 5with high scores

ggplot()+
  geom_sf(data= finalresult %>% filter(cpi>5), aes(fill=cpi))+
  scale_fill_viridis_c(direction = 1)+
  geom_sf_text(data = finalresult %>% filter(cpi>5), aes(label = waterbody), size=3)+
  labs(x='Longitude', y='Latitude', fill='Priority scores')
#> Warning in st_point_on_surface.sfc(sf::st_zm(x)): st_point_on_surface may not
#> give correct results for longitude/latitude data
```

<img src="man/figures/README-visualize-2.png" width="100%" />

## References

1.  Basooma, A., Nakiyende, H., Olokotum, M., Balirwa, J. S., Nkalubo,
    W., Musinguzi, L., & Natugonza, V. (2022). A novel index to aid in
    prioritizing habitats for site‐based conservation. Ecology and
    Evolution, 12(3), e8762.
2.  Lehner, B., Verdin, K., & Jarvis, A. (2008). New global hydrography
    derived from spaceborne elevation data. Eos, Transactions American
    Geophysical Union, 89(10), 93-94.
3.  Pebesma, E., & Bivand, R. (2023). Spatial Data Science: With
    Applications in R (1st ed.). Chapman and Hall/CRC.
    <https://doi.org/10.1201/9780429459016>
4.  Wickham H, François R, Henry L, Müller K, Vaughan D (2023). *dplyr:
    A Grammar of Data Manipulation*. R package version 1.1.2,
    <https://CRAN.R-project.org/package=dplyr>.
5.  Wickham H, François R, Henry L, Müller K, Vaughan D (2023). *dplyr:
    A Grammar of Data Manipulation*. R package version 1.1.2,
    <https://CRAN.R-project.org/package=dplyr>.

### END
