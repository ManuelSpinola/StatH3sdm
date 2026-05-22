#' h3sdm UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_h3sdm_ui <- function(id) {
  ns <- NS(id)
  tagList(
 
  )
}
    
#' h3sdm Server Functions
#'
#' @noRd 
mod_h3sdm_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_h3sdm_ui("h3sdm_1")
    
## To be copied in the server
# mod_h3sdm_server("h3sdm_1")
