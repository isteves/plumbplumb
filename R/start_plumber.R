check_output <- function(trml, cmd_snippet) {
    result <- rstudioapi::terminalBuffer(trml)
    line_cmd <- which(grepl(cmd_snippet, result))

    count <- 0
    while(length(line_cmd) == 0 && count < 10){
        Sys.sleep(2)
        result <- rstudioapi::terminalBuffer(trml)
        line_cmd <- which(grepl(cmd_snippet, result))
        count <- count + 1
    }
    if(length(line_cmd) == 0) stop("Check terminal")
    msg <- result[seq(utils::tail(line_cmd, 1),
                      length(result))]
    message(paste(msg, collapse = "\n"))
    invisible(msg)
}

#' Start plumber
#'
#' Runs a plumber API in a new terminal for interactive testing.
#'
#' @param path Path to the plumber file
#' @param port Port
#'
#' @import rlang
#' @import rstudioapi
#' @import glue glue
#'
#' @export

start_plumber <- function(path, port) {
    stopifnot(is.character(path))
    stopifnot(is.character(port)|is.numeric(port))

    trml <- rstudioapi::terminalCreate(show = FALSE)

    # kill any previous plumber sessions
    if(!is.null(.state[["trml"]])) {
        kill_plumber()
    }

    .state[["trml"]] <- trml
    message(glue::glue('New terminal created: {trml}'))

    rstudioapi::terminalSend(trml, "R\n")
    Sys.sleep(2)
    cmd <- glue::glue('plumber::plumb("{path}")$run(port = {port})')
    rstudioapi::terminalSend(trml, paste(cmd, "\n"))

    check_output(trml, "Starting server to listen on port")

    invisible(trml)
}

#' Kill plumber
#'
#' By default, kills any terminal sessions previously started by \link{start_plumber}. To kill another terminal session, check current open terminals with \link[rstudioapi]{terminalList}.
#'
#' @param trml_id Terminal ID to kill
#'
#' @export
#'

kill_plumber <- function(trml_id = NULL) {
    trml <- trml_id %||% .state[["trml"]]
    if(is.null(trml)) stop("Please kill terminals manually.")
    rstudioapi::terminalKill(trml)
    message("Terminal killed: ", trml)
    .state[["trml"]] <- NULL
}
