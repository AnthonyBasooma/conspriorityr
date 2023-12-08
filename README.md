
<!-- README.md is generated from README.Rmd. Please edit that file -->

# conspriorityr

<!-- badges: start -->

[![R-CMD-check](https://github.com/AnthonyBasooma/conspriorityr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/AnthonyBasooma/conspriorityr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

Computes conservation based habitat scores to aid in preferential
selection for conservation espeically when resources are limited. The
scores compute incorporates the species threat levels, rarity, richness,
and habitat surface area. The smaller a habitat with threatened species
which are endemic the higher the higher scores. Surface area was also
incorporated as a proxy for financial constraint to select habitats are
cost-effective to manage in case of limited resources.

## Installation

Install the recent version from Github

``` r
#For windows operating system
#
install.packages('remotes)

install_github("AnthonyBasooma/conspriorityr")

#Mac
remotes::install_github("AnthonyBasooma/conspriorityr@HEAD")
```

## Conservaation

Prioritizing the conservation of waterbodies in the Lake Kyoga system in
Uganda

``` r

library(conspriorityr) #compute priority scores
library(sf) #to handle the vector data/maps
#> Warning: package 'sf' was built under R version 4.3.1
#> Linking to GEOS 3.11.2, GDAL 3.6.2, PROJ 9.2.0; sf_use_s2() is TRUE

## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
