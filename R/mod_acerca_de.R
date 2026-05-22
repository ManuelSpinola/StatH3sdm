# ============================================================
# mod_acerca_de.R — Información sobre StatH3sdm
# StatH3sdm · StatSuite · Manuel Spínola · ICOMVIS · UNA
# ============================================================

mod_acerca_de_ui <- function(id) {
  ns <- NS(id)
  tagList(
    div(
      class = "py-4 px-3",
      style = "max-width: 780px; margin: 0 auto;",

      h4(
        bs_icon("info-circle", class = "me-2"),
        "Acerca de StatH3sdm",
        style = paste0("color:", colores$primario, "; font-weight:700;")
      ),
      p(class = "text-muted mb-4",
        "StatH3sdm es el m\u00f3dulo de modelado de distribuci\u00f3n de especies ",
        "de StatSuite, desarrollado en el ICOMVIS de la Universidad Nacional, ",
        "Costa Rica. Surge de m\u00e1s de 20 a\u00f1os de ense\u00f1anza de estad\u00edstica ",
        "y ciencia de datos, y de la posibilidad de materializar ese conocimiento ",
        "en aplicaciones interactivas accesibles para estudiantes e investigadores."
      ),

      layout_columns(
        col_widths = c(6, 6),

        card(
          card_header(bs_icon("collection", class = "me-1"),
                      "StatSuite \u2014 Ecosistema completo"),
          card_body(
            tags$ul(
              class = "small",
              tags$li(strong("StatDesign"),  " \u2014 Dise\u00f1o de estudios y muestreo"),
              tags$li(strong("StatFlow"),    " \u2014 Primeros an\u00e1lisis y visualizaci\u00f3n"),
              tags$li(strong("StatGeo"),     " \u2014 An\u00e1lisis espacial y mapas"),
              tags$li(strong("StatMonitor"), " \u2014 Monitoreo poblacional"),
              tags$li(strong("StatModels"),  " \u2014 Modelos estad\u00edsticos"),
              tags$li(strong("StatH3sdm"),   " \u2014 SDM con grillas H3 \u2190 aqu\u00ed")
            )
          )
        ),

        card(
          card_header(bs_icon("box-seam", class = "me-1"),
                      "Ecosistema R utilizado"),
          card_body(
            tags$ul(
              class = "small",
              tags$li(strong("h3sdm"),
                      " \u2014 SDM con grillas hexagonales H3"),
              tags$li(strong("rbiodatacr"),
                      " \u2014 Registros de BiodataCR (Costa Rica)"),
              tags$li(strong("spocc"),
                      " \u2014 GBIF, iNaturalist y otros proveedores"),
              tags$li(strong("terra"),
                      " \u2014 Variables ambientales (raster)"),
              tags$li(strong("sf"),
                      " \u2014 Datos vectoriales y geometr\u00edas"),
              tags$li(strong("leaflet"),
                      " \u2014 Mapas interactivos"),
              tags$li(strong("tidymodels"),
                      " \u2014 Flujo de modelado (parsnip, recipes, workflows)")
            )
          )
        )
      ),

      # Desarrollo
      card(
        class = "mt-3",
        card_header(bs_icon("code-slash", class = "me-1"),
                    "Desarrollo"),
        card_body(
          p(class = "small mb-2",
            bs_icon("person-fill", class = "me-1"),
            strong("Autor:"), " Manuel Sp\u00ednola \u2014 ICOMVIS, ",
            "Universidad Nacional, Costa Rica."),
          p(class = "small mb-2",
            bs_icon("robot", class = "me-1"),
            strong("Asistencia en desarrollo:"), " StatH3sdm fue desarrollado ",
            "con asistencia de ", strong("Claude (Anthropic)"),
            " para la estructura de m\u00f3dulos, interfaz de usuario, ",
            "l\u00f3gica del servidor y contenido did\u00e1ctico."),
          p(class = "small mb-0",
            bs_icon("building", class = "me-1"),
            strong("Instituci\u00f3n:"), " Instituto Internacional en ",
            "Conservaci\u00f3n y Manejo de Vida Silvestre (ICOMVIS), ",
            "Universidad Nacional de Costa Rica.")
        )
      ),

      div(
        class = "alert alert-info small mt-3 mb-0",
        bs_icon("envelope", class = "me-1"),
        "Contacto: ",
        tags$a(href = "mailto:manuel.spinola@una.ac.cr",
               "manuel.spinola@una.ac.cr")
      )
    )
  )
}

mod_acerca_de_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    # sin lógica reactiva
  })
}
