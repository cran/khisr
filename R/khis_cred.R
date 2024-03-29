# This file is the interface between KHIS credential storage and khis package

# Initialization happens in .onLoad
.auth <- NULL

#' Sets the KHIS Credentials
#'
#' @param config_path An optional parameters that contains the path to
#'   configuration file with username and password.
#' @param username The KHIS username. Can be optional if `config_path` is
#'   already provided
#' @param password The KHIS password. Can be optional if `config_path` is
#'   already provided.
#' @param base_url The base url used for the KHIS instance. The default is NULL
#'   which is the <https://hiskenya.org/api>
#'
#' @family credential functions
#'
#' @return No return value
#'
#' @export
#'
#' @details
#' The credentials can be provided using a configuration file (more secure) or
#' providing `username` and `password` arguments. The `config_path` is considered
#' more secure since credentials will not appear in the code.
#'
#' @examples
#'
#' # Load username and password
#' khis_cred(username = 'khis_username', password = 'PASSWORD')

khis_cred <- function(config_path = NULL,
                      username = NULL,
                      password = NULL,
                      base_url = NULL) {

    if (is.null(config_path) && is.null(username)) {
        khis_abort(
            message = c(
                'x' = 'Missing credentials',
                '!' = 'Please provide either {.field config_path} or {.field username} and {.field password}.'
            ),
            class = 'khis_missing_credentials'
        )
    }

    if (!(is.null(config_path)) && !(is.null(username))) {
        khis_abort(
            message = c(
                "x" = "{.field config_path} and {.field username} cannot be provided together.",
                "!" = "Remove one and try again!"
            ),
            class = 'khis_multiple_credentials',
            config_path = config_path
        )
    }

    additional <- ''

    if (!is.null(config_path)) {
        # loads credentials from secret file
        credentials <- .load_config_file(config_path)
        password <- credentials[["password"]]
        username <- credentials[["username"]]
        #base_url <- credentials[["base_url"]]
        #if (nchar(base_url) == 0) {
        #    base_url = NULL
        #}

        additional <- ' on the configuration file'
    }

    if (!rlang::is_scalar_character(password) || nchar(password) == 0 || !rlang::is_scalar_character(username) || nchar(username) == 0) {
        khis_abort(
            message = c(
                "x" = "Missing credentials",
                "!" = "Please provide both {.field username} and {.field password}{additional}."
            ),
            class = 'khis_missing_credentials'
        )
    }

    .auth$set_username(username)
    .auth$set_password(password)

    if (!is.null(base_url)) {
        .auth$set_base_url(base_url)
    }

    khis_info(c('i' = 'The credentials have been set.'))

    invisible(TRUE)
}

#' @title Load Configuration File
#'
#' @description Loads a JSON configuration file with KHIS credentials to access
#'   a KHIS instance
#' @param config_path Path to the KHIS credentials file
#' @return A parsed list of the configuration file.
#'
#'@noRd

.load_config_file <- function(config_path = NA, call = caller_env()) {
    # Load from a file
    tryCatch({
        data <- jsonlite::fromJSON(config_path)
        if (!is.null(data) && 'credentials' %in% names(data)) {
            return(data[['credentials']])
        }
    }, error = function(e) {
        khis_abort(
            message = c(
                "x" = "Invalid {.field config_path} was provided.",
                "!" = "Check the {.field config_path} and try again!"
            ),

            class = 'khis_invalid_config_path',
            config_path = config_path,
            call = call
        )
    })

    khis_abort(
        message = c(
            "x" = "Invalid {.field config_path} was provided.",
            "!" = "Please check the {.field config_path} file format and try again"
        ),
        class = 'khis_invalid_config_path',
        config_path = config_path,
        call = call
    )
}

#' Authenticate Request with HTTP Basic Authentication
#'
#' This sets the Authorization header for basic authentication using the username and password provided.
#'
#' @param req A request
#'
#' @return A modified HTTP request with authorization header
#'
#' @noRd
#'
#' @examples
#' req <- request("http://example.com") %>%
#'   req_auth_khis_basic("damurka", "PASSWORD")
#'
#' @seealso [httr2]

req_auth_khis_basic <- function(req, arg = caller_arg(req), call = caller_env()) {

    check_required(req, arg, call)

    if (!khis_has_cred()) {
        khis_abort(
            message = c(
                "x" = "Missing credentials",
                "!" = "Please set the credentials by calling {.fun khis_cred}"
            ),
            class = 'khis_missing_credentials',
            call = call
        )
    }
    httr2::req_auth_basic(req, .auth$username, .auth$password)
}

#' Are There Credentials on Hand?
#'
#' @family credential functions
#'
#' @return a boolean value indicating if the credentials are available
#'
#' @export
#'
#' @examples
#'
#' # Set the credentials
#' khis_cred(username = 'KHIS username', password = 'KHIS password')
#'
#' # Check if credentials available. Expect TRUE
#' khis_has_cred()
#'
#' # Clear credentials
#' khis_cred_clear()
#'
#' # Check if credentials available. Expect FALSE
#' khis_has_cred()

khis_has_cred <- function() {
    .auth$has_cred()
}

#' Clear the Credentials from Memory
#'
#' @family credential functions
#'
#' @return No return value
#' @export
#'
#' @examples
#' khis_cred_clear()

khis_cred_clear <- function() {
    .auth$set_username(NULL)
    .auth$clear_password()
    invisible(TRUE)
}

#' Produces the Configured Username
#'
#' @family credential functions
#'
#' @return the username of the user credentials
#' @export
#'
#' @examples
#'
#' # Set the credentials
#' khis_cred(username = 'KHIS username', password = 'KHIS password')
#'
#' # View the username expect 'KHIS username'
#' khis_username()
#'
#' # Clear credentials
#' khis_cred_clear()
#'
#' # View the username expect 'NULL'
#' khis_username()

khis_username <- function() {
    .auth$get_username()
}

#' Produces the Configured KHIS API Base URI
#'
#' @return the KHIS base URI
#' @export
#'
#' @examples
#'
#' # Set the credentials
#' khis_cred(username = 'KHIS username', password = 'KHIS password')
#'
#' # View the username expect 'KHIS username'
#' khis_base_url()

khis_base_url <- function() {
    base_url <- .auth$get_base_url()
    if (is_empty(base_url) || nchar(base_url) == 0) {
        khis_abort(c('x' = 'The base url has not been set.'))
    }
    return(base_url)
}


#' Internal Credentials
#'
#' Internal function used to provide credentials for the testing and documentation
#'   environment
#'
#' @param account The environment to provide credentials. `"docs"` or `"testing"`
#'
#' @return No return value
#' @noRd

khis_cred_internal <- function(account = c('docs', 'testing')) {
    account <- arg_match(account)
    can_decrypt <- secret_has_key('KHIS_KEY')
    online <- !is.null(curl::nslookup('hiskenya.org', error = FALSE))
    if (!can_decrypt || !online) {
        khis_abort(
            message = c(
                "Set credential unsuccessful.",
                if (!can_decrypt) {
                    c("x" = "Can't decrypt the {.field {account}} credentials.")
                },
                if (!online) {
                    c("x" = "We don't appear to be online. Or maybe the KHIS is down?")
                }
            ),
            class = 'khis_cred_internal_error',
            can_decrypt = can_decrypt,
            online = online
        )
    }

    filename <- str_glue("khis-{account}.json")
    khis_cred(
        secret_decrypt_json(
            system.file('secret', filename, package = 'khisr'),
            'KHIS_KEY'
        )
    )

    invisible(TRUE)
}

#' Set Credentials for Documentation
#'
#' @noRd

khis_cred_docs <- function() {
    khis_cred_internal('docs')
}

#' Set Credentials for Testing Environment
#'
#' @noRd

khis_cred_testing <- function() {
    khis_cred_internal('testing')
}

