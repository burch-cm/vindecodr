#' Check VIN Length and Characters
#'
#' Checks that VINs are 17 characters long and will optionally check that disapllowed
#' characters (I, O, Q) are not present.
#'
#' @param vin A character. Should be a properly formatted Vehicle Identification Number.
#'   Wildcards (e.g., '*') are acceptable.
#' @param check_chars Logical. Should an error be thrown if the VIN contains illegal characters?
#'
#' @return Logical.
#' @export
#'
#' @examples
#' # Random VIN
#' check_vin_format("3VWLL7AJ9BM053541")
#' # With wild card
#' check_vin_format("3VWLL7AJ9BM*53541")
check_vin_format <- function(vin, check_chars = FALSE) {
    vin <- toupper(vin)
    # verify VIN is 17 characters long
    if (nchar(vin) != 17) {
        msg <- paste0("Incorrectly formatted VIN at ",
                      vin, ":\n",
                      "VINs must be 17 characters in length, not ",
                      nchar(vin),
                      " characters.")
        stop(msg)
    }
    # check for illegal chars
    if (check_chars) {
        if (grepl("[IOQ]", vin)) {
            chars <- unlist(strsplit(vin, ''))
            pos <- which(chars %in% c("I", "O", "Q"))
            msg <- paste("In VIN ", vin, ", disallowed character detected at position",
                         as.character(pos),
                         ":",
                         chars[pos],
                         "\n")
            stop(msg)
        }
    }

    return(TRUE)
}
