CENSUS_KEY_ENV_VAR <- "CENSUS_API_KEY"

#' Get the current value of the local Census API key
#'
#' This corresponds to `Sys.getenv("CENSUS_API_KEY")` in order to be compatible
#' with the [tidycensus](https://walker-data.com/tidycensus/reference/census_api_key.html)
#' package.
#'
#' @return a hexadecimal API token, or an empty string
#' @seealso [tidycensus::census_api_key()]
#' @export
#'
#' @concept API key
#' @examples
#' api_key_value()
#'
api_key_value <- function() {
    Sys.getenv(CENSUS_KEY_ENV_VAR)
}

#' Check if the local environment contains an expected constant defining an API key
#'
#' @return TRUE if the key exists, FALSE otherwise
#' @export
#'
#' @concept API key
#' @examples
#' api_key_is_set()
#'
api_key_is_set <- function() {
    api_key_value() != ""
}

.api_key_menu <- function() {
    cat("What would you like to do?")
    utils::menu(c(
        "Sign up for a Census API key",
        "Install your API key in your personal R environment file",
        "Quit"
    ))
}

.api_key_prompt <- function() {
    cat("Please type or paste the key below")
    new_key <- readLines(n = 1) |> stringr::str_squish()
}

.api_key_set <- function(new_key){
    names(new_key) <- CENSUS_KEY_ENV_VAR
    personal_environment_file <- file.path(Sys.getenv("HOME"),
                                           ".Renviron")
    key_setting <- paste0(CENSUS_KEY_ENV_VAR, "=", "\"", new_key, "\"")
    cat(key_setting, file = personal_environment_file, sep = "\n", append = TRUE)
    do.call(Sys.setenv, as.list(new_key))
}

#' Guide a new user at setting up a Census API key
#'
#' This only works in interactive mode. It checks if a key already exists in the
#' environment. The key corresponds to `Sys.getenv("CENSUS_API_KEY")` in order
#' to be compatible with the
#' [tidycensus](https://walker-data.com/tidycensus/reference/census_api_key.html)
#' package. If the key doesn't exist then it prompts you to either go to the
#' Census website (it will open a browser window for you) or to enter in your
#' API key (by typing or pasting). It then sets the value in your current
#' environment and saves it to the .Renviron file in the user's HOME directory.
#'
#' @return a numeric status: 0 for success, 1 for quitting, 2 if the key exists.
#' @seealso [tidycensus::census_api_key()]
#' @export
#'
#' @concept API key
#' @examples
#' api_key_setup()
#'
api_key_setup <- function() {
    if (!interactive()) {
        invisible(return(0))
    }
    while (TRUE) {
        current_api_key <- api_key_value()

        if (api_key_is_set()) {
            cat("Your current key is", current_api_key)
            return(invisible(0))
        }
        next_step <- .api_key_menu()

        if (next_step == 1) {
            utils::browseURL("http://api.census.gov/data/key_signup.html")
        } else if (next_step == 2) {
            .api_key_set(.api_key_prompt())
        } else {
            return(invisible(1))
        }
    }
}
