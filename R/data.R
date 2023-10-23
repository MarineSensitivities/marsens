#' Polygons of Shelf Regions
#'
#' Intersection of polygons describing the BOEM internal regions (\href{https://www.arcgis.com/home/item.html?id=576ae15675d747baaec607594fed086e}{BOEM Offshore Oil and Gas Planning Areas})
#' clipped to the federal U.S. waters between the 200 nm Exclusive Economic Zone
#' and 12 nm state waters (\href{https://marinecadastre-noaa.hub.arcgis.com/datasets/noaa::outer-continental-shelf-lands-act/about}{MarineCadastre Outer Continental Shelf Lands Act}).
#' Summarized to Outer Continental Shelf (OCS) region name (key): Alaska (AK), Atlantic (ATL), Gulf of Mexico (GOM), Hawaii (HI), Pacific (PAC).
#'
#' @format
#' A spatial features \pkg{sf} data frame with 5 rows and 6 columns:
#' \describe{
#'   \item{shlf_key}{key for shelf polygon containing region}
#'   \item{shlf_name}{name for shelf polygon containing region}
#'   \item{ctr_lon}{centroid longitude}
#'   \item{ctr_lat}{centroid longitude}
#'   \item{area_km2}{area in square kilometers}
#'   \item{geometry}{geometry of polygon as `sf::st_geometry()`}
#' }
#' @source \href{https://www.arcgis.com/home/item.html?id=576ae15675d747baaec607594fed086e}{BOEM Offshore Oil and Gas Planning Areas}
#' and \href{https://marinecadastre-noaa.hub.arcgis.com/datasets/noaa::outer-continental-shelf-lands-act/about}{MarineCadastre Outer Continental Shelf Lands Act}
#' @concept data
"ply_shlfs"

#' Polygons of Shelf Regions, simplified to 5\%
#'
#' Intersection of polygons describing the BOEM internal regions (\href{https://www.arcgis.com/home/item.html?id=576ae15675d747baaec607594fed086e}{BOEM Offshore Oil and Gas Planning Areas})
#' clipped to the federal U.S. waters between the 200 nm Exclusive Economic Zone
#' and 12 nm state waters (\href{https://marinecadastre-noaa.hub.arcgis.com/datasets/noaa::outer-continental-shelf-lands-act/about}{MarineCadastre Outer Continental Shelf Lands Act}).
#' Summarized to Outer Continental Shelf (OCS) region name (key): Alaska (AK), Atlantic (ATL), Gulf of Mexico (GOM), Hawaii (HI), Pacific (PAC).
#' Simplified to 5\% of original vertices for quickly plotting.
#'
#' @format
#' A spatial features \pkg{sf} data frame with 5 rows and 6 columns:
#' \describe{
#'   \item{shlf_key}{key for shelf polygon containing region}
#'   \item{shlf_name}{name for shelf polygon containing region}
#'   \item{ctr_lon}{centroid longitude}
#'   \item{ctr_lat}{centroid longitude}
#'   \item{area_km2}{area in square kilometers}
#'   \item{geometry}{geometry of polygon as `sf::st_geometry()`}
#' }
#' @source \href{https://www.arcgis.com/home/item.html?id=576ae15675d747baaec607594fed086e}{BOEM Offshore Oil and Gas Planning Areas}
#' and \href{https://marinecadastre-noaa.hub.arcgis.com/datasets/noaa::outer-continental-shelf-lands-act/about}{MarineCadastre Outer Continental Shelf Lands Act}
#' @concept data
"ply_shlfs_s05"

#' Polygons of Regions
#'
#' Intersection of polygons describing the BOEM internal regions (\href{https://www.arcgis.com/home/item.html?id=576ae15675d747baaec607594fed086e}{BOEM Offshore Oil and Gas Planning Areas})
#' clipped to the federal U.S. waters between the 200 nm Exclusive Economic Zone
#' and 12 nm state waters (\href{https://marinecadastre-noaa.hub.arcgis.com/datasets/noaa::outer-continental-shelf-lands-act/about}{MarineCadastre Outer Continental Shelf Lands Act}).
#'
#' @format
#' A spatial features \pkg{sf} data frame with 27 rows and 8 columns:
#' \describe{
#'   \item{shlf_key}{key for shelf polygon containing region}
#'   \item{shlf_name}{name for shelf polygon containing region}
#'   \item{rgn_key}{key for region polygon}
#'   \item{rgn_name}{name for region polygon}
#'   \item{ctr_lon}{centroid longitude}
#'   \item{ctr_lat}{centroid longitude}
#'   \item{area_km2}{area in square kilometers}
#'   \item{geometry}{geometry of polygon as `sf::st_geometry()`}
#' }
#' @source \href{https://www.arcgis.com/home/item.html?id=576ae15675d747baaec607594fed086e}{BOEM Offshore Oil and Gas Planning Areas}
#' and \href{https://marinecadastre-noaa.hub.arcgis.com/datasets/noaa::outer-continental-shelf-lands-act/about}{MarineCadastre Outer Continental Shelf Lands Act}
#' @concept data
"ply_rgns"

#' Polygons of Regions, simplified to 5\%
#'
#' Intersection of polygons describing the BOEM internal regions (\href{https://www.arcgis.com/home/item.html?id=576ae15675d747baaec607594fed086e}{BOEM Offshore Oil and Gas Planning Areas})
#' clipped to the federal U.S. waters between the 200 nm Exclusive Economic Zone
#' and 12 nm state waters (\href{https://marinecadastre-noaa.hub.arcgis.com/datasets/noaa::outer-continental-shelf-lands-act/about}{MarineCadastre Outer Continental Shelf Lands Act}).
#' Simplified to 5\% of original vertices for quickly plotting.
#'
#' @format
#' A spatial features \pkg{sf} data frame with 27 rows and 8 columns:
#' \describe{
#'   \item{shlf_key}{key for shelf polygon containing region}
#'   \item{shlf_name}{name for shelf polygon containing region}
#'   \item{rgn_key}{key for region polygon}
#'   \item{rgn_name}{name for region polygon}
#'   \item{ctr_lon}{centroid longitude}
#'   \item{ctr_lat}{centroid longitude}
#'   \item{area_km2}{area in square kilometers}
#'   \item{geometry}{geometry of polygon as `sf::st_geometry()`}
#' }
#' @source \href{https://www.arcgis.com/home/item.html?id=576ae15675d747baaec607594fed086e}{BOEM Offshore Oil and Gas Planning Areas}
#' and \href{https://marinecadastre-noaa.hub.arcgis.com/datasets/noaa::outer-continental-shelf-lands-act/about}{MarineCadastre Outer Continental Shelf Lands Act}
#' @concept data
"ply_rgns_s05"
