#' Verify VIN Validity
#'
#' Examines provided VINs for valid length, characters, and check digit.
#'
#' @param vin A character vector of VINs to check. Wildcards (e.g. *) are NOT allowed.
#' @param guess Logical. Should values for illegal characters be guessed?
#'
#' @return A logical vector of same length as the input vector.
#' @export
#'
#' @examples
#' vins <- c("WDBEA30D3HA391172", "3VWLL7AJ9BM053541")
#' check_vin(vins)
check_vin <- function(vin, guess = FALSE) {
    if (requireNamespace("purrr", quietly = TRUE)) {
        check_vin_purrr(vin, guess = guess)
    } else {
        check_vin_no_purrr(vin, guess = guess)
    }
}

#' Verify VIN Validity Using Purrr
#'
#' @inheritParams check_vin
check_vin_purrr <- function(vin, guess = FALSE) {
    # check for length
    purrr::map_lgl(vin, check_vin_format, check_chars = !guess)

    # validate the check digit
    val <- purrr::map_lgl(vin, check_digit_valid, guess = guess)
    return(val)
}

#' Verify VIN Validity Without Purrr
#'
#' @inheritParams check_vin
check_vin_no_purrr <- function(vin, guess = FALSE) {
    # check lengths
    len_ok <- c()
    for (v in vin) {
        len_ok <- append(len_ok, check_vin_format(v, check_chars = !guess))
    }

    # validate the check digit
    res <- c()
    for (v in vin) {
        res <- append(res, check_digit_valid(v, guess = guess))
    }
    return(res)
}
