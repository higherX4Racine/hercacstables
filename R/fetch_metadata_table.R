#' Fetch metadata about a specific ACS data set from the Census API.
#'
#' This function downloads a large JSON object and parses it into a tibble.
#'
#' @param .info_type See `info_url`.
#' @param .year See `info_url`.
#' @param .year_span See `info_url`.
#'
#' @return A tibble.
#'
#' @seealso `info_url`
#' @export
fetch_metadata_table <- function(.info_type, .year, .year_span) {
  .response <- info_url(.info_type, .year, .year_span) %>%
    httr::GET() %>%
    httr::stop_for_status()

  .j <- .response %>%
    httr::content("parse") %>%
    purrr::pluck(1)

  .x <- .j %>%
      ragged_list_to_tibble() %>%
      dplyr::rename_with(
          ~ stringr::str_to_title(stringr::str_trim(.))
      )

  if (.info_type == "groups") {
    .wrangle_groups(.x)
  } else if (.info_type == "variables") {
    .wrangle_variables(.x)
  } else {
    .x
  }
}

.wrangle_groups <- function(.x) {
  .x %>%
    dplyr::select(tidyselect::any_of(c(
      Group = "Name",
      "Universe",
      "Description"
    ))) %>%
    dplyr::arrange(
      .data$Group
    )
}

.wrangle_variables <- function(.x) {
  .x %>%
    dplyr::select(tidyselect::any_of(c(
      "Group",
      Variable = "Id",
      "Label"
    ))) %>%
    dplyr::filter(
      stringr::str_detect(.data$Group,
        ",|N/A",
        negate = TRUE
      )
    ) %>%
    dplyr::arrange(
      .data$Variable
    )
}
