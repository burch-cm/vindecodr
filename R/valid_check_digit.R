#' Check for Valid VIN Check Digit
#'
#' Calculates the VIN check digit and compares it to VIN position 9.
#' For US-based VINs, this determines if the VIN is valid.
#' This may not apply to VINs from outside of the United States.
#'
#' @param vin character. The VIN to check. VINs must be compete, i.e. 17 digits
#'     with no wildcards.
#' @param value logical. Should the calculated check digit be returned instead?
#' @param guess logical. Should incorrect characters be replaced by the best
#'     guess at corrected characters?
#'     O -> 0
#'     I -> 1
#'     Q -> 0
#'
#' @return If `value` is `FALSE`, a logical value is returned.
#'     If `value` is `TRUE`, a character is returned.
#' @export
#'
#' @examples
#' valid_check_digit("WDBEA30D3HA391172") # True
#' valid_check_digit("WDBEA30D3HA391172", value = TRUE)
#' valid_check_digit("WDBEA3QD3HA39I172", guess = TRUE)
valid_check_digit <- function(vin, value = FALSE, guess = FALSE) {

    vin_letters <- strsplit(toupper(vin), "")[[1]]
    chk_dgt <- vin_letters[9]

    # guess at incorrect characters
    if (guess) {
        vin_letters <- swap_map(vin_letters, c("I", "O", "Q"), c("1", "0", "0"))
    }

    translit_tbl <-
        data.frame(letter = c(LETTERS, c(0:9)),
                   value  = c(c(1, 2, 3, 4, 5, 6, 7, 8, NA,
                                1, 2, 3, 4, 5, NA, 7, NA, 9,
                                2, 3, 4, 5, 6, 7, 8, 9),
                              c(0:9)))
    # weights defined by US DOT
    pos_weights <- c(8, 7, 6, 5, 4, 3, 2, 10, 0, 9, 8, 7, 6, 5, 4, 3, 2)

    transliterate_chr <- function(x) {
        translit_tbl[which(translit_tbl$letter == x), ]$value
    }
    # transliterate vin
    if (requireNamespace("purrr", quietly = TRUE)) {
        xlit_vin <- purrr::map_dbl(vin_letters, transliterate_chr)
    } else {
        xlit_vin <- c()
        for (ltr in vin_letters) {
            xlit_vin <- append(xlit_vin, transliterate_chr(ltr))
        }
    }
    # apply vin weights
    vin_prod <- xlit_vin * pos_weights
    # calculate check digit
    calc_chk <- as.character(`%%`(sum(vin_prod), 11))
    if (value) return(calc_chk)
    return(calc_chk == chk_dgt)
}

