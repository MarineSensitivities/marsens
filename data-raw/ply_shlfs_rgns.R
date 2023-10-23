# See workup of data with visuals here:
# - [explore_regions.qmd](https://github.com/MarineSensitivities/workflows/blob/ff7dc184885300b02320029852d3deb5117a32a0/explore_regions.qmd)
# - [explore_regions.html](https://marinesensitivities.org/workflows/explore_regions.html)

librarian::shelf(
  dplyr, glue, janitor, here, rmapshaper, sf,
  quiet = T)

# paths ----
dir_data  <- "/Users/bbest/My Drive/projects/msens/data"
shelf_geo <- glue("{dir_data}/raw/marinecadastre.gov/Outer_Continental_Shelf_Lands_Act.geojson")
plan_gdb  <- glue("{dir_data}/raw/marinecadastre.gov/OffshoreOilGasPlanningArea/OilandGasPlanningAreas.gdb")

# shelf ----
ply_shelf <- read_sf(shelf_geo) |>
  st_transform(4326) |>
  select(objectid) |>
  mutate(
    # fix weird standalone sliver around Prince Rupert
    objectid = case_match(
      objectid, 5 ~ 7,
      .default = objectid)) |>
  group_by(objectid) |>
  summarize(.groups = "drop")

# plan ----

# st_layers(plan_gdb) # OilandGasPlanningAreas
ply_plan <- read_sf(plan_gdb) |>
  clean_names() |>
  select(mms_plan_a, region) |>
  st_transform(4326)


# plan X shelf ----
suppressWarnings({
  ply_rgns <-
    st_intersection(ply_shelf, ply_plan) |>
    st_make_valid() |>
    group_by(objectid, mms_plan_a, region) |>
    summarize(.groups = "drop") |>
    rbind(
      ply_shelf |>
        filter(objectid %in% c(1,2)) |>
        mutate(
          mms_plan_a = "HI",
          region     = "Hawaii")) |>
    st_shift_longitude()
})

# flag repeats from being on either side of antimeridian
d_m <- ply_rgns |>
  st_drop_geometry() |>
  group_by(mms_plan_a) |>
  mutate(n = n()) |>
  filter(n > 1) |>
  mutate(
    antimeridian_bearing = case_match(
      objectid,
      1 ~ "West",
      2 ~ "East",
      6 ~ "West",
      7 ~ "East"))|>
  select(-n) |>
  arrange(mms_plan_a, antimeridian_bearing)

ply_rgns <- ply_rgns |>
  left_join(
    d_m |>
      select(objectid, mms_plan_a, antimeridian_bearing),
    by = c("objectid","mms_plan_a")) |>
  select(-objectid) |>
  arrange(mms_plan_a, antimeridian_bearing) |>
  mutate(
    ctr = st_centroid(geometry),
    ctr_lon = ctr |> st_coordinates() %>% .[,"X"],
    ctr_lat = ctr |> st_coordinates() %>% .[,"Y"]) |>
  select(-ctr) |>
  mutate(
    shlf_name = case_when(
      ctr_lat < 45 &
        ctr_lon < -120 &
        ctr_lon > -130   ~ "Pacific",
      ctr_lon > -100 &
        ctr_lon < -82    ~ "Gulf of Mexico",
      ctr_lon > -82 &
        ctr_lon < 70       ~ "Atlantic",
      mms_plan_a == "HI" ~ "Hawaii",
      .default =           "Alaska"),
    shlf_key = case_match(
      shlf_name,
      "Pacific"        ~ "PAC",
      "Gulf of Mexico" ~ "GOM",
      "Atlantic"       ~ "ATL",
      "Hawaii"         ~ "HI",
      "Alaska"         ~ "AK")) |>
  rename(
    rgn_key    = mms_plan_a,
    rgn_name   = region)

ply_shlfs <- ply_rgns |>
  group_by(shlf_key, shlf_name) |>
  summarize(.groups="drop") |>
  mutate(
    ctr = st_centroid(geometry),
    ctr_lon = ctr |> st_coordinates() %>% .[,"X"],
    ctr_lat = ctr |> st_coordinates() %>% .[,"Y"]) |>
  select(-ctr) |>
  st_shift_longitude() |>
  mutate(
    area_km2 = st_area(geometry) |>
      units::set_units(km^2) |>
      as.numeric()) |>
  relocate(geometry, .after = last_col()) |>
  arrange(shlf_name)

# simplify
ply_shlfs_s05 <- ply_shlfs |>
  ms_simplify(keep=0.05, keep_shapes=T)

# ply_rgns dissolved to rgn
ply_rgns <- ply_rgns |>
  group_by(shlf_key, shlf_name, rgn_key, rgn_name) |>
  summarize(.groups="drop") |>
  mutate(
    ctr = st_centroid(geometry),
    ctr_lon = ctr |> st_coordinates() %>% .[,"X"],
    ctr_lat = ctr |> st_coordinates() %>% .[,"Y"]) |>
  select(-ctr) |>
  st_shift_longitude() |>
  mutate(
    area_km2 = st_area(geometry) |>
      units::set_units(km^2) |>
      as.numeric()) |>
  arrange(shlf_name, rgn_name) |>
  relocate(geometry, .after = last_col())

# simplify
ply_rgns_s05 <- ply_rgns |>
  ms_simplify(keep=0.05, keep_shapes=T)

# use data ----
usethis::use_data(ply_shlfs)
usethis::use_data(ply_shlfs_s05)
usethis::use_data(ply_rgns)
usethis::use_data(ply_rgns_s05)

