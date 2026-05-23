# ============================================================
# mod_h3sdm.R — Módulo principal StatH3sdm
# SDM con grillas hexagonales H3
# StatH3sdm · StatSuite · Manuel Spínola · ICOMVIS · UNA
# ============================================================

mod_h3sdm_ui <- function(id) {
  ns <- NS(id)
  tagList(
    div(
      # Encabezado
      class = "py-3 px-2",
      h4(
        bsicons::bs_icon("globe", class = "me-2"),
        "Modelado de Distribuci\u00f3n de Especies con H3",
        style = paste0("color:", colores$primario, "; font-weight:700;")
      ),
      p(class = "text-muted mb-0",
        "Descarga registros de ocurrencia, genera grillas hexagonales H3, ",
        "extrae variables ambientales y ajusta modelos de distribuci\u00f3n de especies. ",
        "Motor: ", strong("h3sdm"), " \u00b7 datos: ",
        strong("GBIF, iNaturalist, BiodataCR"),
        " \u00b7 modelos: ", strong("tidymodels"), "."
      )
    ),

    bslib::navset_tab(

      # ══════════════════════════════════════════════════════
      # PESTAÑA 1: ¿Qué es?
      # ══════════════════════════════════════════════════════
      bslib::nav_panel(
        title = tagList(bsicons::bs_icon("question-circle", class = "me-1"),
                        "\u00bfQu\u00e9 es?"),
        div(
          class = "p-3",

          # ── Intro ────────────────────────────────────────
          div(
            class = "alert mb-4",
            style = paste0("background:", colores$fondo,
                           "; border-left: 4px solid ", colores$primario, ";"),
            h5(style = paste0("color:", colores$primario, "; font-weight:700;"),
               bsicons::bs_icon("info-circle-fill", class = "me-2"),
               "\u00bfQu\u00e9 es StatH3sdm?"),
            p(class = "mb-0",
              "StatH3sdm es una aplicaci\u00f3n interactiva para el ",
              strong("modelado de distribuci\u00f3n de especies (SDM)"),
              " basada en ", strong("grillas hexagonales H3"),
              ". Permite descargar registros de ocurrencia, extraer variables ",
              "ambientales y del paisaje, generar conjuntos de datos de ",
              "presencia/pseudoausencia y ajustar modelos predictivos, todo ",
              "dentro de un flujo de trabajo reproducible en R.")
          ),

          # ── 2x2 grid de cards ─────────────────────────────
          bslib::layout_columns(
            col_widths = c(6, 6),
            fill = FALSE,

            # Card 1: ¿Qué son los índices H3?
            bslib::card(
              class = "mb-4",
              bslib::card_header(
                bsicons::bs_icon("hexagon-fill", class = "me-1"),
                "\u00bfQu\u00e9 son los \u00edndices espaciales H3?"
              ),
              bslib::card_body(
                p(class = "mb-2",
                  "H3 es un sistema de ", strong("\u00edndices espaciales jer\u00e1rquicos"),
                  " basado en una grilla global de hex\u00e1gonos, desarrollado por ",
                  strong("Uber Technologies"), " y ampliamente adoptado en ",
                  "an\u00e1lisis espacial, ecolog\u00eda y ciencia de datos geoespaciales."),
                p(class = "mb-2",
                  "Cada hex\u00e1gono tiene un ", strong("\u00edndice \u00fanico"),
                  " (H3 address) que lo identifica en cualquier ",
                  "parte del mundo, a cualquier resoluci\u00f3n. El sistema tiene ",
                  strong("16 niveles de resoluci\u00f3n"),
                  " (0 = muy grueso, 15 = muy fino), lo que permite ",
                  "trabajar a diferentes escalas con la misma estructura."),
                p(class = "mb-0",
                  "En h3sdm, cada hex\u00e1gono funciona como una unidad de muestreo: ",
                  "se le asigna la presencia o ausencia de la especie y se extraen ",
                  "las variables ambientales y del paisaje ", em("dentro"),
                  " de ese hex\u00e1gono.")
              )
            ),

            # Card 2: Resoluciones H3
            bslib::card(
              class = "mb-4",
              bslib::card_header(
                bsicons::bs_icon("table", class = "me-1"),
                "Resoluciones H3 \u2014 \u00e1reas promedio"
              ),
              bslib::card_body(
                p(class = "small text-muted mb-2",
                  "Para SDM se recomiendan resoluciones 5\u20138 seg\u00fan la escala del estudio."),
                tags$table(
                  class = "table table-sm small mb-0",
                  tags$thead(
                    style = paste0("background:", colores$primario, "; color:#fff;"),
                    tags$tr(
                      tags$th("Res"),
                      tags$th(style = "text-align:right;", "\u00c1rea prom. (km\u00b2)"),
                      tags$th("Uso t\u00edpico")
                    )
                  ),
                  tags$tbody(
                    tags$tr(tags$td("4"),
                            tags$td(style="text-align:right;font-family:monospace;", "1,770.3"),
                            tags$td("Pa\u00eds / gran regi\u00f3n")),
                    tags$tr(style = paste0("background:", colores$fondo, ";"),
                            tags$td("5"),
                            tags$td(style="text-align:right;font-family:monospace;", "252.9"),
                            tags$td("Paisaje amplio")),
                    tags$tr(tags$td("6"),
                            tags$td(style="text-align:right;font-family:monospace;", "36.1"),
                            tags$td("Paisaje local")),
                    tags$tr(style = paste0("background:", colores$fondo, ";"),
                            tags$td("7"),
                            tags$td(style="text-align:right;font-family:monospace;", "5.2"),
                            tags$td("SDM fino \u2605")),
                    tags$tr(tags$td("8"),
                            tags$td(style="text-align:right;font-family:monospace;", "0.74"),
                            tags$td("Escala de sitio")),
                    tags$tr(style = paste0("background:", colores$fondo, ";"),
                            tags$td("9"),
                            tags$td(style="text-align:right;font-family:monospace;", "0.11"),
                            tags$td("Alta resoluci\u00f3n"))
                  )
                ),
                p(class = "small text-muted mt-2 mb-0",
                  bsicons::bs_icon("info-circle", class = "me-1"),
                  "\u00c1reas calculadas con modelo esf\u00e9rico WGS84/EPSG:4326. ",
                  "Fuente: ", tags$a(href="https://h3geo.org/docs/core-library/restable/",
                                     target="_blank", "h3geo.org"), ".")
              )
            ),

            # Card 3: Ventajas H3
            bslib::card(
              class = "mb-4",
              bslib::card_header(
                bsicons::bs_icon("hexagon-fill", class = "me-1",
                                 style = paste0("color:", colores$primario)),
                "H3 (hex\u00e1gonos)"
              ),
              bslib::card_body(
                div(class = "d-flex gap-2 mb-2",
                  bsicons::bs_icon("check-circle-fill",
                                   style = paste0("color:", colores$exito),
                                   class = "flex-shrink-0 mt-1"),
                  p(class = "small mb-0",
                    strong("Pol\u00edgonos reales"),
                    " \u2014 cada unidad es un hex\u00e1gono con \u00e1rea y forma definidas, ",
                    "no solo un punto en el espacio.")
                ),
                div(class = "d-flex gap-2 mb-2",
                  bsicons::bs_icon("check-circle-fill",
                                   style = paste0("color:", colores$exito),
                                   class = "flex-shrink-0 mt-1"),
                  p(class = "small mb-0",
                    strong("Extracci\u00f3n dentro del hex\u00e1gono"),
                    " \u2014 proporci\u00f3n de cobertura boscosa, NDVI promedio, ",
                    "m\u00e9tricas de paisaje dentro de cada celda.")
                ),
                div(class = "d-flex gap-2 mb-2",
                  bsicons::bs_icon("check-circle-fill",
                                   style = paste0("color:", colores$exito),
                                   class = "flex-shrink-0 mt-1"),
                  p(class = "small mb-0",
                    strong("Escalable"),
                    " \u2014 cambiar la resoluci\u00f3n es instant\u00e1neo; el mismo flujo ",
                    "funciona a escala de pa\u00eds o de sitio.")
                ),
                div(class = "d-flex gap-2 mb-2",
                  bsicons::bs_icon("check-circle-fill",
                                   style = paste0("color:", colores$exito),
                                   class = "flex-shrink-0 mt-1"),
                  p(class = "small mb-0",
                    strong("Distancias uniformes"),
                    " \u2014 todos los vecinos est\u00e1n a la misma distancia del centro.")
                ),
                div(class = "d-flex gap-2 mb-0",
                  bsicons::bs_icon("check-circle-fill",
                                   style = paste0("color:", colores$exito),
                                   class = "flex-shrink-0 mt-1"),
                  p(class = "small mb-0",
                    strong("\u00cdndice \u00fanico global"),
                    " \u2014 facilita combinar datos de diferentes fuentes y estudios.")
                )
              )
            ),

            # Card 4: Métodos tradicionales
            bslib::card(
              class = "mb-4",
              bslib::card_header(
                bsicons::bs_icon("grid", class = "me-1",
                                 style = "color:#A3ACB9;"),
                "M\u00e9todos tradicionales (puntos / grillas regulares)"
              ),
              bslib::card_body(
                div(class = "d-flex gap-2 mb-2",
                  bsicons::bs_icon("x-circle-fill",
                                   style = paste0("color:", colores$peligro),
                                   class = "flex-shrink-0 mt-1"),
                  p(class = "small mb-0",
                    strong("Puntos sin \u00e1rea"),
                    " \u2014 los registros son coordenadas sin representaci\u00f3n ",
                    "espacial expl\u00edcita.")
                ),
                div(class = "d-flex gap-2 mb-2",
                  bsicons::bs_icon("x-circle-fill",
                                   style = paste0("color:", colores$peligro),
                                   class = "flex-shrink-0 mt-1"),
                  p(class = "small mb-0",
                    strong("Extracci\u00f3n solo en el pixel"),
                    " \u2014 variables ambientales en un punto, sin considerar ",
                    "la heterogeneidad dentro de la unidad.")
                ),
                div(class = "d-flex gap-2 mb-2",
                  bsicons::bs_icon("x-circle-fill",
                                   style = paste0("color:", colores$peligro),
                                   class = "flex-shrink-0 mt-1"),
                  p(class = "small mb-0",
                    strong("Grillas cuadradas con sesgo"),
                    " \u2014 las esquinas est\u00e1n m\u00e1s lejos del centro que los lados.")
                ),
                div(class = "d-flex gap-2 mb-2",
                  bsicons::bs_icon("x-circle-fill",
                                   style = paste0("color:", colores$peligro),
                                   class = "flex-shrink-0 mt-1"),
                  p(class = "small mb-0",
                    strong("Resoluci\u00f3n fija"),
                    " \u2014 cambiar la resoluci\u00f3n requiere reprocesar todos los datos.")
                ),
                div(class = "d-flex gap-2 mb-0",
                  bsicons::bs_icon("x-circle-fill",
                                   style = paste0("color:", colores$peligro),
                                   class = "flex-shrink-0 mt-1"),
                  p(class = "small mb-0",
                    strong("Sin \u00edndice est\u00e1ndar"),
                    " \u2014 grillas personalizadas no son comparables entre estudios.")
                )
              )
            )
          ),

          # ── Flujo de trabajo ──────────────────────────────
          bslib::card(
            class = "mb-0",
            bslib::card_header(
              bsicons::bs_icon("diagram-3", class = "me-1"),
              "Flujo de trabajo en StatH3sdm"
            ),
            bslib::card_body(
              bslib::layout_columns(
                col_widths = c(4, 4, 4),
                fill = FALSE,

                # Columna 1
                div(
                  div(class = "d-flex gap-2 mb-3",
                    div(class = "badge rounded-pill",
                        style = paste0("background:", colores$primario,
                                       "; font-size:0.85rem; min-width:28px;"),
                        "1"),
                    div(
                      p(class = "small fw-bold mb-0", "\u00c1rea de inter\u00e9s"),
                      p(class = "small text-muted mb-0",
                        "Define el AOI dibuj\u00e1ndolo en el mapa o cargando un archivo.")
                    )
                  ),
                  div(class = "d-flex gap-2 mb-3",
                    div(class = "badge rounded-pill",
                        style = paste0("background:", colores$primario,
                                       "; font-size:0.85rem; min-width:28px;"),
                        "2"),
                    div(
                      p(class = "small fw-bold mb-0", "Registros de ocurrencia"),
                      p(class = "small text-muted mb-0",
                        "Descarga desde GBIF, iNaturalist, BiodataCR o carga tu propio archivo.")
                    )
                  ),
                  div(class = "d-flex gap-2 mb-0",
                    div(class = "badge rounded-pill",
                        style = paste0("background:", colores$primario,
                                       "; font-size:0.85rem; min-width:28px;"),
                        "3"),
                    div(
                      p(class = "small fw-bold mb-0", "Grilla H3"),
                      p(class = "small text-muted mb-0",
                        "Genera la grilla hexagonal a la resoluci\u00f3n deseada.")
                    )
                  )
                ),

                # Columna 2
                div(
                  div(class = "d-flex gap-2 mb-3",
                    div(class = "badge rounded-pill",
                        style = paste0("background:", colores$acento,
                                       "; font-size:0.85rem; min-width:28px;"),
                        "4"),
                    div(
                      p(class = "small fw-bold mb-0", "Variables ambientales"),
                      p(class = "small text-muted mb-0",
                        "Carga rasters de variables clim\u00e1ticas y del paisaje.")
                    )
                  ),
                  div(class = "d-flex gap-2 mb-3",
                    div(class = "badge rounded-pill",
                        style = paste0("background:", colores$acento,
                                       "; font-size:0.85rem; min-width:28px;"),
                        "5"),
                    div(
                      p(class = "small fw-bold mb-0", "Presencias / Pseudoausencias"),
                      p(class = "small text-muted mb-0",
                        "Genera el dataset con h3sdm_pa() y extrae predictores.")
                    )
                  ),
                  div(class = "d-flex gap-2 mb-0",
                    div(class = "badge rounded-pill",
                        style = paste0("background:", colores$acento,
                                       "; font-size:0.85rem; min-width:28px;"),
                        "6"),
                    div(
                      p(class = "small fw-bold mb-0", "Ajustar modelo"),
                      p(class = "small text-muted mb-0",
                        "Elige el algoritmo y ajusta con validaci\u00f3n cruzada espacial.")
                    )
                  )
                ),

                # Columna 3
                div(
                  div(class = "d-flex gap-2 mb-3",
                    div(class = "badge rounded-pill",
                        style = paste0("background:", colores$secundario,
                                       "; font-size:0.85rem; min-width:28px;"),
                        "7"),
                    div(
                      p(class = "small fw-bold mb-0", "Diagn\u00f3stico"),
                      p(class = "small text-muted mb-0",
                        "Eval\u00faa m\u00e9tricas, curva ROC e importancia de variables.")
                    )
                  ),
                  div(class = "d-flex gap-2 mb-3",
                    div(class = "badge rounded-pill",
                        style = paste0("background:", colores$secundario,
                                       "; font-size:0.85rem; min-width:28px;"),
                        "8"),
                    div(
                      p(class = "small fw-bold mb-0", "Predicci\u00f3n"),
                      p(class = "small text-muted mb-0",
                        "Genera el mapa de probabilidad de presencia.")
                    )
                  ),
                  div(class = "d-flex gap-2 mb-0",
                    div(class = "badge rounded-pill",
                        style = paste0("background:", colores$secundario,
                                       "; font-size:0.85rem; min-width:28px;"),
                        "9"),
                    div(
                      p(class = "small fw-bold mb-0", "C\u00f3digo R"),
                      p(class = "small text-muted mb-0",
                        "Exporta el c\u00f3digo R reproducible de todo el an\u00e1lisis.")
                    )
                  )
                )
              )
            )
          )
        )
      ), # /PESTAÑA 1

      # ══════════════════════════════════════════════════════
      # PESTAÑA 2: Área de interés
      # ══════════════════════════════════════════════════════
      bslib::nav_panel(
        title = tagList(bsicons::bs_icon("map", class = "me-1"),
                        "\u00c1rea de inter\u00e9s"),
        div(
          class = "p-3",
          p(class = "small text-muted mb-3",
            "Define el \u00e1rea de inter\u00e9s (AOI) dibuj\u00e1ndola en el mapa ",
            "o cargando un archivo espacial. El AOI delimita la zona de ",
            "descarga de registros y de generaci\u00f3n de la grilla H3."),

          bslib::layout_columns(
            col_widths = c(4, 8),
            fill = FALSE,

            # Panel izquierdo — opciones
            div(
              bslib::card(
                class = "mb-3",
                bslib::card_header(
                  bsicons::bs_icon("pencil-square", class = "me-1"),
                  "Dibujar en el mapa"
                ),
                bslib::card_body(
                  p(class = "small text-muted mb-2",
                    "En el mapa, usa la barra de herramientas para dibujar ",
                    "un pol\u00edgono o rect\u00e1ngulo. Haz clic para definir los ",
                    "v\u00e9rtices y doble clic para cerrar el AOI."),
                  uiOutput(ns("info_aoi_dibujado"))
                )
              ),

              bslib::card(
                class = "mb-3",
                bslib::card_header(
                  bsicons::bs_icon("upload", class = "me-1"),
                  "Cargar archivo espacial"
                ),
                bslib::card_body(
                  fileInput(
                    ns("archivo_aoi"),
                    label       = NULL,
                    accept      = c(".gpkg", ".geojson", ".json",
                                    ".kml", ".zip"),
                    buttonLabel = "Buscar\u2026",
                    placeholder = "GeoPackage, GeoJSON, Shapefile (.zip), KML"
                  ),
                  p(class = "small text-muted mb-0",
                    bsicons::bs_icon("info-circle", class = "me-1"),
                    "Shapefile: comprimir los archivos .shp, .dbf, .shx en un .zip.")
                )
              ),

              bslib::card(
                class = "mb-3",
                bslib::card_header(
                  bsicons::bs_icon("info-circle", class = "me-1"),
                  "AOI activo"
                ),
                bslib::card_body(
                  uiOutput(ns("resumen_aoi"))
                )
              ),

              actionButton(
                ns("limpiar_aoi"),
                "Limpiar AOI",
                class = "btn-outline-secondary btn-sm w-100",
                icon  = icon("trash")
              )
            ),

            # Panel derecho — mapa
            bslib::card(
              bslib::card_header(
                bsicons::bs_icon("globe", class = "me-1"),
                "Mapa"
              ),
              bslib::card_body(
                class = "p-0",
                leaflet::leafletOutput(ns("mapa_aoi"), height = "500px")
              )
            )
          )
        )
      ),

      # ══════════════════════════════════════════════════════
      # PESTAÑA 3: Registros
      # ══════════════════════════════════════════════════════
      bslib::nav_panel(
        title = tagList(bsicons::bs_icon("pin-map", class = "me-1"),
                        "Registros"),
        div(
          class = "p-3",
          p(class = "small text-muted mb-3",
            "Descarga registros de ocurrencia de la especie dentro del AOI. ",
            "Puedes combinar varias fuentes o cargar tus propios registros."),

          bslib::layout_columns(
            col_widths = c(4, 8),
            fill = FALSE,

            # Panel izquierdo
            div(
              bslib::card(
                class = "mb-3",
                bslib::card_header(bsicons::bs_icon("search", class = "me-1"),
                                   "Especie"),
                bslib::card_body(
                  textInput(ns("especie"),
                            label = "Nombre cient\u00edfico:",
                            placeholder = "Ej. Puma concolor"),
                  p(class = "small text-muted mb-0",
                    bsicons::bs_icon("info-circle", class = "me-1"),
                    "Usa el nombre cient\u00edfico completo para mejores resultados.")
                )
              ),

              bslib::card(
                class = "mb-3",
                bslib::card_header(bsicons::bs_icon("database", class = "me-1"),
                                   "Fuentes de datos"),
                bslib::card_body(
                  p(class = "small text-muted mb-2",
                    "Selecciona una o m\u00e1s fuentes:"),
                  checkboxInput(ns("src_gbif"), 
                               tagList(tags$img(src = "https://www.gbif.org/img/logo/GBIF-2015.png",
                                               height = "16px", class = "me-1"), "GBIF"),
                               value = TRUE),
                  checkboxInput(ns("src_inat"),
                               tagList(bsicons::bs_icon("binoculars", class = "me-1"),
                                       "iNaturalist"),
                               value = FALSE),
                  checkboxInput(ns("src_bdcr"),
                               tagList(bsicons::bs_icon("geo-alt", class = "me-1"),
                                       "BiodataCR"),
                               value = FALSE),
                  tags$hr(),
                  p(class = "small fw-bold mb-1", "O carga tus propios registros:"),
                  fileInput(ns("archivo_registros"),
                            label   = NULL,
                            accept  = c(".csv", ".xlsx", ".gpkg", ".geojson"),
                            buttonLabel = "Buscar\u2026",
                            placeholder = "CSV, Excel o espacial"),
                  p(class = "small text-muted mb-0",
                    "El archivo debe tener columnas de latitud y longitud.")
                )
              ),

              bslib::card(
                class = "mb-3",
                bslib::card_header(bsicons::bs_icon("sliders", class = "me-1"),
                                   "Par\u00e1metros"),
                bslib::card_body(
                  numericInput(ns("limite"),
                               "L\u00edmite de registros por fuente:",
                               value = 500, min = 1, max = 100000, step = 100),
                  checkboxInput(ns("solo_aoi"),
                                "Solo dentro del AOI",
                                value = TRUE),
                  div(
                    p(class = "small fw-bold mb-1", "Rango de fechas (opcional):"),
                    bslib::layout_columns(
                      col_widths = c(6, 6),
                      fill = FALSE,
                      dateInput(ns("fecha_inicio"), label = "Desde:",
                                value = "2000-01-01", format = "yyyy-mm-dd"),
                      dateInput(ns("fecha_fin"),    label = "Hasta:",
                                value = Sys.Date(),   format = "yyyy-mm-dd")
                    )
                  )
                )
              ),

              actionButton(ns("descargar_registros"),
                           "Descargar registros",
                           class = "btn-primary w-100 mb-2",
                           icon  = icon("download")),
              uiOutput(ns("resumen_registros"))
            ),

            # Panel derecho — mapa + tabla
            div(
              bslib::card(
                class = "mb-3",
                bslib::card_header(bsicons::bs_icon("map", class = "me-1"),
                                   "Mapa de registros"),
                bslib::card_body(class = "p-0",
                  leaflet::leafletOutput(ns("mapa_registros"), height = "320px")
                )
              ),
              bslib::card(
                bslib::card_header(bsicons::bs_icon("table", class = "me-1"),
                                   "Registros descargados"),
                bslib::card_body(
                  DT::DTOutput(ns("tabla_registros"))
                )
              )
            )
          )
        )
      ),

      # ══════════════════════════════════════════════════════
      # PESTAÑA 4: Grilla H3
      # ══════════════════════════════════════════════════════
      bslib::nav_panel(
        title = tagList(bsicons::bs_icon("hexagon-fill", class = "me-1"),
                        "Grilla H3"),
        div(
          class = "p-3",
          p(class = "small text-muted mb-3",
            "Genera la grilla hexagonal H3 sobre el AOI. ",
            "Cada hex\u00e1gono ser\u00e1 la unidad de muestreo para los registros ",
            "y las variables ambientales."),

          bslib::layout_columns(
            col_widths = c(4, 8),
            fill = FALSE,

            # Panel izquierdo
            div(
              bslib::card(
                class = "mb-3",
                bslib::card_header(bsicons::bs_icon("sliders", class = "me-1"),
                                   "Resoluci\u00f3n H3"),
                bslib::card_body(
                  selectInput(
                    ns("resolucion_h3"),
                    label   = "Resoluci\u00f3n:",
                    choices = c(
                      "4 — 1,770 km\u00b2 (pa\u00eds / gran regi\u00f3n)" = "4",
                      "5 — 252.9 km\u00b2 (paisaje amplio)"             = "5",
                      "6 — 36.1 km\u00b2 (paisaje local)"               = "6",
                      "7 — 5.2 km\u00b2 (SDM fino \u2605)"              = "7",
                      "8 — 0.74 km\u00b2 (escala de sitio)"             = "8",
                      "9 — 0.11 km\u00b2 (alta resoluci\u00f3n)"         = "9"
                    ),
                    selected = "7"
                  ),
                  uiOutput(ns("info_resolucion")),
                  tags$hr(),
                  actionButton(ns("generar_grilla"),
                               "Generar grilla H3",
                               class = "btn-primary w-100",
                               icon  = icon("th-large"))
                )
              ),

              bslib::card(
                class = "mb-0",
                bslib::card_header(bsicons::bs_icon("info-circle", class = "me-1"),
                                   "Resumen de la grilla"),
                bslib::card_body(
                  uiOutput(ns("resumen_grilla"))
                )
              )
            ),

            # Panel derecho — mapa
            bslib::card(
              bslib::card_header(bsicons::bs_icon("map", class = "me-1"),
                                 "Grilla H3"),
              bslib::card_body(class = "p-0",
                leaflet::leafletOutput(ns("mapa_grilla"), height = "500px")
              )
            )
          )
        )
      ),

      # ══════════════════════════════════════════════════════
      # PESTAÑA 5: Variables ambientales
      # ══════════════════════════════════════════════════════
      bslib::nav_panel(
        title = tagList(bsicons::bs_icon("thermometer-half", class = "me-1"),
                        "Variables"),
        div(class = "p-3",
            p(class = "text-muted small", "En construcci\u00f3n\u2026"))
      ),

      # ══════════════════════════════════════════════════════
      # PESTAÑA 6: Presencias / Pseudoausencias
      # ══════════════════════════════════════════════════════
      bslib::nav_panel(
        title = tagList(bsicons::bs_icon("toggles", class = "me-1"),
                        "Presencias/Ausencias"),
        div(class = "p-3",
            p(class = "text-muted small", "En construcci\u00f3n\u2026"))
      ),

      # ══════════════════════════════════════════════════════
      # PESTAÑA 7: Ajustar modelo
      # ══════════════════════════════════════════════════════
      bslib::nav_panel(
        title = tagList(bsicons::bs_icon("gear", class = "me-1"),
                        "Ajustar modelo"),
        div(class = "p-3",
            p(class = "text-muted small", "En construcci\u00f3n\u2026"))
      ),

      # ══════════════════════════════════════════════════════
      # PESTAÑA 8: Diagnóstico
      # ══════════════════════════════════════════════════════
      bslib::nav_panel(
        title = tagList(bsicons::bs_icon("clipboard-check", class = "me-1"),
                        "Diagn\u00f3stico"),
        div(class = "p-3",
            p(class = "text-muted small", "En construcci\u00f3n\u2026"))
      ),

      # ══════════════════════════════════════════════════════
      # PESTAÑA 9: Predicción
      # ══════════════════════════════════════════════════════
      bslib::nav_panel(
        title = tagList(bsicons::bs_icon("map-fill", class = "me-1"),
                        "Predicci\u00f3n"),
        div(class = "p-3",
            p(class = "text-muted small", "En construcci\u00f3n\u2026"))
      ),

      # ══════════════════════════════════════════════════════
      # PESTAÑA 10: Código R
      # ══════════════════════════════════════════════════════
      bslib::nav_panel(
        title = tagList(bsicons::bs_icon("code-slash", class = "me-1"),
                        "C\u00f3digo R"),
        div(class = "p-3",
            p(class = "text-muted small", "En construcci\u00f3n\u2026"))
      )

    ) # /navset_tab
  )
}

# ── Server ───────────────────────────────────────────────
mod_h3sdm_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # ── Grilla H3 ─────────────────────────────────────────
    grilla_sf <- reactiveVal(NULL)

    output$info_resolucion <- renderUI({
      res   <- as.character(input$resolucion_h3)
      areas <- c("4"="1,770.3","5"="252.9","6"="36.1",
                 "7"="5.2",    "8"="0.74", "9"="0.11")
      div(class = "alert alert-info small py-2 px-3 mb-0 mt-2",
          bsicons::bs_icon("info-circle", class = "me-1"),
          paste0("Resoluci\u00f3n ", res, ": \u00e1rea promedio de ",
                 areas[res], " km\u00b2 por hex\u00e1gono."),
          if (as.integer(res) >= 8) tags$br(),
          if (as.integer(res) >= 8)
            tags$span(style = paste0("color:", colores$peligro),
                      bsicons::bs_icon("exclamation-triangle", class = "me-1"),
                      "Resoluciones \u2265 8 pueden generar muchos hex\u00e1gonos. ",
                      "Verifica que el AOI no sea muy grande.")
      )
    })

    output$mapa_grilla <- leaflet::renderLeaflet({
      leaflet::leaflet() |>
        leaflet::addProviderTiles(leaflet::providers$CartoDB.Positron) |>
        leaflet::setView(lng = 0, lat = 20, zoom = 2)
    })

    observeEvent(input$generar_grilla, {
      if (is.null(aoi_sf())) {
        showNotification("Define primero el AOI en la pesta\u00f1a \u00c1rea de inter\u00e9s.",
                         type = "warning"); return()
      }
      withProgress(message = "Generando grilla H3\u2026", {
        tryCatch({
          grilla <- h3sdm::h3sdm_get_grid(
            aoi_sf(),
            res = as.integer(input$resolucion_h3)
          ) |>
            sf::st_cast("POLYGON")
          grilla_sf(grilla)
          bbox <- sf::st_bbox(grilla)
          leaflet::leafletProxy(ns("mapa_grilla")) |>
            leaflet::clearGroup("grilla") |>
            leaflet::clearGroup("aoi_grilla") |>
            leafgl::addGlPolygons(
              data        = grilla,
              group       = "grilla",
              color       = colores$primario,
              fillColor   = colores$secundario,
              fillOpacity = 0.2,
              weight      = 1
            ) |>
            leaflet::addPolygons(
              data = aoi_sf(), group = "aoi_grilla",
              color = colores$peligro, fillOpacity = 0,
              weight = 2, dashArray = "5,5"
            ) |>
            leaflet::fitBounds(bbox[["xmin"]], bbox[["ymin"]],
                               bbox[["xmax"]], bbox[["ymax"]])
          showNotification(paste(nrow(grilla), "hex\u00e1gonos generados."),
                           type = "message", duration = 4)
        }, error = function(e) {
          showNotification(paste("Error:", conditionMessage(e)),
                           type = "error", duration = 8)
        })
      })
    })

    output$resumen_grilla <- renderUI({
      grilla <- grilla_sf()
      if (is.null(grilla)) {
        p(class = "small text-muted mb-0",
          bsicons::bs_icon("exclamation-circle", class = "me-1"),
          "No hay grilla generada todav\u00eda.")
      } else {
        area_total <- round(sum(as.numeric(sf::st_area(grilla))) / 1e6, 1)
        div(
          p(class = "small mb-1",
            bsicons::bs_icon("check-circle-fill", class = "me-1",
                             style = paste0("color:", colores$exito)),
            strong("Grilla generada")),
          tags$ul(class = "small mb-0",
            tags$li(paste0("Hex\u00e1gonos: ", nrow(grilla))),
            tags$li(paste0("Resoluci\u00f3n H3: ", input$resolucion_h3)),
            tags$li(paste0("\u00c1rea total: ", area_total, " km\u00b2"))
          )
        )
      }
    })

    # ── Registros ─────────────────────────────────────────
    registros_sf <- reactiveVal(NULL)

    # Mapa de registros
    output$mapa_registros <- leaflet::renderLeaflet({
      leaflet::leaflet() |>
        leaflet::addProviderTiles(leaflet::providers$OpenStreetMap) |>
        leaflet::setView(lng = 0, lat = 20, zoom = 2)
    })

    # Descargar registros
    observeEvent(input$descargar_registros, {
      req(nchar(trimws(input$especie)) > 0)

      # Validaciones
      if (!input$src_gbif && !input$src_inat && !input$src_bdcr &&
          is.null(input$archivo_registros)) {
        showNotification("Selecciona al menos una fuente de datos.",
                         type = "warning"); return()
      }
      if (input$solo_aoi && is.null(aoi_sf())) {
        showNotification("Define primero el AOI en la pesta\u00f1a \u00c1rea de inter\u00e9s.",
                         type = "warning"); return()
      }

      # Construir vector de providers
      providers_sel <- c(
        if (input$src_gbif) "gbif",
        if (input$src_inat) "inat",
        if (input$src_bdcr) "biodatacr"
      )

      withProgress(message = paste("Descargando registros de", input$especie,
                                   "\u2026"), {
        tryCatch({
          aoi <- if (input$solo_aoi) aoi_sf() else {
            # AOI global aproximado
            sf::st_sf(geometry = sf::st_sfc(
              sf::st_polygon(list(matrix(
                c(-180,-90, 180,-90, 180,90, -180,90, -180,-90),
                ncol=2, byrow=TRUE))),
              crs = 4326))
          }

          recs <- h3sdm::h3sdm_get_records(
            species           = input$especie,
            aoi_sf            = aoi,
            providers         = providers_sel,
            limit             = input$limite,
            remove_duplicates = TRUE,
            date              = c(as.character(input$fecha_inicio),
                                  as.character(input$fecha_fin))
          )

          if (!is.null(recs) && nrow(recs) > 0) {
            registros_sf(recs)
            showNotification(paste(nrow(recs), "registros descargados."),
                             type = "message", duration = 4)
          } else {
            showNotification("No se encontraron registros.", type = "warning")
          }
        }, error = function(e) {
          showNotification(paste("Error:", conditionMessage(e)),
                           type = "error", duration = 8)
        })
      })
    })

    # Cargar archivo propio de registros
    observeEvent(input$archivo_registros, {
      req(input$archivo_registros)
      tryCatch({
        ext  <- tools::file_ext(input$archivo_registros$name)
        path <- input$archivo_registros$datapath
        recs <- if (ext %in% c("gpkg", "geojson")) {
          sf::st_read(path, quiet = TRUE) |>
            sf::st_transform(4326)
        } else if (ext == "xlsx") {
          df <- readxl::read_excel(path)
          lat_col <- grep("lat", names(df), ignore.case = TRUE, value = TRUE)[1]
          lon_col <- grep("lon|lng", names(df), ignore.case = TRUE, value = TRUE)[1]
          req(lat_col, lon_col)
          sf::st_as_sf(df, coords = c(lon_col, lat_col), crs = 4326)
        } else {
          df <- read.csv(path)
          lat_col <- grep("lat", names(df), ignore.case = TRUE, value = TRUE)[1]
          lon_col <- grep("lon|lng", names(df), ignore.case = TRUE, value = TRUE)[1]
          req(lat_col, lon_col)
          sf::st_as_sf(df, coords = c(lon_col, lat_col), crs = 4326)
        }
        registros_sf(recs)
        showNotification(paste(nrow(recs), "registros cargados."),
                         type = "message", duration = 4)
      }, error = function(e) {
        showNotification(paste("Error al cargar:", conditionMessage(e)),
                         type = "error")
      })
    })

    # Actualizar mapa cuando cambian los registros
    observeEvent(registros_sf(), {
      recs <- registros_sf(); req(recs)
      coords <- sf::st_coordinates(recs)
      bbox   <- sf::st_bbox(recs)

      leaflet::leafletProxy(ns("mapa_registros")) |>
        leaflet::clearMarkers() |>
        leaflet::clearGroup("aoi_reg") |>
        leaflet::addCircleMarkers(
          lng    = coords[, 1], lat = coords[, 2],
          radius = 4, color = colores$acento,
          fillOpacity = 0.7, weight = 1,
          popup  = if ("name" %in% names(recs)) recs$name else NULL
        ) |>
        leaflet::fitBounds(bbox[["xmin"]], bbox[["ymin"]],
                           bbox[["xmax"]], bbox[["ymax"]])

      # Mostrar AOI si existe
      if (!is.null(aoi_sf())) {
        leaflet::leafletProxy(ns("mapa_registros")) |>
          leaflet::addPolygons(data = aoi_sf(), group = "aoi_reg",
                               color = colores$primario,
                               fillOpacity = 0.1, weight = 2)
      }
    })

    # Tabla de registros
    output$tabla_registros <- DT::renderDT({
      recs <- registros_sf(); req(recs)
      df   <- sf::st_drop_geometry(recs)
      DT::datatable(df, options = list(pageLength = 10, scrollX = TRUE),
                    rownames = FALSE, class = "table-sm")
    })

    # Resumen de registros
    output$resumen_registros <- renderUI({
      recs <- registros_sf()
      if (is.null(recs)) return(NULL)
      div(class = "alert alert-info small py-2 px-3 mt-2 mb-0",
          bsicons::bs_icon("check-circle-fill", class = "me-1"),
          strong(nrow(recs)), " registros listos.")
    })
    aoi_sf <- reactiveVal(NULL)

    # Mapa base
    output$mapa_aoi <- leaflet::renderLeaflet({
      leaflet::leaflet() |>
        leaflet::addProviderTiles(leaflet::providers$OpenStreetMap,
                                  options = leaflet::providerTileOptions(
                                    attribution = "\u00a9 OpenStreetMap contributors"
                                  )) |>
        leaflet::setView(lng = 0, lat = 20, zoom = 2) |>
        leaflet.extras::addDrawToolbar(
          targetGroup    = "aoi",
          polylineOptions = FALSE,
          circleOptions   = FALSE,
          markerOptions   = FALSE,
          circleMarkerOptions = FALSE,
          rectangleOptions = leaflet.extras::drawRectangleOptions(
            shapeOptions = leaflet.extras::drawShapeOptions(
              color = "#1170AA", fillOpacity = 0.2)),
          polygonOptions = leaflet.extras::drawPolygonOptions(
            shapeOptions = leaflet.extras::drawShapeOptions(
              color = "#1170AA", fillOpacity = 0.2)),
          editOptions = leaflet.extras::editToolbarOptions(
            selectedPathOptions = leaflet.extras::selectedPathOptions()
          )
        ) |>
        leaflet::addLayersControl(
          overlayGroups = "aoi",
          options       = leaflet::layersControlOptions(collapsed = FALSE)
        )
    })

    # Capturar polígono dibujado
    observeEvent(input$mapa_aoi_draw_new_feature, {
      feat <- input$mapa_aoi_draw_new_feature
      tryCatch({
        coords <- feat$geometry$coordinates[[1]]
        mat    <- do.call(rbind, lapply(coords, function(p) c(p[[1]], p[[2]])))
        poly   <- sf::st_polygon(list(mat))
        sf_obj <- sf::st_sf(geometry = sf::st_sfc(poly, crs = 4326),
                            nombre = "AOI dibujado")
        aoi_sf(sf_obj)
        showNotification("AOI dibujado guardado.", type = "message", duration = 3)
      }, error = function(e) {
        showNotification("Error al capturar el pol\u00edgono.", type = "error")
      })
    })

    # Limpiar AOI
    observeEvent(input$limpiar_aoi, {
      aoi_sf(NULL)
      leaflet::leafletProxy(ns("mapa_aoi")) |>
        leaflet::clearGroup("aoi")
      showNotification("AOI eliminado.", type = "message", duration = 2)
    })

    # Cargar archivo espacial
    observeEvent(input$archivo_aoi, {
      req(input$archivo_aoi)
      tryCatch({
        ext  <- tools::file_ext(input$archivo_aoi$name)
        path <- input$archivo_aoi$datapath

        sf_obj <- if (ext == "zip") {
          # Shapefile
          tmp <- tempdir()
          utils::unzip(path, exdir = tmp)
          shp <- list.files(tmp, pattern = "\\.shp$", full.names = TRUE)[1]
          sf::st_read(shp, quiet = TRUE)
        } else if (ext %in% c("gpkg", "geojson", "json", "kml")) {
          sf::st_read(path, quiet = TRUE)
        } else {
          stop("Formato no soportado.")
        }

        sf_obj <- sf::st_transform(sf_obj, 4326)
        sf_obj <- sf_obj[1, ]  # solo primer feature
        aoi_sf(sf_obj)

        # Centrar mapa en el AOI
        bbox <- sf::st_bbox(sf_obj)
        leaflet::leafletProxy(ns("mapa_aoi")) |>
          leaflet::clearGroup("aoi") |>
          leaflet::addPolygons(
            data        = sf_obj,
            group       = "aoi",
            color       = "#1170AA",
            fillOpacity = 0.2,
            weight      = 2
          ) |>
          leaflet::fitBounds(bbox[["xmin"]], bbox[["ymin"]],
                             bbox[["xmax"]], bbox[["ymax"]])

        showNotification("AOI cargado correctamente.", type = "message", duration = 3)
      }, error = function(e) {
        showNotification(paste("Error:", conditionMessage(e)), type = "error")
      })
    })

    # Resumen del AOI activo
    output$resumen_aoi <- renderUI({
      aoi <- aoi_sf()
      if (is.null(aoi)) {
        p(class = "small text-muted mb-0",
          bsicons::bs_icon("exclamation-circle", class = "me-1"),
          "No hay AOI definido todav\u00eda.")
      } else {
        bbox <- sf::st_bbox(aoi)
        area <- round(as.numeric(sf::st_area(aoi)) / 1e6, 1)
        div(
          p(class = "small mb-1",
            bsicons::bs_icon("check-circle-fill", class = "me-1",
                             style = paste0("color:", colores$exito)),
            strong("AOI definido")),
          tags$ul(class = "small mb-0",
            tags$li(paste0("\u00c1rea: ", area, " km\u00b2")),
            tags$li(paste0("Lon: ", round(bbox["xmin"], 3),
                           " a ", round(bbox["xmax"], 3))),
            tags$li(paste0("Lat: ", round(bbox["ymin"], 3),
                           " a ", round(bbox["ymax"], 3)))
          )
        )
      }
    })

    # Info AOI dibujado
    output$info_aoi_dibujado <- renderUI({
      aoi <- aoi_sf()
      if (!is.null(aoi)) {
        div(class = "alert alert-success small py-2 px-3 mb-2",
            bsicons::bs_icon("check-circle-fill", class = "me-1"),
            "AOI activo \u2014 ver resumen abajo.")
      }
    })

  })
}
