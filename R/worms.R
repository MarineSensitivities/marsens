#' Query WoRMS REST API with multiple requests
#'
#' When trying to perform batch requests the WoRMS REST API unfortunately does
#' not return the requested field so it is not obvious which taxa requested
#' matches which response. Even when fetching records in batch by `aphia_id`
#' functions in the `worrms` R package do not page requests based on the record
#' limits of the WoRMS REST API. Finally, it is much preferred to use the
#' multiplexing capabilities of the latest `httr2` library to send multiple
#' requests in parallel, versus each one sequentially.
#'
#' @param df data frame to match
#' @param fld field in data frame to use with operation
#' @param operation operation name of WoRMS REST API; One of operations listed
#'   at [marinespecies.org/rest](https://www.marinespecies.org/rest), like
#'   "AphiaRecordsByMatchNames" (non-paging), "AphiaRecordsByVernacular" (paging),
#'   "AphiaRecordsByNames" (paging), or "AphiaRecordsByAphiaIDs" (paging);
#'   default: "AphiaRecordsByMatchNames"
#' @param server URL of server REST endpoint; default: "https://www.marinespecies.org/rest"
#' @param ... other query parameters to pass to operation
#'
#' @return data frame of results from WoRMS API prepended with unique values from `fld`
#' @importFrom glue glue
#' @importFrom janitor clean_names
#' @importFrom purrr map2 imap
#' @importFrom sf st_drop_geometry
#' @importFrom tidyr unnest
#' @importFrom utils URLencode
#' @importFrom httr2 request req_perform_parallel req_url_path_append req_url_query resp_body_json
#' @importFrom tibble tibble
#'
#' @export
#' @concept taxa
#'
#' @examples
#' \dontrun{
#' tmp_test <- tibble::tribble(
#'            ~common,                     ~scientific, aphia_id_0,
#'      "Minke whale",     "Balaenoptera acutorostrata", 137087,
#'       "Blue whale",          "Balaenoptera musculus", 137090,
#' "Bonaparte's Gull",   "Chroicocephalus philadelphia", 882954)
#' # 882954 invalid non-marine -> valid marine 159076
#'
#' wm_exact <- wm_rest(tmp_test, scientific, "AphiaRecordsByMatchNames")
#' wm_fuzzy <- wm_rest(tmp_test, scientific, "AphiaRecordsByNames")
#' wm_byid  <- wm_rest(tmp_test, scientific, "AphiaRecordsByNames", marine_only=F)
#' }
wm_rest <- function(
    df, fld,
    operation = "AphiaRecordsByMatchNames",
    server    = "https://www.marinespecies.org/rest",
    ...){
  # operation="AphiaRecordsByNames"; server="https://www.marinespecies.org/rest"

  fld_str <- deparse(substitute(fld))
  q_extra <- list(...) %>% unlist(use.names=T)

  # get unique values from df.fld
  vals <- df %>%
    sf::st_drop_geometry() %>%
    dplyr::group_by({{ fld }}) %>%
    dplyr::summarize(.groups = "drop") %>%
    dplyr::pull({{ fld }})
  # DEBUG:
  # vals <<- vals

  # helper function to formulate request
  get_req <- function(vals){
    if (is.na(op$param)){
      q <- character(0)
      req <- httr2::request(server) %>%
        httr2::req_url_path_append(operation) %>%
        httr2::req_url_path_append(utils::URLencode(vals))
    } else {
      q <- stats::setNames(vals, rep(op$param, length(vals)))
      req <- httr2::request(server) %>%
        httr2::req_url_path_append(operation)
    }
    q <- c(q, q_extra)
    if (length(q) > 0){
      req <- req %>%
        httr2::req_url_query(!!!q)
    }
  }

  # helper function to transform response to data frame
  get_df <- function(resp, i=0){
    if (inherits(resp, "error")){
      stop(glue::glue("  DOH! resp error in get_df(resp, {i}), prob URL with {nchar(d$req[[i]]$url)} characters is too long"))
    }
    if (resp$status_code == 204) # No Content
      return(NA)

    d <- resp %>%
      httr2::resp_body_json(simplifyVector = T, flatten = T)

    if(inherits(d, "list")){
      d <- d %>%
        lapply(tibble::as_tibble) %>%
        dplyr::bind_rows()
    }
    d %>%
      janitor::clean_names()
  }

  # get operation parameters
  op <- msens::wm_rest_params %>%
    dplyr::filter(operation == !!operation)
  is_paging <- nrow(op) == 1 && !is.na(op$max_req)

  # formulate requests, based on whether paging operation
  if (is_paging){
    # page through requests based on operation

    nmax <- op$max_req

    # get pages
    i_last = ifelse(
      length(vals) %% nmax == 0,
      NULL,
      length(vals))
    v_end <- i_last
    if (length(vals) > nmax)
      v_end <- c(seq(nmax, length(vals), by=nmax), i_last)
    d <- tibble(
      i_beg = seq(1, length(vals), by=nmax),
      i_end = v_end)

    # fetch aphia records, bind results, clean column names, remove duplicats
    d <- d %>%
      dplyr::mutate(
        req = purrr::map2(
          i_beg, i_end,
          ~get_req(vals = vals[.x:.y])))

    # calculate eta
    eta <- Sys.time() + as.difftime(nrow(d) * 1, units="secs")
    eta_msg <- glue::glue(
      "Given ~ 1 second per request and {nrow(d)} requests (max {nmax} values
      per request) with {length(vals)} unique values of `{fld_str}`,
       estimated time of completion: {eta}")
  } else {
    # do not page through requests
    d <- tibble(
      val = vals) %>%
      mutate(
        req  = purrr::map(val, get_req))

    # calculate eta
    eta <- Sys.time() + as.difftime(length(vals) * 1, units="secs")
    eta_msg <- glue::glue(
      "Given ~ 1 second per request and {length(vals)} unique values of `{fld_str}`,
       estimated time of completion: {eta}")
  }
  message(eta_msg)

  # perform requests and convert to data frame
  d <- d %>%
    mutate(
      resp = req_perform_parallel(req),
      df   = imap(resp, get_df)) %>%
    dplyr::select(-req, -resp) %>%
    tidyr::unnest(df)

  # if not paging, rename field vals to original input fld
  if (!is_paging){
    fld_val <- fld_str
    if (fld_val %in% names(d))
      fld_val <- glue::glue("_{fld_val}")
    flds_rnm <- setNames("val", fld_val)
    d <- d %>%
      dplyr::rename(!!!flds_rnm)
  } else {
    d <- d %>%
      dplyr::select(-i_beg, -i_end)
  }

  d
}
