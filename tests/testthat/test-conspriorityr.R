
kyoga <- sf::st_read(dsn=system.file('extdata/hydrosheds', 'kyoga.shp',
                                 package = 'conspriorityr'), quiet = TRUE)

data('gbif')
#
# cpifinal <- priorityindex(data = gbif,
#                           habitat = 'waterbody',
#                           species = 'species',
#                           area = 'surfacearea',
#                           iucn = 'iucnstatus',
#                           plot = T,
#                           select = c('Lake Kyoga', 'Lake Victoria', 'Lake Albert'),
#                           #lat = 'decimalLatitude',
#                           #lon = 'decimalLongitude',
#                           #polygon = kyoga,
#                           map = FALSE,
#                           full = TRUE)

test_that(desc = "Dataframe generated with two columns",
                    code = {
                      cpi <- priorityindex(data = gbif,
                                           habitat = 'waterbody',
                                           species = 'species',
                                           area = 'surfacearea',
                                           iucn = 'iucnstatus')
                      expect_s3_class(cpi, 'data.frame')
                      expect_equal(ncol(cpi), 2)

                    })

