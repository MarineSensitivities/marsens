#' Polygons of BOEM Regions
#'
#' Polygons describing the BOEM Outer Continental Shelf (OCS) Regions (\href{https://www.arcgis.com/home/item.html?id=576ae15675d747baaec607594fed086e}{BOEM Offshore Oil and Gas Planning Areas})
#' Summarized to region name (key): Alaska (AK), Atlantic (ATL), Gulf of Mexico (GOM), Pacific (PAC).
#'
#' @format
#' A spatial features \pkg{sf} data frame with 5 rows and 6 columns:
#' \describe{
#'   \item{br_key}{key for BOEM Region}
#'   \item{br_name}{name for BOEM Region}
#'   \item{geom}{geometry of polygon as `sf::st_geometry()`}
#'   \item{ctr_lon}{centroid longitude}
#'   \item{ctr_lat}{centroid longitude}
#'   \item{area_km2}{area in square kilometers}
#' }
#' @source \href{https://www.arcgis.com/home/item.html?id=576ae15675d747baaec607594fed086e}{BOEM Offshore Oil and Gas Planning Areas}
#' @concept data
"ply_br"

#' Polygons of BOEM Regions, simplified to 5\%
#'
#' Polygons describing the BOEM Outer Continental Shelf (OCS) Regions (\href{https://www.arcgis.com/home/item.html?id=576ae15675d747baaec607594fed086e}{BOEM Offshore Oil and Gas Planning Areas})
#' Summarized to region name (key): Alaska (AK), Atlantic (ATL), Gulf of Mexico (GOM), Pacific (PAC).
#' Simplified to 5\% of original vertices for quickly plotting.
#'
#' @format
#' A spatial features \pkg{sf} data frame with 4 rows and 6 columns:
#' \describe{
#'   \item{br_key}{key for shelf polygon containing region}
#'   \item{br_name}{name for shelf polygon containing region}
#'   \item{geom}{geometry of polygon as `sf::st_geometry()`}
#'   \item{ctr_lon}{centroid longitude}
#'   \item{ctr_lat}{centroid longitude}
#'   \item{area_km2}{area in square kilometers}
#' }
#' @source \href{https://www.arcgis.com/home/item.html?id=576ae15675d747baaec607594fed086e}{BOEM Offshore Oil and Gas Planning Areas}
#' @concept data
"ply_br_s05"

#' Polygons of Planning Areas
#'
#' BOEM Planning Areas (\href{https://www.arcgis.com/home/item.html?id=576ae15675d747baaec607594fed086e}{BOEM Offshore Oil and Gas Planning Areas})
#'
#' @format
#' A spatial features \pkg{sf} data frame with 26 rows and 8 columns:
#' \describe{
#'   \item{pa_key}{key for Planning Area}
#'   \item{pa_name}{name for Planning Area}
#'   \item{geom}{geometry of polygon as `sf::st_geometry()`}
#'   \item{ctr_lon}{centroid longitude}
#'   \item{ctr_lat}{centroid longitude}
#'   \item{area_km2}{area in square kilometers}
#' }
#' @source \href{https://www.arcgis.com/home/item.html?id=576ae15675d747baaec607594fed086e}{BOEM Offshore Oil and Gas Planning Areas}
#' and \href{https://marinecadastre-noaa.hub.arcgis.com/datasets/noaa::outer-continental-shelf-lands-act/about}{MarineCadastre Outer Continental Shelf Lands Act}
#' @concept data
"ply_pa"

#' Polygons of Planning Areas, simplified to 5\%
#'
#' BOEM Planning Areas (\href{https://www.arcgis.com/home/item.html?id=576ae15675d747baaec607594fed086e}{BOEM Offshore Oil and Gas Planning Areas})
#'
#' @format
#' A spatial features \pkg{sf} data frame with 27 rows and 8 columns:
#' \describe{
#'   \item{pa_key}{key for Planning Area}
#'   \item{pa_name}{name for Planning Area}
#'   \item{geom}{geometry of polygon as `sf::st_geometry()`}
#'   \item{ctr_lon}{centroid longitude}
#'   \item{ctr_lat}{centroid longitude}
#'   \item{area_km2}{area in square kilometers}
#' }
#' @source \href{https://www.arcgis.com/home/item.html?id=576ae15675d747baaec607594fed086e}{BOEM Offshore Oil and Gas Planning Areas}
#' @concept data
"ply_pa_s05"
