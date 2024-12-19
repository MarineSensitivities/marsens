#' Polygons of BOEM Regions
#'
#' Polygons describing the BOEM Outer Continental Shelf (OCS) Regions
#' [BOEM Offshore Oil and Gas Planning Areas](https://www.arcgis.com/home/item.html?id=576ae15675d747baaec607594fed086e)
#' Summarized to region name (key): Alaska (AK), Atlantic (ATL), Gulf of Mexico (GOM), Pacific (PAC).
#'
#' @format ## `ply_boemrgns`
#' A spatial features \pkg{sf} data frame with 5 rows and 6 columns:
#' \describe{
#'   \item{boemrgn_key}{key for BOEM Region}
#'   \item{boemrgn_name}{name for BOEM Region}
#'   \item{geom}{geometry of polygon as `sf::st_geometry()`}
#'   \item{ctr_lon}{centroid longitude}
#'   \item{ctr_lat}{centroid longitude}
#'   \item{area_km2}{area in square kilometers}
#' }
#' @source [BOEM Offshore Oil and Gas Planning Areas](https://www.arcgis.com/home/item.html?id=576ae15675d747baaec607594fed086e)
#' @concept data
"ply_boemrgns"

#' Polygons of BOEM Regions, simplified to 5%
#'
#' Polygons describing the BOEM Outer Continental Shelf (OCS) Regions
#' [BOEM Offshore Oil and Gas Planning Areas](https://www.arcgis.com/home/item.html?id=576ae15675d747baaec607594fed086e)
#' Summarized to region name (key): Alaska (AK), Atlantic (ATL), Gulf of Mexico (GOM), Pacific (PAC).
#' Simplified to 5% of original vertices for quickly plotting.
#'
#' @format ## `ply_boemrgns_s05`
#' A spatial features \pkg{sf} data frame with 4 rows and 6 columns:
#' \describe{
#'   \item{boemrgn_key}{key for shelf polygon containing region}
#'   \item{boemrgn_name}{name for shelf polygon containing region}
#'   \item{geom}{geometry of polygon as `sf::st_geometry()`}
#'   \item{ctr_lon}{centroid longitude}
#'   \item{ctr_lat}{centroid longitude}
#'   \item{area_km2}{area in square kilometers}
#' }
#' @source [BOEM Offshore Oil and Gas Planning Areas](https://www.arcgis.com/home/item.html?id=576ae15675d747baaec607594fed086e)
#' @concept data
"ply_boemrgns_s05"

#' Polygons of Planning Areas
#'
#' BOEM Planning Areas from ([BOEM Offshore Oil and Gas Planning Areas](https://www.arcgis.com/home/item.html?id=576ae15675d747baaec607594fed086e)).
#'
#' @format ## `ply_planareas`
#' A spatial features \pkg{sf} data frame with 26 rows and 8 columns:
#' \describe{
#'   \item{planarea_key}{key for Planning Area}
#'   \item{planarea_name}{name for Planning Area}
#'   \item{geom}{geometry of polygon as `sf::st_geometry()`}
#'   \item{ctr_lon}{centroid longitude}
#'   \item{ctr_lat}{centroid longitude}
#'   \item{area_km2}{area in square kilometers}
#' }
#' @source [BOEM Offshore Oil and Gas Planning Areas](https://www.arcgis.com/home/item.html?id=576ae15675d747baaec607594fed086e)
#' @concept data
"ply_planareas"

#' Polygons of Planning Areas, simplified to 5%
#'
#' BOEM Planning Areas ([BOEM Offshore Oil and Gas Planning Areas](https://www.arcgis.com/home/item.html?id=576ae15675d747baaec607594fed086e)).
#' Simplified to 5% of original vertices for quickly plotting.
#'
#' @format ## `ply_planareas_s05`
#' A spatial features \pkg{sf} data frame with 27 rows and 8 columns:
#' \describe{
#'   \item{planarea_key}{key for Planning Area}
#'   \item{planarea_name}{name for Planning Area}
#'   \item{geom}{geometry of polygon as `sf::st_geometry()`}
#'   \item{ctr_lon}{centroid longitude}
#'   \item{ctr_lat}{centroid longitude}
#'   \item{area_km2}{area in square kilometers}
#' }
#' @source [BOEM Offshore Oil and Gas Planning Areas](https://www.arcgis.com/home/item.html?id=576ae15675d747baaec607594fed086e)
#' @concept data
"ply_planareas_s05"

#' Polygons of Ecoregions
#'
#' BOEM Ecoregions, extended to the Planning Areas.
#'
#' @format ## `ply_ecorgns`
#' A spatial features \pkg{sf} data frame with 26 rows and 8 columns:
#' \describe{
#'   \item{ecorgn_key}{key for Planning Area}
#'   \item{ecorgn_name}{name for Planning Area}
#'   \item{geom}{geometry of polygon as `sf::st_geometry()`}
#'   \item{ctr_lon}{centroid longitude}
#'   \item{ctr_lat}{centroid longitude}
#'   \item{area_km2}{area in square kilometers}
#' }
#' @concept data
"ply_ecorgns"

#' Polygons of Ecoregions
#'
#' BOEM Ecoregions, extended to the Planning Areas.
#' Simplified to 5% of original vertices for quickly plotting.
#'
#' @format ## `ply_ecorgns_s05`
#' A spatial features \pkg{sf} data frame with 26 rows and 8 columns:
#' \describe{
#'   \item{ecorgn_key}{key for Planning Area}
#'   \item{ecorgn_name}{name for Planning Area}
#'   \item{geom}{geometry of polygon as `sf::st_geometry()`}
#'   \item{ctr_lon}{centroid longitude}
#'   \item{ctr_lat}{centroid longitude}
#'   \item{area_km2}{area in square kilometers}
#' }
#' @concept data
"ply_ecorgns_s05"

#' Polygons of EcoAreas
#'
#' BOEM EcoAreas, which represent the intersection of Ecoregions and Planning Areas.
#'
#' @format ## `ply_ecoareas`
#' A spatial features \pkg{sf} data frame with 26 rows and 8 columns:
#' \describe{
#'   \item{ecoarea_key}{key for Planning Area}
#'   \item{ecoarea_name}{name for Planning Area}
#'   \item{geom}{geometry of polygon as `sf::st_geometry()`}
#'   \item{ctr_lon}{centroid longitude}
#'   \item{ctr_lat}{centroid longitude}
#'   \item{area_km2}{area in square kilometers}
#' }
#' @concept data
"ply_ecoareas"

#' Polygons of EcoAreas
#'
#' BOEM EcoAreas, which represent the intersection of Ecoregions and Planning Areas.
#' Simplified to 5% of original vertices for quickly plotting.
#'
#' @format ## `ply_ecoareas_s05`
#' A spatial features \pkg{sf} data frame with 26 rows and 8 columns:
#' \describe{
#'   \item{ecoarea_key}{key for Planning Area}
#'   \item{ecoarea_name}{name for Planning Area}
#'   \item{geom}{geometry of polygon as `sf::st_geometry()`}
#'   \item{ctr_lon}{centroid longitude}
#'   \item{ctr_lat}{centroid longitude}
#'   \item{area_km2}{area in square kilometers}
#' }
#' @concept data
"ply_ecoareas_s05"
