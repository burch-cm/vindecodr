#' Check for Valid VIN Check Digit
#'
#' Calculates the VIN check digit and compares it to VIN position 9.
#' For US-based VINs, this determines if the VIN is valid.
#' This may not apply to VINs from outside of the United States.
#'
#' @param vin character. The VIN to check. VINs must be compete, i.e. 17 digits
#'     with no wildcards.
#' @param value logical. Should the calculated check digit be returned instead?
#'
#' @return logical. The result of comparing the calculated check digit with the VIN position 9
#' @export
#'
#' @examples
#' check_digit_valid("WDBEA30D3HA391172") # True
#' check_digit_valid
check_digit_valid <- function(vin, value = FALSE) {

    vin_letters <- strsplit(toupper(vin), "")[[1]]
    chk_dgt <- vin_letters[9]
    il_char <- c()
    if (length(vin_letters) != 17) {
        stop(sprintf("Incorrect VIN length: Valid VINs must be 17 digits, not %s."),
             length(vin_letters))
    }
    if ("O" %in% vin_letters) il_char <- c(il_char, "O")
    if ("I" %in% vin_letters) il_char <- c(il_char, "I")
    if ("Q" %in% vin_letters) il_char <- c(il_char, "Q")
    if (length(il_char > 0)) {
        il_char <- paste(il_char, collapse = ", ")
        stop(sprintf("Illegal characters in provided VIN: %s", il_char))
    }

    translit_abc <-
        tibble(letter = LETTERS,
               value = c(1, 2, 3, 4, 5, 6, 7, 8, NA,
                         1, 2, 3, 4, 5, NA, 7, NA, 9,
                         2, 3, 4, 5, 6, 7, 8, 9))
    translit_num <-
        tibble(letter = as.character(c(0:9)),
               value = c(0:9))
    translit_tbl <- rbind(translit_abc, translit_num)
    pos_weights <- c(8, 7, 6, 5, 4, 3, 2, 10, 0, 9, 8, 7, 6, 5, 4, 3, 2)

    transliterate_chr <- function(x) {
        translit_tbl[which(translit_tbl$letter == x), ]$value
    }

    xlit_vin <- purrr::map_dbl(vin_letters, transliterate_chr)
    vin_prod <- xlit_vin * pos_weights
    calc_chk <- as.character(`%%`(sum(vin_prod), 11))
    if (value) return(calc_chk)
    return(calc_chk == chk_dgt)
}

