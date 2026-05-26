#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import bslib
#' @import bsicons
#' @import shinyjs
#' @noRd
app_ui <- function(request) {
  tagList(
    golem_add_external_resources(),
    tags$style(HTML("
      body { margin-bottom: 36px; }
      .footer-fixed {
        position: fixed;
        bottom: 0;
        left: 0;
        right: 0;
        z-index: 1000;
        background-color: #1170AA;
        color: #ffffff;
        text-align: center;
        font-size: 0.78rem;
        padding: 6px 0;
        border-top: 1px solid #0d5a8a;
      }
    ")),
    bslib::page_navbar(
      header = shinyjs::useShinyjs(),
      title  = div(
        style = "display: flex; align-items: center; gap: 10px; margin-top: 4px;",
        img(src = "www/hexsticker_StatH3sdm.png", height = "38px"),
        span("StatH3sdm", style = "font-weight: 600;")
      ),
      theme  = tema_app,
      lang   = "es",

      # ── M\u00f3dulo principal ─────────────────────────────────
      bslib::nav_panel(
        title = "SDM",
        icon  = bsicons::bs_icon("globe"),
        mod_h3sdm_ui("h3sdm")
      ),

      bslib::nav_spacer(),

      bslib::nav_panel(
        title = "Acerca de",
        icon  = bsicons::bs_icon("info-circle"),
        mod_acerca_de_ui("acerca_de")
      ),

      bslib::nav_item(
        tags$span(class = "text-white-50 small", "StatH3sdm v0.1")
      )
    ),
    div(class = "footer-fixed",
        "Manuel Sp\u00ednola \u00b7 ICOMVIS \u00b7 Universidad Nacional \u00b7 Costa Rica")
  )
}

#' Add external Resources to the Application
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )
  tags$head(
    favicon(),
    bundle_resources(
      path      = app_sys("app/www"),
      app_title = "StatH3sdm"
    )
  )
}
