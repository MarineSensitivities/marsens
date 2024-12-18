wm_rest_params <- tibble::tribble(
  ~type ,                 ~operation, ~max_req,              ~param,
  "sci_fuzzy"  , "AphiaRecordsByMatchNames",       NA, "scientificnames[]",
  # "sci_exact"  ,      "AphiaRecordsByNames",      500, "scientificnames[]",
  # IUCN RL LOBSTERS.gpkg (n=207) <error/httr2_http_414> Error in `resp_abort()`: ! HTTP 414 URI Too Long.
  # IUCN RL LOBSTERS.gpkg 12056 characters is too long
  # IUCN RL REEF_FORMING_CORALS_PART2_valids.gpkg get_df(resp, 1) 8823 characters is too long
  "sci_exact"  ,      "AphiaRecordsByNames",      100, "scientificnames[]",
  "aphia_exact",   "AphiaRecordsByAphiaIDs",       50,        "aphiaids[]",
  "common_exact","AphiaRecordsByVernacular",       NA,                  NA)
usethis::use_data(wm_rest_params, overwrite = T)
