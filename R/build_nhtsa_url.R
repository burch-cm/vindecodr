#' Build a NHTSA URL
#'
#' @description
#'
#'  A family of functions to build URLs for the National Highway Transportation
#'  Safety Administration (NHTSA) vehicle identification number (VIN) decoder API.
#'
#' The `build_nhtsa_url()` function returns a closure containing the appropriate
#' endpoint and file format request to pass to the NHTSA VIN API.
#'
#'  * `build_vin_url()` takes a single VIN in a character string and returns
#'    an appropriately-formatted url for a NHTSA API request via the
#'    /vehicles/DecodeVINValues/ endpoint.
#'
#'  * `build_vin_batch_url()` takes up to 50 VINs in a character vector and
#'    returns appropriately-formatted url for a NHTSA API request via the
#'    /vehicles/DecodeVINBatchValues/ endpoint.
#'
#' @param endpoint a string containing the appropriate endpoint. Candidate
#'   endpoints can be found at https://vpic.nhtsa.dot.gov/api/
#' @param format the file format to return from the API, one of 'json', 'xml',
#'   or 'csv'. Defaults to 'json'.
#' @param vin a string containing the VIN to query.
#' @param ... additional arguments to passed on to derived builder functions
#' @return
#'  * `build_nhtsa_url()` returns a function which will in turn build a url which
#'    points to the specified endpoint on the NHTSA API
#'
#'  * `build_vin_url()` returns a url as a string, formatted to query the NHTSA
#'    `DecodeVinValues` endpoint and decode a single VIN.
#'  * `build_vin_batch_url()` returns a url as a string, formatted to query the NHTSA
#'    `DecodeVinBatch Values` endpoint and decode multiple VINs in one call.
#'
#' @export
#'
#' @examples
#' vin_url_xml <- build_nhtsa_url("/vehicles/DecodeVINValues/", format = "xml")
#' build_vin_url("3VWLL7AJ9BM053541")
#' build_vin_batch_url(c("3VWLL7AJ9BM053541", "JH4KA3140KC015221"))
build_nhtsa_url <- function(endpoint, format = "json", ...) {
    baseurl <- "https://vpic.nhtsa.dot.gov/api"
    function(vin, ...) {
        paste0(baseurl, endpoint, vin, "?format=", format, ...)
    }
}

#' @rdname build_nhtsa_url
#' @export
build_vin_url <- build_nhtsa_url(endpoint = "/vehicles/DecodeVINValues/")

#' @rdname build_nhtsa_url
#' @export
build_vin_batch_url <- build_nhtsa_url(endpoint = "/vehicles/DecodeVINValuesBatch/")
