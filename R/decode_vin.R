#' Use the NHTSA API to Decode VINs
#'
#' @param vin either a single vehicle identification number in a character
#'   string, or multiple vehicle identification numbers in a character vector.
#' @param ... additional arguments passed to the url builder functions.
#'
#' @return a data frame with the VIN, Make, Model, Model Year, Fuel Type, and
#'   Gross Vehicle Weight Rating (GVWR) for the specified VINs.
#' @export
#'
#' @examples
#' \dontrun{
#' # Decode a single VIN:
#' decode_vin("JHLRD68404C018253")
#'
#' # Decode multiple VINs:
#' decode_vin(c("JHLRD68404C018253", "JH4DA9450MS001229"))
#' }
decode_vin <- function(vin, ...) {
    if (length(vin) == 1) {
        response <- httr::GET(build_vin_url(vin, ...))
    } else {
        vins <- paste(vin, collapse = ";")
        response <- httr::POST(build_vin_batch_url(vins, ...))
    }

    if (response$status_code != 200) {
        msg <- paste("API responded with status code", response$status_code)
        stop(msg)
    }

    con <- httr::content(response)$Results
    if (requireNamespace("purrr", quietly = TRUE)) {
        VIN        <- purrr::map_chr(con, "VIN")
        make       <- purrr::map_chr(con, "Make")
        model      <- purrr::map_chr(con, "Model")
        model_year <- purrr::map_chr(con, "ModelYear")
        fuel_type  <- purrr::map_chr(con, "FuelTypePrimary")
        GVWR       <- purrr::map_chr(con, "GVWR")
    } else {
        VIN            <- c()
        make           <- c()
        model          <- c()
        model_year     <- c()
        fuel_type      <- c()
        GVWR           <- c()
        for (i in seq_along(con)) {
            VIN        <- append(VIN, con[[i]]$VIN)
            make       <- append(make, con[[i]]$Make)
            model      <- append(model, con[[i]]$Model)
            model_year <- append(model_year, con[[i]]$ModelYear)
            fuel_type  <- append(fuel_type, con[[i]]$FuelTypePrimary)
            GVWR       <- append(GVWR, con[[i]]$GVWR)
        }
    }
    data.frame(VIN, make, model, model_year, fuel_type, GVWR)
}


