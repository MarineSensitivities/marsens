
#' Basemap
#'
#' Basemap with Esri Ocean Basemap
#'
#' @param base_opacity numeric between 0 and 1 (default=0.5)
#'
#' @return \link[leaflet]{leaflet} map object with Esri.OceanBasemap
#' @import leaflet
#' @export
#' @concept viz
#'
#' @examples
#' ms_basemap()
ms_basemap <- function(base_opacity = 0.5){

  leaflet::leaflet() |>
    # add base: blue bathymetry and light brown/green topography
    leaflet::addProviderTiles(
      "Esri.OceanBasemap",
      options = leaflet::providerTileOptions(
        variant = "Ocean/World_Ocean_Base",
        opacity = base_opacity)) |>
    # add reference: placename labels and borders
    leaflet::addProviderTiles(
      "Esri.OceanBasemap",
      options = leaflet::providerTileOptions(
        variant = "Ocean/World_Ocean_Reference",
        opacity = base_opacity))
}
