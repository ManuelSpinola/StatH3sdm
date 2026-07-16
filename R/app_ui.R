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
  
  golem::add_resource_path(
    "www",
    app_sys("app/www")
  )
  
  tagList(
    tags$head(
      # --- Metadatos base ---
      tags$meta(charset = "utf-8"),
      tags$meta(name = "viewport", content = "width=device-width, initial-scale=1"),
      tags$link(rel = "icon", href = "www/hexsticker_StatH3sdm.png"),
      
      # --- Open Graph (Classroom, WhatsApp, Slack, etc.) ---
      tags$meta(property = "og:title", content = "StatH3sdm"),
      tags$meta(property = "og:description",
                content = "Modelado de distribuci\u00f3n de especies con grillas H3 - StatSuite"),
      tags$meta(property = "og:image",
                content = "https://019eae1f-30c7-a9d8-478c-3258bb3a7b26.share.connect.posit.cloud/www/hexsticker_StatH3sdm.png"),
      tags$meta(property = "og:type", content = "website"),
      
      # --- Twitter/X Card (respaldo para algunos unfurlers) ---
      tags$meta(name = "twitter:card", content = "summary"),
      tags$meta(name = "twitter:title", content = "StatH3sdm"),
      tags$meta(name = "twitter:image",
                content = "https://019eae1f-30c7-a9d8-478c-3258bb3a7b26.share.connect.posit.cloud/www/hexsticker_StatH3sdm.png")
    ),
    
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
      window_title = "StatH3sdm",
      theme  = tema_app,
      lang   = "es",
      
      # ── Módulo principal ─────────────────────────────────
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
        "Manuel Spínola · ICOMVIS · Universidad Nacional · Costa Rica")
  )
}