#' @title Global Biodiversity Information Data data for African lakes
#'
#' @description A \code{tibble} for all small lakes in Africa with their surface area
#'
#' @docType data
#'
#' @details
#' The data was cleaned a column for waterbody surface area was included collated from Google Earth
#' and published literature. For original data, please check the reference below from GBIF. The
#' data was formatted to include other columns such as surface area of the lakes and source of literature,
#' the average depth, the threats affecting the species and the categories of the water bodies
#' whether large or small. Other column names are standard to GBIF but customized for analysis.
#' For analysis reproducibilty purposes in the published article (Basooma et al., 2022) in Ecology and
#' Evolution, this data was hosted on dryad https://doi.org/10.5061/dryad.4b8gthtcx). However, the
#' the original data can be found and referenced at
#' GBIF.org (04 June 2021) GBIF Occurrence Download https://doi.org/10.15468/dl.y7amdg. In case
#' of scientific data use, the users are strongly advised to use the orginal copy. But, in this
#' package, the customised data file will be used.
#'
#' @usage data(gbif)
#'
#' @keywords datasets
#'
#' @format A dataframe with 50 columns and 36541 rows.
#' \describe{
#' \item{area}{the surface area of each waterbody. For shared waterbodies, the surface area was segregated per country}
#' \item{avdepth}{Average depth for each waterbody collated from literature}
#' \item{nature}{categorising waterbodies into lakes, rivers, streams, or oceans}
#' }
#'
#' @example
#'
#' \dontrun{
#'
#' data("gbif")
#' gbif
#' }
#'
#' @author Anthony Basooma (bas4ster@gmil.com)
#'
#' @references GBIF.org (04 June 2021) GBIF Occurrence Download https://doi.org/10.15468/dl.y7amdg
#'
"gbif"
