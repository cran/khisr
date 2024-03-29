#' Create an AuthCred
#'
#' Constructor function for objects of class [AuthCred].
#'
#' @param username The KHIS username to be used in API calls
#' @param password The KHIS password to be used in API calls.
#'
#' @return An object of class [AuthCred]
#' @noRd

init_AuthCred <- function(username = NA_character_,
                          password = NULL,
                          base_url = 'https://hiskenya.org/api') {
    AuthCred$new(
        username = username,
        password = password,
        base_url = base_url
    )
}

#' Authorization Credential
#'
#' An `AuthCred` object manages the authorization credentials that make request
#' to the KHIS API server.
#'
#' @details An `AuthCred` should be created through the constructor function
#' [init_AuthCred()], which has more details on the arguments
#'
#' @param config_path Path to a JSON configuration file.
#' @param username The KHIS username.
#' @param password The KHIS password.
#'
#' @noRd
AuthCred <- R6::R6Class('AuthCred', list(
    #' @field  config_path Path to a JSON configuration file.
    config_path = NULL,
    #' @field  username The KHIS username.
    username = NULL,
    #' @field password The KHIS password.
    password = NULL,
    #' @field base_url The URL to the server
    base_url = NULL,

    #' @description Create a new AuthCred
    #' @details For more details on the parameters, see [init_AuthCred()]
    initialize = function(username = NA_character_,
                          password = NULL,
                          base_url = NULL) {

        if (!is_scalar_character(username) || !is.null(password)) {
            khis_abort(c("x" = "username has to be a scalar character."))
        }

        if (!is_scalar_character(base_url) || is_empty(base_url)) {
            khis_abort(c("x" = "base_url has to be a scalar character."))
        }

        self$username <- username
        self$password <- password
        self$base_url <- base_url
    },
    #' @description Set the KHIS username
    #' @param value The KHIS username
    set_username = function(value) {
        self$username <- value
        invisible(self)
    },
    #' @description Get username
    get_username = function() {
        self$username
    },
    #' @description Set the KHIS password
    #' @param value The KHIS password
    set_password = function(value) {
        self$password <- value
        invisible(self)
    },
    #' @description Clear password
    clear_password = function() {
        self$set_password(NULL)
    },
    #' @description Get password
    get_password = function() {
        self$password
    },
    #' @description Get the base URL API
    get_base_url = function() {
        self$base_url
    },
    #' @description Set the KHIS username
    #' @param value The KHIS username
    set_base_url = function(value) {
        if (!is_scalar_character(value) || is_empty(value)) {
            khis_abort(c("x" = "base_url has not been provided"))
        }
        self$base_url <- value
        invisible(self)
    },
    #' @description Report if we have credentials
    has_cred = function() {
        !is.null(self$password) & !is.null(self$username)
    }
))
