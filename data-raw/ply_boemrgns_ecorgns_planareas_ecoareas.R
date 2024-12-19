# br: BOEM Regions > er:Ecoregions, pa:Planning Areas > ea:Ecoareas
# TODO:
# - [ ] add `br_key|name` to `ply_pa` (+ docs in R/data.R)
# - [ ] rm old objects: ply_shlfs, ply_rgns, *_s05
# - [ ] docs in R/data.R: `ply_er`, `ply_er_s05`, `ply_ea`, `ply_ea_s05`
#
# See workup of data with visuals here:
# - [explore_regions.qmd](https://github.com/MarineSensitivity/workflows/blob/ff7dc184885300b02320029852d3deb5117a32a0/explore_regions.qmd)
# - [explore_regions.html](https://marinesensitivity.org/workflows/explore_regions.html)

librarian::shelf(
  dplyr, glue, janitor, here,
  mapview, # DEBUG
  purrr, rmapshaper, sf, units, usethis,
  quiet = T)

# paths ----
dir_data     <- "/Users/bbest/My Drive/projects/msens/data"
planarea_gdb <- glue("{dir_data}/raw/marinecadastre.gov/OffshoreOilGasPlanningArea/OilandGasPlanningAreas.gdb")
dir_ecorgn   <- glue("{dir_data}/raw/boem.gov/Ecoregion GIS files")
ecorgn_shps  <- list(
  brAK  = glue("{dir_ecorgn}/Alaska/Area_Alaska_scd.shp"),
  brATL = glue("{dir_ecorgn}/Atlantic/Area_Atlantic_scd.shp"),
  brGOM = glue("{dir_ecorgn}/GOM/Area_GOM_scd.shp"),
  brPAC = glue("{dir_ecorgn}/Pacific/Area_Pacific_scd.shp") )

# helper functions ----

set_geom_ctr_area <- function(x){
  x |>
    st_set_geometry("geom") |>
    mutate(
      ctr      = st_centroid(geom),
      ctr_lon  = ctr |> st_coordinates() %>% .[,"X"],
      ctr_lat  = ctr |> st_coordinates() %>% .[,"Y"],
      area_km2 = st_area(geom) |>
        set_units(km^2) |>
        as.numeric() ) |>
    select(-ctr)
}

drop_ctr_area <- function(x){
  x |>
    select(-ctr_lon, -ctr_lat, -area_km2)
}

# ply_ecorgns: Ecoregions ----
ply_ecorgns <- ecorgn_shps |>
  imap(
    ~read_sf(.x) |>
      mutate(
        boemrgn_key = .y) |>   #
      rename(any_of(c(
        ecorgn_name = "Name",
        ecorgn_name = "LABEL",
        ecorgn_key  = "CODE",
        ecorgn_key  = "MMS_PLAN_A"))) |>
      st_transform(4326)) |>
  bind_rows() |>
  mutate(
    boemrgn_name = case_match(
      boemrgn_key,
      "brAK"  ~ "Alaska",
      "brATL" ~ "Atlantic",
      "brGOM" ~ "Gulf of Mexico",
      "brPAC" ~ "Pacific"),
    ecorgn_key = case_match(
      ecorgn_name,
      "California Current"          ~ "erCAC",
      "Chukchi and Beaufort Seas"   ~ "erCBS",
      "East Bering Sea"             ~ "erEBS",
      "Eastern GOM"                 ~ "erEGOM",
      "Gulf of Alaska"              ~ "erGOA",
      "Northeast Continental Shelf" ~ "erNECS",
      "Southeast Continental Shelf" ~ "erSECS",
      "Washington/Oregon"           ~ "erWAOR",
      "Western and Central GOM"     ~ "erWCGOM") ) |>
  relocate(boemrgn_key, boemrgn_name) |>
  st_make_valid() |>
  st_shift_longitude() |>   # shift to -180 to 180 for "East Bering Sea" spanning antimeridian
  set_geom_ctr_area()
# mapView(ply_ecorgns); ply_ecorgns |> st_drop_geometry() |> View()

# ply_boemrgns: BOEM Regions ----
ply_boemrgns <- ply_ecorgns |>
  group_by(boemrgn_key, boemrgn_name) |>
  summarize(.groups="drop") |>
  st_shift_longitude() |>
  set_geom_ctr_area()
# mapView(ply_boemrgns); ply_boemrgns |> st_drop_geometry() |> View()

# ply_planareas: Planning Areas ----

# st_layers(planarea_gdb) # OilandGasPlanningAreas
ply_planareas <- read_sf(planarea_gdb) |>
  clean_names() |>
  st_transform(4326) |>
  st_shift_longitude() |>
  rename(
    planarea_key  = mms_plan_a,
    planarea_name = region) |>
  select(-shape_length, -shape_area) |>
  mutate(
    planarea_key = glue("pa{planarea_key}")) |>
  st_join(
    ply_boemrgns |>
      select(boemrgn_key, boemrgn_name),
    largest = T) |>   # join BOEM Regions
  relocate(boemrgn_key, boemrgn_name) |>
  arrange(boemrgn_key, planarea_key) |>
  set_geom_ctr_area()
# mapView(ply_planareas); ply_planareas |> st_drop_geometry() |> View()

# ply_ecoareas: Ecoareas (Ecoregions x Planning Areas: ply_er x ply_pa) ----
ply_ecoareas <- ply_ecorgns |>
  drop_ctr_area() |>
  st_intersection(
    ply_planareas |>
      select(-boemrgn_name, -boemrgn_key) |>
      drop_ctr_area()) |>
  st_make_valid() |>
  st_shift_longitude()

# append planareas not intersecting ecoregions with nearest ecoregion
ply_pa_noter <- ply_planareas |>
  drop_ctr_area() |>
  st_difference(st_union(ply_ecorgns)) |> # n = 25
  st_shift_longitude() |>
  st_cast('MULTIPOLYGON') |>
  st_cast("POLYGON") |>                   # n = 4,683
  mutate(
    ecorgn_key = ply_ecorgns$ecorgn_key[st_nearest_feature(geom, ply_ecorgns)]) |>
  left_join(
    ply_ecorgns |>
      select(ecorgn_key, ecorgn_name) |>
      st_drop_geometry(),
    by = "ecorgn_key") |>
  relocate(ecorgn_key, ecorgn_name, .before = "planarea_key")

# spot check
# mapView(ply_ecorgns, zcol="ecorgn_key", col.regions = \(n) grDevices::hcl.colors(n, palette = "greens")) +
#   mapView(ply_planareas, zcol="planarea_key", col.regions = \(n) grDevices::hcl.colors(n, palette = "blues")) +
#   mapView(ply_pa_noter[3,], color="red")

# union each ecorgn_key from both sets: ply_ecoareas + ply_pa_noter
cols <- setdiff(names(ply_ecoareas), "geom")
ply_ecoareas <- ply_ecoareas |>
  bind_rows(
    ply_pa_noter) |>
  group_by(across(all_of(cols))) |>
  summarize(.groups="drop") |>
  st_make_valid() |>
  mutate(
    ecoarea_key  = glue("{ecorgn_key}-{planarea_key}"),
    ecoarea_name = glue("{ecorgn_name} - {planarea_name}")) |>
  relocate(ecoarea_key, ecoarea_name, .before = "geom") |>
  arrange(boemrgn_key, ecoarea_key) |>
  set_geom_ctr_area()
# mapView(ply_ecoareas, zcol="ecoarea_key"); ply_ecoareas |> st_drop_geometry() |> View()

# # check intersection again
# ply_pa_notea <- ply_planareas |>
#   drop_ctr_area() |>
#   st_difference(st_union(ply_ecoareas)) |>
#   set_geom_ctr_area() |>
#   arrange(desc(area_km2)) |>
#   st_shift_longitude() # n = 26
#
# table(st_geometry_type(ply_pa_notea$geom))
# ply_pa_notea$area_km2[1:10]
# summary(ply_pa_notea$area_km2)
#
# # spot check
# mapView(ply_ecorgns, zcol="ecorgn_key", col.regions = \(n) grDevices::hcl.colors(n, palette = "greens")) +
#   mapView(ply_planareas, zcol="planarea_key", col.regions = \(n) grDevices::hcl.colors(n, palette = "blues")) +
#   mapView(ply_pa_notea[1,], color="red")
# # OK, all weird slivers without area

# ply_ecorgns, v2: Ecoregions (extended to Planning Areas) ----
cols <- setdiff(names(ply_ecorgns), c("geom", "ctr_lon", "ctr_lat", "area_km2")) |>
  paste(collapse = ", ")
ply_ecorgns <- ply_ecoareas |>
  group_by(boemrgn_key, boemrgn_name, ecorgn_key, ecorgn_name) |>
  summarize(.groups = "drop") |>
  set_geom_ctr_area()

# simplify ----
ply_boemrgns_s05 <- ms_simplify(
  ply_boemrgns, keep=0.05, keep_shapes=T) |>
  relocate(all_of(names(ply_boemrgns)))
ply_ecorgns_s05 <- ms_simplify(
  ply_ecorgns, keep=0.05, keep_shapes=T) |>
  relocate(all_of(names(ply_ecorgns)))
ply_planareas_s05 <- ms_simplify(
  ply_planareas, keep=0.05, keep_shapes=T) |>
  relocate(all_of(names(ply_planareas)))
ply_ecoareas_s05 <- ms_simplify(
  ply_ecoareas, keep=0.05, keep_shapes=T) |>
  relocate(all_of(names(ply_ecoareas)))

# register ----
use_data(ply_boemrgns, overwrite=T)
use_data(ply_ecorgns, overwrite=T)
use_data(ply_planareas, overwrite=T)
use_data(ply_ecoareas, overwrite=T)

use_data(ply_boemrgns_s05, overwrite=T)
use_data(ply_ecorgns_s05, overwrite=T)
use_data(ply_planareas_s05, overwrite=T)
use_data(ply_ecoareas_s05, overwrite=T)
