
#' Get species by feature
#'
#' Output a table of species present from one or more spatial feature(s).
#'
#' Use the `species_by_feature` endpoint of the API at
#' [api.marinesensitivity.org](https://api.marinesensitivity.org/__docs__/#/default/get_species_by_feature).
#'
#' @param schema.table The SCHEMA.TABLE containing the feature(s).
#' @param where The WHERE clause selecting the feature(s) as the area of interest.
#'
#' @return data.frame of species present in the feature(s)
#' @import httr2 readr
#' @export
#' @concept read
#'
#' @examples
#' get_species_by_feature(
#'   schema.table = "raw.mr_eez",
#'   where        = "mrgid = 8442")
get_species_by_feature <- function(
    schema.table,
    where){

  httr2::request("https://api.marinesensitivity.org") |>
    httr2::req_url_path_append("species_by_feature") |>
    httr2::req_url_query(
      schema.table = schema.table,
      where        = where) |>
    httr2::req_perform() |>
    httr2::resp_body_string() |>
    readr::read_csv(show_col_types = F)
}

