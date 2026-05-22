#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  mod_h3sdm_server("h3sdm")
  mod_acerca_de_server("acerca_de")
}
