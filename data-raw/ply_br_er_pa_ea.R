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
dir_data  <- "/Users/bbest/My Drive/projects/msens/data"
pa_gdb  <- glue("{dir_data}/raw/marinecadastre.gov/OffshoreOilGasPlanningArea/OilandGasPlanningAreas.gdb")
dir_er <- glue("{dir_data}/raw/boem.gov/Ecoregion GIS files")
er_shps  <- list(
  brAK  = glue("{dir_er}/Alaska/Area_Alaska_scd.shp"),
  brATL = glue("{dir_er}/Atlantic/Area_Atlantic_scd.shp"),
  brGOM = glue("{dir_er}/GOM/Area_GOM_scd.shp"),
  brPAC = glue("{dir_er}/Pacific/Area_Pacific_scd.shp") )

# helper functions ----

geom_ctr_area <- function(x){
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

# ply_er: Ecoregions ----
ply_er <- er_shps |>
  imap(
    ~read_sf(.x) |>
      mutate(
        br_key = .y) |>   #
      rename(any_of(c(
        er_name = "Name",
        er_name = "LABEL",
        er_key  = "CODE",
        er_key  = "MMS_PLAN_A"))) |>
      st_transform(4326)) |>
  bind_rows() |>
  mutate(
    br_name = case_match(
      br_key,
      "brAK"  ~ "Alaska",
      "brATL" ~ "Atlantic",
      "brGOM" ~ "Gulf of Mexico",
      "brPAC" ~ "Pacific"),
    er_key = case_match(
      er_name,
      "California Current"          ~ "erCAC",
      "Chukchi and Beaufort Seas"   ~ "erCBS",
      "East Bering Sea"             ~ "erEBS",
      "Eastern GOM"                 ~ "erEGOM",
      "Gulf of Alaska"              ~ "erGOA",
      "Northeast Continental Shelf" ~ "erNECS",
      "Southeast Continental Shelf" ~ "erSECS",
      "Washington/Oregon"           ~ "erWAOR",
      "Western and Central GOM"     ~ "erWCGOM") ) |>
  relocate(br_key, br_name) |>
  st_make_valid() |>
  st_shift_longitude() |>   # shift to -180 to 180 for "East Bering Sea" spanning antimeridian
  geom_ctr_area()
# mapView(ply_er); ply_er |> st_drop_geometry() |> View()

# ply_br: BOEM Regions ----
ply_br <- ply_er |>
  group_by(br_key, br_name) |>
  summarize(.groups="drop") |>
  st_shift_longitude() |>
  geom_ctr_area()
# mapView(ply_br); ply_br |> st_drop_geometry() |> View()

# ply_pa: Planning Areas ----

# st_layers(pa_gdb) # OilandGasPlanningAreas
ply_pa <- read_sf(pa_gdb) |>
  clean_names() |>
  st_transform(4326) |>
  st_shift_longitude() |>
  rename(
    pa_key  = mms_plan_a,
    pa_name = region) |>
  select(-shape_length, -shape_area) |>
  mutate(
    pa_key = glue("pa{pa_key}")) |>
  geom_ctr_area()
# mapView(ply_pa); ply_pa |> st_drop_geometry() |> View()

# ply_ea (ply_er x ply_pa): Ecoareas (Ecoregions x Planning Areas) ----
ply_ea <- ply_er |>
  select(-area_km2, -ctr_lon, -ctr_lat) |>
  st_intersection(
    ply_pa |>
      select(-area_km2, -ctr_lon, -ctr_lat)) |>
  st_make_valid() |>
  st_shift_longitude() |>
  mutate(
    ea_key  = glue("{er_key}-{pa_key}"),
    ea_name = glue("{er_name} - {pa_name}")) |>
  relocate(ea_key, ea_name, .before = "geom") |>
  arrange(br_key, ea_key) |>
  geom_ctr_area()
# mapView(ply_ea); ply_ea |> st_drop_geometry() |> View()

# simplify ----
ply_br_s05 <- ms_simplify(ply_br, keep=0.05, keep_shapes=T) |>
  relocate(all_of(names(ply_br)))
ply_er_s05 <- ms_simplify(ply_er, keep=0.05, keep_shapes=T) |>
  relocate(all_of(names(ply_er)))
ply_pa_s05 <- ms_simplify(ply_pa, keep=0.05, keep_shapes=T) |>
  relocate(all_of(names(ply_pa)))
ply_ea_s05 <- ms_simplify(ply_ea, keep=0.05, keep_shapes=T) |>
  relocate(all_of(names(ply_ea)))

# register ----
use_data(ply_br, overwrite=T)
use_data(ply_er, overwrite=T)
use_data(ply_pa, overwrite=T)
use_data(ply_ea, overwrite=T)

use_data(ply_br_s05, overwrite=T)
use_data(ply_er_s05, overwrite=T)
use_data(ply_pa_s05, overwrite=T)
use_data(ply_ea_s05, overwrite=T)
