#' Replace a Letter in a Character Vector
#'
#' @param .string character vector
#' @param .target character to replace
#' @param .replacement character to substitute
#'
#' @return the modified string
#'
swap_letter <- function(.string, .target, .replacement) {
    .string[which(.string == .target)] <- .replacement
    .string
}

#' Replace Multiple Letters in a Character Vector
#'
#' @param .string character vector
#' @param .targets characters to replace
#' @param .replacements characters to substitute
#'
#' @return the modified string
#'
swap_map <- function(.string, .targets, .replacements) {
    if (length(.targets) != length(.replacements)) {
        stop("Target and replacement vectors must be of the same length.")
    }
    for (i in seq_along(.targets)) {
        .string <- swap_letter(.string, .targets[i], .replacements[i])
    }
    .string
}

