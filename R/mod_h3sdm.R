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
                  uiOutput(ns("resumen_aoi")),
                  conditionalPanel(
                    condition = "true",
                    uiOutput(ns("sel_proyeccion"))
                  )
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
                  div(class = "alert alert-light small py-2 px-3 mb-0",
                      tags$b("CSV/Excel:"), " columnas ", code("latitude"),
                      " y ", code("longitude"), " (o ", code("lat"), "/", code("lon"), ").",
                      tags$br(),
                      tags$b("GeoPackage/GeoJSON:"), " geometr\u00eda de puntos en cualquier CRS."
                  )
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
                           "Buscar registros",
                           class = "btn-primary w-100 mb-2",
                           icon  = icon("search")),
              uiOutput(ns("resumen_registros")),
              br(),
              downloadButton(ns("dl_registros"), "Descargar registros",
                             class = "btn-outline-primary btn-sm w-100")
            ),

            # Panel derecho — mapa + tabla
            div(
              bslib::card(
                class = "mb-3",
                bslib::card_header(bsicons::bs_icon("map", class = "me-1"),
                                   "Mapa de registros"),
                bslib::card_body(class = "p-0",
                  leaflet::leafletOutput(ns("mapa_registros"), height = "420px")
                )
              ),
              bslib::card(
                bslib::card_header(bsicons::bs_icon("table", class = "me-1"),
                                   "Registros encontrados"),
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
                class = "mb-3",
                bslib::card_header(bsicons::bs_icon("info-circle", class = "me-1"),
                                   "Resumen de la grilla"),
                bslib::card_body(
                  uiOutput(ns("resumen_grilla"))
                )
              ),
              downloadButton(ns("dl_grilla"), "Descargar grilla",
                             class = "btn-outline-primary btn-sm w-100")
            ),

            # Panel derecho — mapa
            bslib::card(
              bslib::card_header(bsicons::bs_icon("map", class = "me-1"),
                                 "Grilla H3"),
              bslib::card_body(class = "p-0",
                leaflet::leafletOutput(ns("mapa_grilla"), height = "580px")
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
        div(
          class = "p-3",
          p(class = "small text-muted mb-3",
            "Carga variables ambientales en formato raster y extr\u00e1elas ",
            "dentro de los hex\u00e1gonos H3. Se necesita la grilla generada ",
            "en la pesta\u00f1a anterior."),

          bslib::layout_columns(
            col_widths = c(4, 8),
            fill = FALSE,

            # Panel izquierdo
            div(
              # Numéricas
              bslib::card(
                class = "mb-3",
                bslib::card_header(
                  bsicons::bs_icon("bar-chart", class = "me-1"),
                  "Variables num\u00e9ricas"
                ),
                bslib::card_body(
                  p(class = "small text-muted mb-2",
                    "GeoTIFF con una o m\u00e1s capas continuas ",
                    "(temperatura, precipitaci\u00f3n, NDVI, etc.)."),
                  fileInput(
                    ns("raster_num"),
                    label   = NULL,
                    accept  = c(".tif", ".tiff"),
                    multiple = TRUE,
                    buttonLabel = "Buscar\u2026",
                    placeholder = "GeoTIFF (.tif)"
                  ),
                  actionButton(ns("extraer_num"),
                               "Extraer num\u00e9ricas",
                               class = "btn-outline-primary btn-sm w-100",
                               icon  = icon("calculator"))
                )
              ),

              # Categóricas
              bslib::card(
                class = "mb-3",
                bslib::card_header(
                  bsicons::bs_icon("grid-3x3-gap", class = "me-1"),
                  "Variables categ\u00f3ricas"
                ),
                bslib::card_body(
                  p(class = "small text-muted mb-2",
                    "GeoTIFF con una capa categ\u00f3rica ",
                    "(cobertura del suelo, uso de la tierra, etc.)."),
                  fileInput(
                    ns("raster_cat"),
                    label   = NULL,
                    accept  = c(".tif", ".tiff", ".xml"),
                    multiple = TRUE,
                    buttonLabel = "Buscar\u2026",
                    placeholder = "GeoTIFF (.tif)"
                  ),
                  actionButton(ns("extraer_cat"),
                               "Extraer categ\u00f3ricas",
                               class = "btn-outline-primary btn-sm w-100",
                               icon  = icon("th"))
                )
              ),

              # Métricas del paisaje
              bslib::card(
                class = "mb-3",
                bslib::card_header(
                  bsicons::bs_icon("diagram-3", class = "me-1"),
                  "M\u00e9tricas del paisaje (IT)"
                ),
                bslib::card_body(
                  p(class = "small text-muted mb-2",
                    "Carga un raster categ\u00f3rico (cobertura del suelo) para calcular ",
                    "m\u00e9tricas de teor\u00eda de la informaci\u00f3n por hex\u00e1gono: ",
                    code("condent"), ", ", code("ent"), ", ", code("joinent"),
                    ", ", code("mutinf"), ", ", code("relmutinf"), "."),
                  fileInput(
                    ns("raster_it"),
                    label    = NULL,
                    accept   = c(".tif", ".tiff", ".xml"),
                    multiple = TRUE,
                    buttonLabel = "Buscar\u2026",
                    placeholder = "GeoTIFF (.tif)"
                  ),
                  actionButton(ns("calcular_it"),
                               "Calcular m\u00e9tricas IT",
                               class = "btn-outline-primary btn-sm w-100",
                               icon  = icon("leaf"))
                )
              ),

              # Manejo de NAs
              bslib::card(
                class = "mb-3",
                bslib::card_header(
                  bsicons::bs_icon("exclamation-triangle", class = "me-1"),
                  "Manejo de valores faltantes (NA)"
                ),
                bslib::card_body(
                  uiOutput(ns("resumen_nas")),
                  bslib::layout_columns(
                    col_widths = c(6, 6),
                    fill = FALSE,
                    actionButton(ns("eliminar_nas"),
                                 "Eliminar filas con NA",
                                 class = "btn-outline-danger btn-sm w-100",
                                 icon  = icon("trash")),
                    actionButton(ns("imputar_nas"),
                                 "Imputar con media",
                                 class = "btn-outline-secondary btn-sm w-100",
                                 icon  = icon("calculator"))
                  )
                )
              ),

              # Resumen
              bslib::card(
                class = "mb-0",
                bslib::card_header(
                  bsicons::bs_icon("info-circle", class = "me-1"),
                  "Variables extraídas"
                ),
                bslib::card_body(
                  uiOutput(ns("resumen_variables"))
                )
              )
            ),

            # Panel derecho
            div(
              bslib::card(
                class = "mb-3",
                bslib::card_header(
                  bsicons::bs_icon("map", class = "me-1"),
                  "Visualizar variable"
                ),
                bslib::card_body(
                  uiOutput(ns("sel_variable_mapa")),
                  leaflet::leafletOutput(ns("mapa_variables"), height = "380px")
                )
              ),
              bslib::card(
                bslib::card_header(
                  bsicons::bs_icon("table", class = "me-1"),
                  "Tabla de predictores"
                ),
                bslib::card_body(
                  DT::DTOutput(ns("tabla_predictores"), height = "300px")
                )
              )
            )
          )
        )
      ),

      # ══════════════════════════════════════════════════════
      # PESTAÑA 6: Selección de variables
      # ══════════════════════════════════════════════════════
      bslib::nav_panel(
        title = tagList(bsicons::bs_icon("funnel", class = "me-1"),
                        "Selecci\u00f3n de variables"),
        div(
          class = "p-3",
          p(class = "small text-muted mb-3",
            "Elimina variables redundantes o sin sentido ecol\u00f3gico antes de modelar. ",
            "Puedes eliminarlas manualmente o por correlaci\u00f3n."),

          bslib::layout_columns(
            col_widths = c(4, 8),
            fill = FALSE,

            # Panel izquierdo
            div(
              # Eliminar por correlación
              bslib::card(
                class = "mb-3",
                bslib::card_header(
                  bsicons::bs_icon("diagram-2", class = "me-1"),
                  "Eliminar por correlaci\u00f3n"
                ),
                bslib::card_body(
                  p(class = "small text-muted mb-2",
                    "Variables con correlaci\u00f3n mayor al umbral ser\u00e1n ",
                    "marcadas para eliminar. Se conserva la primera del par."),
                  sliderInput(
                    ns("umbral_cor"),
                    label   = "Umbral de correlaci\u00f3n:",
                    min     = 0.5, max = 1.0,
                    value   = 0.8, step = 0.05
                  ),
                  actionButton(ns("calcular_cor"),
                               "Calcular correlaciones",
                               class = "btn-outline-primary btn-sm w-100 mb-2",
                               icon  = icon("chart-line")),
                  actionButton(ns("eliminar_cor"),
                               "Eliminar correlacionadas",
                               class = "btn-outline-danger btn-sm w-100",
                               icon  = icon("trash"))
                )
              ),

              # Eliminar manualmente
              bslib::card(
                class = "mb-3",
                bslib::card_header(
                  bsicons::bs_icon("check2-square", class = "me-1"),
                  "Selecci\u00f3n manual"
                ),
                bslib::card_body(
                  p(class = "small text-muted mb-2",
                    "Marca las variables que quieres ", strong("conservar"),
                    " en el modelo:"),
                  uiOutput(ns("checkboxes_vars")),
                  actionButton(ns("aplicar_seleccion"),
                               "Aplicar selecci\u00f3n",
                               class = "btn-primary btn-sm w-100 mt-2",
                               icon  = icon("check"))
                )
              ),

              # Resumen
              bslib::card(
                class = "mb-0",
                bslib::card_header(
                  bsicons::bs_icon("info-circle", class = "me-1"),
                  "Variables activas"
                ),
                bslib::card_body(
                  uiOutput(ns("resumen_seleccion"))
                )
              )
            ),

            # Panel derecho — matriz de correlación
            bslib::card(
              bslib::card_header(
                bsicons::bs_icon("grid-3x3", class = "me-1"),
                "Matriz de correlaci\u00f3n"
              ),
              bslib::card_body(
                p(class = "small text-muted mb-2",
                  "Solo variables num\u00e9ricas. ",
                  "Azul = correlaci\u00f3n positiva | Rojo = correlaci\u00f3n negativa."),
                plotOutput(ns("plot_correlacion"), height = "480px")
              )
            )
          )
        )
      ),
      # ══════════════════════════════════════════════════════
      # PESTAÑA 7: Presencias / Pseudoausencias
      # ══════════════════════════════════════════════════════
      bslib::nav_panel(
        title = tagList(bsicons::bs_icon("toggles", class = "me-1"),
                        "Presencias/Ausencias"),
        div(
          class = "p-3",
          p(class = "small text-muted mb-3",
            "Asigna los registros de ocurrencia a hex\u00e1gonos H3 y genera ",
            "pseudoausencias para el modelo. Combina registros, grilla y ",
            "variables en un \u00fanico dataset listo para modelar."),

          bslib::layout_columns(
            col_widths = c(4, 8),
            fill = FALSE,

            # Panel izquierdo
            div(
              # Resumen de inputs disponibles
              bslib::card(
                class = "mb-3",
                bslib::card_header(
                  bsicons::bs_icon("list-check", class = "me-1"),
                  "Insumos disponibles"
                ),
                bslib::card_body(
                  uiOutput(ns("resumen_insumos"))
                )
              ),

              # Parámetros
              bslib::card(
                class = "mb-3",
                bslib::card_header(
                  bsicons::bs_icon("sliders", class = "me-1"),
                  "Par\u00e1metros"
                ),
                bslib::card_body(
                  numericInput(
                    ns("n_pseudoabs"),
                    label = "N\u00famero de pseudoausencias:",
                    value = 500, min = 10, max = 10000, step = 50
                  ),
                  p(class = "small text-muted mb-2",
                    bsicons::bs_icon("info-circle", class = "me-1"),
                    "Se recomienda 2\u20135\u00d7 el n\u00famero de presencias."),
                  numericInput(
                    ns("buffer_k"),
                    label = "Buffer de exclusi\u00f3n (anillos H3):",
                    value = 1L, min = 0L, max = 5L, step = 1L
                  ),
                  p(class = "small text-muted mb-0",
                    bsicons::bs_icon("info-circle", class = "me-1"),
                    "N\u00famero de anillos de hex\u00e1gonos vecinos a excluir alrededor de ",
                    "cada presencia. Use 0 para desactivar."),
                  tags$hr(),
                  checkboxInput(
                    ns("aplicar_filtro_outliers"),
                    label = strong("Filtrar outliers ambientales"),
                    value = FALSE
                  ),
                  div(
                    class = "small text-muted mb-2",
                    p(class = "mb-1",
                      bsicons::bs_icon("funnel", class = "me-1"),
                      "Elimina hex\u00e1gonos de presencia cuyas condiciones ambientales ",
                      "son muy distintas al resto, usando la ",
                      strong("distancia de Mahalanobis"), " en el espacio multivariado ",
                      "de las variables predictoras."),
                    p(class = "mb-1",
                      bsicons::bs_icon("question-circle", class = "me-1"),
                      strong("\u00bfPara qu\u00e9 sirve?"), " Las bases de datos como GBIF e iNaturalist ",
                      "pueden contener registros con coordenadas err\u00f3neas, especímenes fuera ",
                      "de su rango natural, o individuos en h\u00e1bitats atípicos (cautiverio, ",
                      "jardines, introducciones). Estos registros pueden distorsionar el modelo ",
                      "al incluir condiciones ambientales no representativas de la especie."),
                    p(class = "mb-0",
                      bsicons::bs_icon("exclamation-triangle", class = "me-1"),
                      strong("Requiere"), " haber extra\u00eddo las variables ambientales primero. ",
                      "Si las variables no est\u00e1n disponibles, el filtro no se aplicar\u00e1 y ",
                      "ver\u00e1s un aviso.")
                  ),
                  tags$hr(),
                  p(class = "small fw-bold mb-1",
                    "Presencias con hex\u00e1gonos H3"),
                  p(class = "small text-muted mb-2",
                    "Cada hex\u00e1gono representa un \u00e1rea, no un punto \u2014 lo que modela ",
                    "mejor la realidad de c\u00f3mo los organismos ocupan el espacio. Esto ",
                    "permite extraer variables del paisaje (medias, varianza, proporciones) ",
                    "dentro de cada celda. Adem\u00e1s, m\u00faltiples registros dentro del mismo ",
                    "hex\u00e1gono se consolidan en una sola presencia, reduciendo el sesgo de ",
                    "muestreo espacial. La resoluci\u00f3n del hex\u00e1gono controla la escala del ",
                    "an\u00e1lisis seg\u00fan el organismo de inter\u00e9s."),
                  p(class = "small fw-bold mb-1",
                    "Pseudoausencias"),
                  p(class = "small text-muted mb-0",
                    "Se generan fuera del \u00e1rea de distribuci\u00f3n conocida \u2014 excluyendo las ",
                    "celdas con presencias y su buffer \u2014 para evitar contaminar las ausencias ",
                    "con zonas potencialmente ocupadas. Se limitan al \u00e1rea de estudio definida ",
                    "por el usuario, respetando el contexto ambiental relevante para la especie. ",
                    "Su selecci\u00f3n se realiza mediante k-means en el espacio ambiental, ",
                    "garantizando que representen la diversidad de condiciones disponibles, ",
                    "no solo la distribuci\u00f3n geogr\u00e1fica.")
                )
              ),

              actionButton(ns("generar_pa"),
                           "Generar dataset PA",
                           class = "btn-primary w-100 mb-2",
                           icon  = icon("play")),
              uiOutput(ns("resumen_pa")),
              br(),
              downloadButton(ns("dl_pa"), "Descargar datos para modelar",
                             class = "btn-outline-primary btn-sm w-100")
            ),

            # Panel derecho
            div(
              bslib::card(
                class = "mb-3",
                bslib::card_header(
                  bsicons::bs_icon("map", class = "me-1"),
                  "Mapa presencias / pseudoausencias"
                ),
                bslib::card_body(class = "p-0",
                  leaflet::leafletOutput(ns("mapa_pa"), height = "400px")
                )
              ),
              bslib::card(
                bslib::card_header(
                  bsicons::bs_icon("table", class = "me-1"),
                  "Datos para modelar"
                ),
                bslib::card_body(
                  DT::DTOutput(ns("tabla_pa"), height = "300px")
                )
              )
            )
          )
        )
      ),

      # ══════════════════════════════════════════════════════
      # PESTAÑA 8: Ajustar modelo
      # ══════════════════════════════════════════════════════
      bslib::nav_panel(
        title = tagList(bsicons::bs_icon("gear", class = "me-1"),
                        "Ajustar modelo"),
        div(
          class = "p-3",
          p(class = "small text-muted mb-3",
            "Selecciona el algoritmo, configura la validaci\u00f3n cruzada espacial ",
            "y ajusta el modelo de distribuci\u00f3n de especies."),

          bslib::layout_columns(
            col_widths = c(4, 8),
            fill = FALSE,

            # Panel izquierdo
            div(
              # Selector de algoritmo
              bslib::card(
                class = "mb-3",
                bslib::card_header(
                  bsicons::bs_icon("cpu", class = "me-1"),
                  "Algoritmo"
                ),
                bslib::card_body(
                  p(class = "small text-muted mb-2",
                    "\u00bfQu\u00e9 tipo de modelo quieres ajustar?"),
                  tags$div(
                    style = "display:grid; grid-template-columns:1fr 1fr; gap:8px; margin-bottom:8px;",

                    # Regresión logística
                    tags$div(
                      id = ns("card_logreg"),
                      style = "background:#E6F1FB; border:2px solid #1170AA; border-radius:8px; padding:8px; cursor:pointer;",
                      onclick = paste0("Shiny.setInputValue('", ns("algoritmo"), "', 'logreg', {priority:'event'})"),
                      tags$p(style="font-size:12px; font-weight:600; margin:0;",
                             bsicons::bs_icon("bar-chart-line", class="me-1"), "Reg. Log\u00edstica"),
                      tags$p(style="font-size:10px; color:#555; margin:0;", "R\u00e1pido, interpretable")
                    ),

                    # Random Forest
                    tags$div(
                      id = ns("card_rf"),
                      style = "background:var(--color-background-secondary); border:1.5px solid var(--color-border-tertiary); border-radius:8px; padding:8px; cursor:pointer;",
                      onclick = paste0("Shiny.setInputValue('", ns("algoritmo"), "', 'rf', {priority:'event'})"),
                      tags$p(style="font-size:12px; font-weight:600; margin:0;",
                             bsicons::bs_icon("tree", class="me-1"), "Random Forest"),
                      tags$p(style="font-size:10px; color:#555; margin:0;", "Robusto, no lineal")
                    ),

                    # XGBoost
                    tags$div(
                      id = ns("card_xgb"),
                      style = "background:var(--color-background-secondary); border:1.5px solid var(--color-border-tertiary); border-radius:8px; padding:8px; cursor:pointer;",
                      onclick = paste0("Shiny.setInputValue('", ns("algoritmo"), "', 'xgb', {priority:'event'})"),
                      tags$p(style="font-size:12px; font-weight:600; margin:0;",
                             bsicons::bs_icon("lightning", class="me-1"), "XGBoost"),
                      tags$p(style="font-size:10px; color:#555; margin:0;", "Alto rendimiento")
                    ),

                    # GAM
                    tags$div(
                      id = ns("card_gam"),
                      style = "background:var(--color-background-secondary); border:1.5px solid var(--color-border-tertiary); border-radius:8px; padding:8px; cursor:pointer;",
                      onclick = paste0("Shiny.setInputValue('", ns("algoritmo"), "', 'gam', {priority:'event'})"),
                      tags$p(style="font-size:12px; font-weight:600; margin:0;",
                             bsicons::bs_icon("bezier2", class="me-1"), "GAM"),
                      tags$p(style="font-size:10px; color:#555; margin:0;", "Splines, interpretable")
                    )
                  ),
                  shinyjs::hidden(
                    textInput(ns("algoritmo"), label = NULL, value = "logreg")
                  )
                )
              ),

              # Opciones del algoritmo
              bslib::card(
                class = "mb-3",
                bslib::card_header(
                  bsicons::bs_icon("sliders", class = "me-1"),
                  "Opciones"
                ),
                bslib::card_body(
                  # GAM formula
                  conditionalPanel(
                    condition = paste0("input['", ns("algoritmo"), "'] == 'gam'"),
                    p(class = "small fw-bold mb-1", "F\u00f3rmula GAM:"),
                    p(class = "small text-muted mb-1",
                      "Generada autom\u00e1ticamente con splines para cada predictor."),
                    uiOutput(ns("formula_gam_ui")),
                    checkboxInput(ns("editar_formula"),
                                  "Editar f\u00f3rmula manualmente", value = FALSE),
                    conditionalPanel(
                      condition = paste0("input['", ns("editar_formula"), "']"),
                      textAreaInput(ns("formula_gam_manual"),
                                    label = NULL, rows = 3,
                                    placeholder = "presence ~ s(bio1) + s(bio2) + s(x, y)")
                    )
                  ),
                  # RF opciones
                  conditionalPanel(
                    condition = paste0("input['", ns("algoritmo"), "'] == 'rf'"),
                    numericInput(ns("rf_trees"), "N\u00famero de \u00e1rboles:",
                                 value = 500, min = 100, max = 2000, step = 100),
                    numericInput(ns("rf_mtry"),
                                 label = tagList("Variables por split (mtry)",
                                                 tags$small(class = "text-muted ms-1",
                                                            "vac\u00edo = \u221a(variables)")),
                                 value = NA, min = 1),
                  ),
                  # XGBoost opciones
                  conditionalPanel(
                    condition = paste0("input['", ns("algoritmo"), "'] == 'xgb'"),
                    numericInput(ns("xgb_trees"), "\u00c1rboles:",
                                 value = 200, min = 50, max = 1000, step = 50),
                    numericInput(ns("xgb_lr"), "Tasa de aprendizaje:",
                                 value = 0.1, min = 0.01, max = 0.5, step = 0.01)
                  ),
                  tags$hr(),
                  checkboxInput(ns("estandarizar"),
                                "Estandarizar variables (mean=0, sd=1)",
                                value = TRUE)
                )
              ),

              # CV espacial
              bslib::card(
                class = "mb-3",
                bslib::card_header(
                  bsicons::bs_icon("grid-3x3", class = "me-1"),
                  "Validaci\u00f3n cruzada espacial"
                ),
                bslib::card_body(
                  selectInput(ns("cv_method"),
                              "M\u00e9todo:",
                              choices = c("Block" = "block",
                                          "Cluster" = "cluster"),
                              selected = "block"),
                  conditionalPanel(
                    condition = paste0("input['", ns("cv_method"), "'] == 'block'"),
                    selectInput(ns("block_shape"),
                                "Forma del bloque:",
                                choices = c("Cuadrado" = "square",
                                            "Hex\u00e1gono" = "hexagon"),
                                selected = "square"),
                    uiOutput(ns("cellsize_ui"))
                  ),
                  numericInput(ns("cv_folds"), "N\u00famero de folds:",
                               value = 5, min = 2, max = 10),
                  numericInput(ns("cv_repeats"), "Repeticiones:",
                               value = 1, min = 1, max = 10),
                  helpText("Ej. 5 folds \u00d7 5 repeticiones = 25 modelos.")
                )
              ),

              actionButton(ns("ajustar_modelo"),
                           "Ajustar modelo",
                           class = "btn-primary w-100",
                           icon  = icon("play")),
              uiOutput(ns("estado_ajuste"))
            ),

            # Panel derecho — métricas
            div(
              bslib::card(
                class = "mb-3",
                bslib::card_header(
                  bsicons::bs_icon("bar-chart", class = "me-1"),
                  "M\u00e9tricas de validaci\u00f3n cruzada"
                ),
                bslib::card_body(
                  uiOutput(ns("tabla_metricas")),
                  br(),
                  downloadButton(ns("dl_metricas"), "Descargar m\u00e9tricas",
                                 class = "btn-outline-primary btn-sm w-100")
                )
              ),
              bslib::card(
                bslib::card_header(
                  bsicons::bs_icon("map", class = "me-1"),
                  "Bloques espaciales de CV"
                ),
                bslib::card_body(
                  plotOutput(ns("plot_bloques"), height = "400px")
                )
              )
            )
          )
        )
      ),

      # ══════════════════════════════════════════════════════
      # PESTAÑA 9: Interpretación
      # ══════════════════════════════════════════════════════
      bslib::nav_panel(
        title = tagList(bsicons::bs_icon("clipboard-check", class = "me-1"),
                        "Interpretaci\u00f3n"),
        div(
          class = "p-3",
          p(class = "small text-muted mb-3",
            "Importancia de variables y efectos parciales del modelo ajustado. ",
            "Requiere que el modelo haya sido ajustado en la pesta\u00f1a anterior."),

          bslib::layout_columns(
            col_widths = c(6, 6),
            fill = FALSE,

            # Importancia de variables
            bslib::card(
              class = "mb-3",
              bslib::card_header(
                bsicons::bs_icon("bar-chart-steps", class = "me-1"),
                "Importancia de variables"
              ),
              bslib::card_body(
                p(class = "small text-muted mb-2",
                  "Basada en permutaci\u00f3n de variables (DALEX). ",
                  "Mayor valor = mayor importancia."),
                bslib::layout_columns(
                  col_widths = c(6, 6), fill = FALSE,
                  actionButton(ns("calcular_importancia"),
                               "Calcular importancia",
                               class = "btn-outline-primary btn-sm w-100",
                               icon  = icon("calculator")),
                  downloadButton(ns("dl_importancia"), "Descargar",
                                 class = "btn-outline-secondary btn-sm w-100")
                ),
                br(),
                plotOutput(ns("plot_importancia"), height = "350px")
              )
            ),

            # Curva ROC
            bslib::card(
              class = "mb-3",
              bslib::card_header(
                bsicons::bs_icon("graph-up", class = "me-1"),
                "Curva ROC"
              ),
              bslib::card_body(
                plotOutput(ns("plot_roc"), height = "350px")
              )
            )
          ),

          # PDP
          bslib::card(
            class = "mb-0",
            bslib::card_header(
              bsicons::bs_icon("bezier2", class = "me-1"),
              "Gr\u00e1ficos de dependencia parcial (PDP)"
            ),
            bslib::card_body(
              bslib::layout_columns(
                col_widths = c(3, 9),
                fill = FALSE,
                div(
                  uiOutput(ns("sel_vars_pdp")),
                  actionButton(ns("calcular_pdp"),
                               "Calcular PDP",
                               class = "btn-outline-primary btn-sm w-100 mt-2",
                               icon  = icon("play")),
                  br(),
                  downloadButton(ns("dl_pdp"), "Descargar PDP",
                                 class = "btn-outline-secondary btn-sm w-100 mt-1")
                ),
                plotOutput(ns("plot_pdp"), height = "300px")
              )
            )
          )
        )
      ),

      # ══════════════════════════════════════════════════════
      # PESTAÑA 10: Predicción
      # ══════════════════════════════════════════════════════
      bslib::nav_panel(
        title = tagList(bsicons::bs_icon("map-fill", class = "me-1"),
                        "Predicci\u00f3n"),
        div(
          class = "p-3",
          bslib::navset_tab(

            # ── Sub-pestaña: Predicción ──────────────────────────
            bslib::nav_panel(
              title = tagList(bsicons::bs_icon("palette", class = "me-1"),
                              "Predicci\u00f3n"),
              div(
                class = "pt-3",
                p(class = "small text-muted mb-3",
                  "Genera el mapa de idoneidad de h\u00e1bitat usando el modelo ajustado. ",
                  "Requiere que el modelo haya sido ajustado previamente."),

                bslib::layout_columns(
                  col_widths = c(3, 9),
                  fill = FALSE,

                  div(
                    bslib::card(
                      class = "mb-3",
                      bslib::card_header(
                        bsicons::bs_icon("gear", class = "me-1"),
                        "Opciones"
                      ),
                      bslib::card_body(
                        p(class = "small text-muted mb-2",
                          "La predicci\u00f3n usa la grilla con variables extra\u00eddas."),
                        actionButton(ns("predecir"),
                                     "Generar predicci\u00f3n",
                                     class = "btn-primary w-100 mb-2",
                                     icon  = icon("play")),
                        uiOutput(ns("resumen_prediccion")),
                        br(),
                        downloadButton(ns("dl_pred_cont"),
                                       "Descargar continuo (.gpkg)",
                                       class = "btn-outline-primary btn-sm w-100 mb-1"),
                        downloadButton(ns("dl_pred_cat"),
                                       "Descargar categ\u00f3rico (.gpkg)",
                                       class = "btn-outline-primary btn-sm w-100")
                      )
                    )
                  ),

                  div(
                    bslib::layout_columns(
                      col_widths = c(6, 6),
                      fill = FALSE,
                      bslib::card(
                        bslib::card_header(
                          bsicons::bs_icon("palette", class = "me-1"),
                          "Idoneidad continua (0\u20131)"
                        ),
                        bslib::card_body(class = "p-0",
                          leaflet::leafletOutput(ns("mapa_pred_continuo"),
                                                height = "600px")
                        )
                      ),
                      bslib::card(
                        bslib::card_header(
                          bsicons::bs_icon("layers", class = "me-1"),
                          "Categor\u00edas de h\u00e1bitat (cuantiles)"
                        ),
                        bslib::card_body(class = "p-0",
                          leaflet::leafletOutput(ns("mapa_pred_cat"),
                                                height = "600px")
                        )
                      )
                    )
                  )
                )
              )
            ),

            # ── Sub-pestaña: AOA ─────────────────────────────────
            bslib::nav_panel(
              title = tagList(bsicons::bs_icon("shield-check", class = "me-1"),
                              "AOA"),
              div(
                class = "pt-3",
                p(class = "small text-muted mb-3",
                  "El \u00c1rea de Aplicabilidad (AOA) indica d\u00f3nde el modelo puede ",
                  "predecir con confianza. El \u00cdndice de Disimilaridad (DI) ",
                  "muestra la distancia de cada hex\u00e1gono al espacio ambiental ",
                  "de entrenamiento."),

                bslib::layout_columns(
                  col_widths = c(3, 9),
                  fill = FALSE,

                  div(
                    bslib::card(
                      class = "mb-3",
                      bslib::card_header(
                        bsicons::bs_icon("gear", class = "me-1"),
                        "Opciones"
                      ),
                      bslib::card_body(
                        p(class = "small text-muted mb-2",
                          "Requiere que la predicci\u00f3n haya sido generada."),
                        actionButton(ns("calcular_aoa"),
                                     "Calcular AOA",
                                     class = "btn-primary w-100 mb-2",
                                     icon  = icon("shield")),
                        uiOutput(ns("resumen_aoa")),
                        br(),
                        downloadButton(ns("dl_aoa"),
                                       "Descargar AOA (.gpkg)",
                                       class = "btn-outline-primary btn-sm w-100"),
                        br(),
                        tags$hr(),
                        p(class = "small fw-bold mb-1", "Área de Aplicabilidad (AOA)"),
                        p(class = "small text-muted mb-2",
                          "El AOA delimita la región geográfica donde el modelo puede hacer ",
                          "predicciones confiables. Se basa en comparar las condiciones ambientales ",
                          "de cada hexágono con las del conjunto de entrenamiento. Los hexágonos ",
                          "fuera del AOA están en condiciones ambientales no representadas por los ",
                          "datos de presencia/ausencia usados para entrenar el modelo — las ",
                          "predicciones ahí no son confiables."),
                        p(class = "small fw-bold mb-1", "Índice de Disimilaridad (DI)"),
                        p(class = "small text-muted mb-0",
                          "El DI mide qué tan diferente es cada hexágono del espacio ambiental de ",
                          "entrenamiento. Se calcula como la distancia euclidiana entre los valores ",
                          "de las variables predictoras de cada hexágono y los puntos de entrenamiento ",
                          "más cercanos. Valores bajos indican que el hexágono está en condiciones ",
                          "ambientales bien representadas por los datos de entrenamiento y el modelo ",
                          "puede predecir con confianza. Valores altos indican condiciones poco ",
                          "representadas donde las predicciones son menos confiables. El umbral del ",
                          "AOA se define a partir de la media de las distancias euclidianas entre ",
                          "todos los pares de puntos de entrenamiento en el espacio ambiental — un ",
                          "hexágono queda fuera del AOA cuando su DI supera ese umbral. ",
                          "El DI no está acotado entre 0 y 1.")
                      )
                    )
                  ),

                  div(
                    bslib::layout_columns(
                      col_widths = c(6, 6),
                      fill = FALSE,
                      bslib::card(
                        bslib::card_header(
                          bsicons::bs_icon("shield-check", class = "me-1"),
                          "\u00c1rea de Aplicabilidad"
                        ),
                        bslib::card_body(class = "p-0",
                          leaflet::leafletOutput(ns("mapa_aoa"),
                                                height = "550px")
                        )
                      ),
                      bslib::card(
                        bslib::card_header(
                          bsicons::bs_icon("graph-up", class = "me-1"),
                          "\u00cdndice de Disimilaridad (DI)"
                        ),
                        bslib::card_body(class = "p-0",
                          leaflet::leafletOutput(ns("mapa_di"),
                                                height = "550px")
                        )
                      )
                    ),
                    br(),
                    bslib::layout_columns(
                      col_widths = c(6, 6),
                      fill = FALSE,
                      bslib::card(
                        bslib::card_header(
                          bsicons::bs_icon("palette", class = "me-1"),
                          "Idoneidad dentro del AOA (continua)"
                        ),
                        bslib::card_body(class = "p-0",
                          leaflet::leafletOutput(ns("mapa_aoa_cont"),
                                                height = "550px")
                        )
                      ),
                      bslib::card(
                        bslib::card_header(
                          bsicons::bs_icon("layers", class = "me-1"),
                          "Categor\u00edas dentro del AOA"
                        ),
                        bslib::card_body(class = "p-0",
                          leaflet::leafletOutput(ns("mapa_aoa_cat"),
                                                height = "550px")
                        )
                      )
                    )
                  )
                )
              )
            )
          )
        )
      ),

      # ══════════════════════════════════════════════════════
      # PESTAÑA 11: Predicción futura
      # ══════════════════════════════════════════════════════
      bslib::nav_panel(
        title = tagList(bsicons::bs_icon("clock-history", class = "me-1"),
                        "Predicci\u00f3n futura"),
        div(
          class = "p-3",
          bslib::navset_tab(

            # ── Sub-pestaña: Predicción futura ───────────────────
            bslib::nav_panel(
              title = tagList(bsicons::bs_icon("palette", class = "me-1"),
                              "Predicci\u00f3n futura"),
              div(
                class = "pt-3",
                p(class = "small text-muted mb-3",
                  "Genera un mapa de idoneidad futura usando el modelo ajustado ",
                  "y rasters de variables bajo un escenario futuro. ",
                  "Los rasters deben tener los mismos nombres de capas que los actuales."),

                bslib::layout_columns(
                  col_widths = c(3, 9),
                  fill = FALSE,

                  div(
                    bslib::card(
                      class = "mb-3",
                      bslib::card_header(
                        bsicons::bs_icon("info-circle", class = "me-1"),
                        "Variables del modelo"
                      ),
                      bslib::card_body(
                        uiOutput(ns("vars_modelo_futuro"))
                      )
                    ),
                    bslib::card(
                      class = "mb-3",
                      bslib::card_header(
                        bsicons::bs_icon("upload", class = "me-1"),
                        "Rasters futuros"
                      ),
                      bslib::card_body(
                        p(class = "small text-muted mb-2",
                          "Carga los rasters en el mismo CRS, recortados y ",
                          "enmascarados al AOI."),
                        fileInput(
                          ns("raster_futuro"),
                          label       = NULL,
                          accept      = c(".tif", ".tiff"),
                          multiple    = TRUE,
                          buttonLabel = "Buscar\u2026",
                          placeholder = "GeoTIFF (.tif)"
                        ),
                        uiOutput(ns("verificacion_vars_futuro"))
                      )
                    ),
                    actionButton(ns("predecir_futuro"),
                                 "Generar predicci\u00f3n futura",
                                 class = "btn-primary w-100 mb-2",
                                 icon  = icon("play")),
                    uiOutput(ns("resumen_pred_futuro")),
                    br(),
                    downloadButton(ns("dl_pred_futuro_cont"),
                                   "Descargar continuo (.gpkg)",
                                   class = "btn-outline-primary btn-sm w-100 mb-1"),
                    downloadButton(ns("dl_pred_futuro_cat"),
                                   "Descargar categ\u00f3rico (.gpkg)",
                                   class = "btn-outline-primary btn-sm w-100")
                  ),

                  div(
                    bslib::layout_columns(
                      col_widths = c(6, 6),
                      fill = FALSE,
                      bslib::card(
                        bslib::card_header(
                          bsicons::bs_icon("palette", class = "me-1"),
                          "Idoneidad futura continua (0\u20131)"
                        ),
                        bslib::card_body(class = "p-0",
                          leaflet::leafletOutput(ns("mapa_futuro_cont"),
                                                height = "500px")
                        )
                      ),
                      bslib::card(
                        bslib::card_header(
                          bsicons::bs_icon("layers", class = "me-1"),
                          "Categor\u00edas de h\u00e1bitat futuro"
                        ),
                        bslib::card_body(class = "p-0",
                          leaflet::leafletOutput(ns("mapa_futuro_cat"),
                                                height = "500px")
                        )
                      )
                    )
                  )
                )
              )
            ),

            # ── Sub-pestaña: AOA futuro ──────────────────────────
            bslib::nav_panel(
              title = tagList(bsicons::bs_icon("shield-check", class = "me-1"),
                              "AOA"),
              div(
                class = "pt-3",
                p(class = "small text-muted mb-3",
                  "El \u00c1rea de Aplicabilidad (AOA) para el escenario futuro indica ",
                  "d\u00f3nde el modelo puede predecir con confianza bajo condiciones ",
                  "clim\u00e1ticas futuras."),

                bslib::layout_columns(
                  col_widths = c(3, 9),
                  fill = FALSE,

                  div(
                    bslib::card(
                      class = "mb-3",
                      bslib::card_header(
                        bsicons::bs_icon("gear", class = "me-1"),
                        "Opciones"
                      ),
                      bslib::card_body(
                        p(class = "small text-muted mb-2",
                          "Requiere que la predicci\u00f3n futura haya sido generada."),
                        actionButton(ns("calcular_aoa_futuro"),
                                     "Calcular AOA futuro",
                                     class = "btn-primary w-100 mb-2",
                                     icon  = icon("shield")),
                        uiOutput(ns("resumen_aoa_futuro")),
                        br(),
                        downloadButton(ns("dl_aoa_futuro"),
                                       "Descargar AOA futuro (.gpkg)",
                                       class = "btn-outline-primary btn-sm w-100")
                      )
                    )
                  ),

                  div(
                    bslib::layout_columns(
                      col_widths = c(6, 6),
                      fill = FALSE,
                      bslib::card(
                        bslib::card_header(
                          bsicons::bs_icon("shield-check", class = "me-1"),
                          "\u00c1rea de Aplicabilidad futura"
                        ),
                        bslib::card_body(class = "p-0",
                          leaflet::leafletOutput(ns("mapa_aoa_futuro"),
                                                height = "550px")
                        )
                      ),
                      bslib::card(
                        bslib::card_header(
                          bsicons::bs_icon("graph-up", class = "me-1"),
                          "\u00cdndice de Disimilaridad futuro (DI)"
                        ),
                        bslib::card_body(class = "p-0",
                          leaflet::leafletOutput(ns("mapa_di_futuro"),
                                                height = "550px")
                        )
                      )
                    ),
                    br(),
                    bslib::layout_columns(
                      col_widths = c(6, 6),
                      fill = FALSE,
                      bslib::card(
                        bslib::card_header(
                          bsicons::bs_icon("palette", class = "me-1"),
                          "Idoneidad futura dentro del AOA (continua)"
                        ),
                        bslib::card_body(class = "p-0",
                          leaflet::leafletOutput(ns("mapa_aoa_futuro_cont"),
                                                height = "550px")
                        )
                      ),
                      bslib::card(
                        bslib::card_header(
                          bsicons::bs_icon("layers", class = "me-1"),
                          "Categor\u00edas futuras dentro del AOA"
                        ),
                        bslib::card_body(class = "p-0",
                          leaflet::leafletOutput(ns("mapa_aoa_futuro_cat"),
                                                height = "550px")
                        )
                      )
                    )
                  )
                )
              )
            )
          )
        )
      ),
      bslib::nav_panel(
        title = tagList(bsicons::bs_icon("code-slash", class = "me-1"),
                        "C\u00f3digo R"),
        div(
          class = "p-3",
          p(class = "small text-muted mb-3",
            "C\u00f3digo R reproducible que replica el an\u00e1lisis realizado en la app. ",
            "Requiere que el modelo haya sido ajustado."),
          bslib::layout_columns(
            col_widths = c(2, 10),
            fill = FALSE,
            div(
              downloadButton(ns("descargar_codigo"),
                             "Descargar .R",
                             class = "btn-outline-primary btn-sm w-100"),
              br(), br(),
              actionButton(ns("copiar_codigo"),
                           "Copiar",
                           class = "btn-outline-secondary btn-sm w-100",
                           icon  = icon("copy"))
            ),
            div(
              verbatimTextOutput(ns("codigo_r"))
            )
          )
        )
      )

    ) # /navset_tab
  )
}

# ── Server ───────────────────────────────────────────────
mod_h3sdm_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Selector de CRS de trabajo — aparece solo cuando hay AOI
    output$sel_proyeccion <- renderUI({
      req(aoi_sf())
      tagList(
        tags$hr(),
        p(class = "small fw-bold mb-1",
          bsicons::bs_icon("globe2", class = "me-1"),
          "CRS de trabajo:"),
        p(class = "small text-muted mb-2",
          "Define la proyecci\u00f3n que se usar\u00e1 al extraer variables y generar el ",
          "dataset PA. La grilla siempre se genera en WGS84 (H3 trabaja en esf\u00e9rico) ",
          "y se transforma a este CRS en el momento de la extracci\u00f3n. ",
          "Usa 4326 para \u00e1reas grandes o multiples zonas UTM; usa un CRS proyectado ",
          "(ej. 5367 para Costa Rica) para m\u00e9tricas del paisaje m\u00e1s precisas."),
        p(class = "small text-muted mb-1",
          "CRS actual: ", code(paste0("EPSG:", crs_trabajo()))),
        numericInput(
          ns("crs_custom"),
          label = "C\u00f3digo EPSG:",
          value = crs_trabajo(),
          min   = 1
        ),
        actionButton(ns("aplicar_proyeccion"),
                     "Aplicar CRS de trabajo",
                     class = "btn-outline-primary btn-sm w-100",
                     icon  = icon("globe"))
      )
    })

    # CRS de trabajo para extracción y PA (4326 por defecto)
    crs_trabajo <- reactiveVal(4326)

    observeEvent(input$aplicar_proyeccion, {
      req(input$crs_custom)
      tryCatch({
        sf::st_crs(as.integer(input$crs_custom))  # validar EPSG
        crs_trabajo(as.integer(input$crs_custom))
        tipo <- if (input$crs_custom == 4326) "geogr\u00e1fico (WGS84)" else "proyectado"
        showNotification(
          paste0("CRS de trabajo: EPSG:", input$crs_custom, " (", tipo, "). ",
                 "La grilla se transformar\u00e1 a este CRS al extraer variables ",
                 "y al generar el dataset PA. ",
                 "Aseg\u00farate de que tus rasters est\u00e9n en la misma proyecci\u00f3n."),
          type = "message", duration = 10)
      }, error = function(e) {
        showNotification(paste("EPSG no v\u00e1lido:", conditionMessage(e)),
                         type = "error")
      })
    })

    # Cellsize dinámico según CRS del dataset PA
    output$cellsize_ui <- renderUI({
      tagList(
        numericInput(ns("block_size"),
                     label = tagList("Tama\u00f1o del bloque (grados)",
                                     tags$small(class = "text-muted ms-1",
                                                "0.5\u00b0 \u2248 55 km")),
                     value = 0.5, min = 0.01, step = 0.1)
      )
    })

    # ── Predicción futura ─────────────────────────────────
    pred_futuro_sf <- reactiveVal(NULL)

    output$mapa_futuro_cont <- leaflet::renderLeaflet({
      leaflet::leaflet() |>
        leaflet::addProviderTiles(leaflet::providers$CartoDB.Positron) |>
        leaflet::setView(lng = 0, lat = 20, zoom = 2)
    })

    output$mapa_futuro_cat <- leaflet::renderLeaflet({
      leaflet::leaflet() |>
        leaflet::addProviderTiles(leaflet::providers$CartoDB.Positron) |>
        leaflet::setView(lng = 0, lat = 20, zoom = 2)
    })

    # Variables del modelo actual
    output$vars_modelo_futuro <- renderUI({
      gc <- grilla_con_vars()
      if (is.null(gc)) return(
        p(class = "small text-muted",
          "Extrae variables y ajusta el modelo primero.")
      )
      vars <- setdiff(names(sf::st_drop_geometry(gc)), "h3_address")
      tagList(
        p(class = "small text-muted mb-1",
          "Los rasters futuros deben tener estas capas:"),
        tags$ul(class = "small mb-0",
                lapply(vars, function(v) tags$li(code(v))))
      )
    })

    # Verificar que los rasters futuros tienen las variables correctas
    output$verificacion_vars_futuro <- renderUI({
      req(input$raster_futuro, grilla_con_vars())
      gc   <- grilla_con_vars()
      vars_modelo <- setdiff(names(sf::st_drop_geometry(gc)), "h3_address")

      tryCatch({
        rasters <- lapply(input$raster_futuro$datapath, terra::rast)
        stack   <- if (length(rasters) > 1) do.call(c, rasters) else rasters[[1]]
        vars_futuro <- names(stack)

        faltantes <- setdiff(vars_modelo, vars_futuro)
        extras    <- setdiff(vars_futuro, vars_modelo)

        if (length(faltantes) == 0) {
          div(class = "alert alert-success small py-2 px-3 mb-0",
              bsicons::bs_icon("check-circle-fill", class = "me-1"),
              "Todas las variables coinciden.")
        } else {
          div(class = "alert alert-danger small py-2 px-3 mb-0",
              bsicons::bs_icon("x-circle-fill", class = "me-1"),
              strong("Faltan: "), paste(faltantes, collapse = ", "))
        }
      }, error = function(e) NULL)
    })

    # Generar predicción futura
    observeEvent(input$predecir_futuro, {
      req(modelo_ajustado(), grilla_con_vars(), input$raster_futuro)

      withProgress(message = "Generando predicci\u00f3n futura\u2026", {
        tryCatch({
          m  <- modelo_ajustado()
          gc <- grilla_con_vars()
          gc_dedup <- gc[!duplicated(gc$h3_address), ]

          # Cargar rasters futuros
          rasters <- lapply(input$raster_futuro$datapath, terra::rast)
          stack   <- if (length(rasters) > 1) do.call(c, rasters) else rasters[[1]]

          # Verificar variables
          vars_modelo  <- setdiff(names(sf::st_drop_geometry(gc_dedup)), "h3_address")
          vars_futuro  <- names(stack)
          faltantes    <- setdiff(vars_modelo, vars_futuro)
          if (length(faltantes) > 0) {
            showNotification(
              paste0("Faltan variables: ", paste(faltantes, collapse = ", ")),
              type = "error", duration = 8)
            return()
          }

          # Extraer variables futuras sobre grilla limpia
          grilla_limpia <- grilla_sf()
          result_fut    <- h3sdm::h3sdm_extract_num(stack[[vars_modelo]], grilla_limpia)
          pred_futuro   <- h3sdm::h3sdm_predictors(
            result_fut[!duplicated(result_fut$h3_address), ])

          p <- h3sdm::h3sdm_predict(m, pred_futuro)
          pred_futuro_sf(p)

          # Visualizar
          p_vis <- suppressWarnings(sf::st_cast(p, "POLYGON")) |> sf::st_transform(4326)
          bbox  <- sf::st_bbox(p_vis)
          vals  <- p_vis$prediction

          # Mapa continuo
          pal_cont <- leaflet::colorNumeric("inferno", domain = c(0,1), reverse = TRUE)
          leaflet::leafletProxy(ns("mapa_futuro_cont")) |>
            leaflet::clearShapes() |> leaflet::clearControls() |>
            leafgl::addGlPolygons(
              data = p_vis, fillColor = ~pal_cont(prediction),
              fillOpacity = 0.85, color = "transparent", weight = 0) |>
            leaflet::addLegend(position = "bottomright", pal = pal_cont,
                               values = c(0,1), title = "Idoneidad", opacity = 0.8) |>
            leaflet::fitBounds(bbox[["xmin"]], bbox[["ymin"]],
                               bbox[["xmax"]], bbox[["ymax"]])

          # Mapa categórico
          breaks      <- quantile(vals, probs = c(0,.2,.4,.6,.8,1), na.rm = TRUE)
          etiquetas   <- c("Muy bajo","Bajo","Medio","Alto","Muy alto")
          colores_cat <- c("#d73027","#fc8d59","#fee08b","#91cf60","#1a9850")
          p_vis$categoria <- factor(
            cut(vals, breaks = breaks, labels = etiquetas, include.lowest = TRUE),
            levels = etiquetas, ordered = TRUE)
          pal_cat <- leaflet::colorFactor(palette = colores_cat,
                                          levels = etiquetas, ordered = TRUE)
          leaflet::leafletProxy(ns("mapa_futuro_cat")) |>
            leaflet::clearShapes() |> leaflet::clearControls() |>
            leafgl::addGlPolygons(
              data = p_vis, fillColor = ~pal_cat(categoria),
              fillOpacity = 0.85, color = "transparent", weight = 0) |>
            leaflet::addLegend(position = "bottomright",
                               colors = colores_cat, labels = etiquetas,
                               title = "H\u00e1bitat", opacity = 0.8) |>
            leaflet::fitBounds(bbox[["xmin"]], bbox[["ymin"]],
                               bbox[["xmax"]], bbox[["ymax"]])

          showNotification("Predicci\u00f3n futura generada.",
                           type = "message", duration = 4)

        }, error = function(e) {
          showNotification(paste("Error:", conditionMessage(e)),
                           type = "error", duration = 8)
        })
      })
    })

    output$resumen_pred_futuro <- renderUI({
      p <- pred_futuro_sf()
      if (is.null(p)) return(NULL)
      vals <- p$prediction
      div(class = "alert alert-info small py-2 px-3 mt-2 mb-0",
          bsicons::bs_icon("check-circle-fill", class = "me-1"),
          strong(nrow(p)), " hex\u00e1gonos",
          tags$br(),
          "Media: ", strong(round(mean(vals, na.rm = TRUE), 3)),
          tags$br(),
          "Rango: ", strong(round(min(vals, na.rm = TRUE), 3)),
          " \u2013 ", strong(round(max(vals, na.rm = TRUE), 3)))
    })

    output$dl_pred_futuro_cont <- downloadHandler(
      filename = function() paste0("prediccion_futura_continua_", Sys.Date(), ".gpkg"),
      content  = function(file) {
        req(pred_futuro_sf())
        sf::st_write(pred_futuro_sf(), file, delete_dsn = TRUE, quiet = TRUE)
      }
    )

    output$dl_pred_futuro_cat <- downloadHandler(
      filename = function() paste0("prediccion_futura_categorica_", Sys.Date(), ".gpkg"),
      content  = function(file) {
        req(pred_futuro_sf())
        p      <- pred_futuro_sf()
        breaks <- quantile(p$prediction, probs = c(0,.2,.4,.6,.8,1), na.rm = TRUE)
        etiquetas <- c("Muy bajo","Bajo","Medio","Alto","Muy alto")
        p$categoria <- cut(p$prediction, breaks = breaks,
                           labels = etiquetas, include.lowest = TRUE)
        sf::st_write(p, file, delete_dsn = TRUE, quiet = TRUE)
      }
    )

    # ── Descargas ─────────────────────────────────────────

    # Registros
    output$dl_registros <- downloadHandler(
      filename = function() paste0("registros_", Sys.Date(), ".csv"),
      content  = function(file) {
        req(registros_sf())
        write.csv(sf::st_drop_geometry(registros_sf()), file, row.names = FALSE)
      }
    )

    # Grilla
    output$dl_grilla <- downloadHandler(
      filename = function() paste0("grilla_h3_", Sys.Date(), ".gpkg"),
      content  = function(file) {
        req(grilla_sf())
        sf::st_write(grilla_sf(), file, delete_dsn = TRUE, quiet = TRUE)
      }
    )

    # Datos para modelar (PA)
    output$dl_pa <- downloadHandler(
      filename = function() paste0("datos_modelar_", Sys.Date(), ".csv"),
      content  = function(file) {
        req(dataset_pa())
        write.csv(sf::st_drop_geometry(dataset_pa()), file, row.names = FALSE)
      }
    )

    # Métricas
    output$dl_metricas <- downloadHandler(
      filename = function() paste0("metricas_", Sys.Date(), ".csv"),
      content  = function(file) {
        req(modelo_ajustado())
        metrics <- tryCatch(
          tune::collect_metrics(modelo_ajustado()$cv_model),
          error = function(e) NULL
        )
        req(metrics)
        write.csv(as.data.frame(metrics), file, row.names = FALSE)
      }
    )

    # Importancia
    output$dl_importancia <- downloadHandler(
      filename = function() paste0("importancia_", Sys.Date(), ".csv"),
      content  = function(file) {
        req(importancia_df())
        write.csv(as.data.frame(importancia_df()), file, row.names = FALSE)
      }
    )

    # PDP
    output$dl_pdp <- downloadHandler(
      filename = function() paste0("pdp_", Sys.Date(), ".png"),
      content  = function(file) {
        req(explainer_obj(), input$vars_pdp)
        pdp <- ingredients::partial_dependence(explainer_obj(),
                                               variables = input$vars_pdp)
        p <- plot(pdp) +
          ggplot2::theme_minimal(base_size = 12) +
          ggplot2::labs(title = NULL, subtitle = NULL, color = NULL) +
          ggplot2::theme(legend.position = "none")
        ggplot2::ggsave(file, p, width = 8, height = 5, dpi = 150)
      }
    )

    # Predicción continua
    output$dl_pred_cont <- downloadHandler(
      filename = function() paste0("prediccion_continua_", Sys.Date(), ".gpkg"),
      content  = function(file) {
        req(prediccion_sf())
        sf::st_write(prediccion_sf(), file, delete_dsn = TRUE, quiet = TRUE)
      }
    )

    # Predicción categórica
    output$dl_pred_cat <- downloadHandler(
      filename = function() paste0("prediccion_categorica_", Sys.Date(), ".gpkg"),
      content  = function(file) {
        req(prediccion_sf())
        p  <- prediccion_sf()
        breaks <- quantile(p$prediction, probs = c(0, 0.2, 0.4, 0.6, 0.8, 1),
                           na.rm = TRUE)
        etiquetas <- c("Muy bajo", "Bajo", "Medio", "Alto", "Muy alto")
        p$categoria <- cut(p$prediction, breaks = breaks,
                           labels = etiquetas, include.lowest = TRUE)
        sf::st_write(p, file, delete_dsn = TRUE, quiet = TRUE)
      }
    )

    # ── Código R ──────────────────────────────────────────
    codigo_generado <- reactive({
      m   <- modelo_ajustado()
      pa  <- dataset_pa()
      gc  <- grilla_con_vars()
      alg <- algoritmo_activo()

      # Encabezado
      cod <- paste0(
        "# ============================================\n",
        "# StatH3sdm \u00b7 StatSuite\n",
        "# Generado: ", format(Sys.Date(), "%Y-%m-%d"), "\n",
        "# Manuel Sp\u00ednola \u00b7 ICOMVIS \u00b7 UNA \u00b7 Costa Rica\n",
        "# ============================================\n\n",

        "library(h3sdm)\n",
        "library(sf)\n",
        "library(terra)\n",
        "library(dplyr)\n",
        "library(tidymodels)\n",
        "library(spatialsample)\n\n",

        "# 1. \u00c1rea de inter\u00e9s\n",
        "# aoi_sf <- sf::st_read(\"mi_aoi.gpkg\")\n\n",

        "# 2. Registros de ocurrencia\n",
        if (!is.null(pa)) {
          n_pres <- sum(sf::st_drop_geometry(pa)$presence == "1",
                        na.rm = TRUE)
          paste0("# Presencias: ", n_pres, "\n",
                 "# records <- h3sdm_get_records(\n",
                 "#   species   = \"Mi especie\",\n",
                 "#   aoi_sf    = aoi_sf,\n",
                 "#   providers = c(\"gbif\", \"inat\"),\n",
                 "#   limit     = 500\n",
                 "# )\n\n")
        } else "# records <- h3sdm_get_records(...)\n\n",

        "# 3. Grilla H3\n",
        if (!is.null(gc)) {
          paste0("h7 <- h3sdm_get_grid(aoi_sf, res = ",
                 isolate(input$resolucion_h3), ")\n\n")
        } else "h7 <- h3sdm_get_grid(aoi_sf, res = 7)\n\n",

        "# 4. Variables ambientales\n",
        if (!is.null(gc)) {
          vars <- setdiff(names(sf::st_drop_geometry(gc)), "h3_address")
          paste0("# bio <- terra::rast(\"mis_variables.tif\")\n",
                 "# Variables extraidas: ", paste(vars, collapse = ", "), "\n",
                 "bio_pred <- h3sdm_extract_num(bio, h7)\n",
                 "predictors <- h3sdm_predictors(bio_pred)\n\n")
        } else "# predictors <- h3sdm_predictors(...)\n\n",

        "# 5. Presencias / Pseudoausencias\n",
        paste0("pa <- h3sdm_pa_from_records(\n",
               "  records     = records,\n",
               "  aoi_sf      = aoi_sf,\n",
               "  res         = ", isolate(input$resolucion_h3), ",\n",
               "  n_pseudoabs = ", isolate(input$n_pseudoabs), ",\n",
               "  buffer_k    = ", isolate(input$buffer_k), "\n",
               ")\n\n"),

        "# 6. Combinar datos\n",
        "pa_base <- pa[, c(\"h3_address\", \"presence\")]\n",
        "dat <- h3sdm_data(pa_base, predictors)\n",
        "presence_data <- dat |> filter(presence == \"1\")\n\n",

        "# 7. Validaci\u00f3n cruzada espacial\n",
        paste0("scv <- h3sdm_spatial_cv(\n",
               "  dat,\n",
               "  method  = \"", isolate(input$cv_method), "\",\n",
               "  v       = ", isolate(input$cv_folds), ",\n",
               "  repeats = ", isolate(input$cv_repeats),
               if (isolate(input$cv_method) == "block")
                 paste0(",\n  cellsize = ", isolate(input$block_size),
                        ",\n  square   = ",
                        tolower(isolate(input$block_shape) == "square"))
               else "",
               "\n)\n\n"),

        "# 8. Recipe y modelo\n",
        switch(alg,
          logreg = paste0(
            "rec <- h3sdm_recipe(dat)\n",
            if (isolate(input$estandarizar))
              "rec <- step_normalize(rec, all_numeric_predictors())\n"
            else "",
            "modelo <- logistic_reg() |>\n",
            "  set_engine(\"glm\") |>\n",
            "  set_mode(\"classification\")\n\n",
            "wf <- h3sdm_workflow(modelo, rec)\n\n"
          ),
          rf = paste0(
            "rec <- h3sdm_recipe(dat)\n",
            if (isolate(input$estandarizar))
              "rec <- step_normalize(rec, all_numeric_predictors())\n"
            else "",
            "modelo <- rand_forest(\n",
            "  trees = ", isolate(input$rf_trees), "\n",
            ") |>\n",
            "  set_engine(\"ranger\") |>\n",
            "  set_mode(\"classification\")\n\n",
            "wf <- h3sdm_workflow(modelo, rec)\n\n"
          ),
          xgb = paste0(
            "rec <- h3sdm_recipe(dat)\n",
            if (isolate(input$estandarizar))
              "rec <- step_normalize(rec, all_numeric_predictors())\n"
            else "",
            "modelo <- boost_tree(\n",
            "  trees      = ", isolate(input$xgb_trees), ",\n",
            "  learn_rate = ", isolate(input$xgb_lr), "\n",
            ") |>\n",
            "  set_engine(\"xgboost\") |>\n",
            "  set_mode(\"classification\")\n\n",
            "wf <- h3sdm_workflow(modelo, rec)\n\n"
          ),
          gam = paste0(
            "rec <- h3sdm_recipe_gam(dat)\n",
            "modelo <- gen_additive_mod() |>\n",
            "  set_engine(\"mgcv\") |>\n",
            "  set_mode(\"classification\")\n\n",
            "formula_gam <- presence ~ ",
            paste(paste0("s(", setdiff(names(sf::st_drop_geometry(dat %||% pa)),
                                        c("h3_address", "presence", "x", "y")),
                          ")"), collapse = " + "),
            " + s(x, y, bs = \"tp\")\n\n",
            "wf <- h3sdm_workflow_gam(modelo, rec, formula_gam)\n\n"
          )
        ),

        "# 9. Ajustar modelo\n",
        "f <- h3sdm_fit_model(wf, scv, presence_data)\n\n",

        "# 10. M\u00e9tricas\n",
        "metricas <- h3sdm_eval_metrics(\n",
        "  fitted_model  = f$cv_model,\n",
        "  presence_data = presence_data\n",
        ")\n",
        "print(metricas)\n\n",

        "# 11. Predicci\u00f3n\n",
        "p <- h3sdm_predict(f, predictors)\n\n",

        "# 12. Interpretaci\u00f3n\n",
        "e <- h3sdm_explain(f$final_model, data = dat)\n",
        "vars_pred <- setdiff(names(e$data), c(\"h3_address\", \"x\", \"y\", \"presence\"))\n",
        "imp <- DALEX::model_parts(e, variables = vars_pred)\n",
        "plot(imp)\n\n",
        "pdp <- ingredients::partial_dependence(e, variables = vars_pred[1:2])\n",
        "plot(pdp)\n"
      )
      cod
    })

    output$codigo_r <- renderText({
      req(modelo_ajustado())
      codigo_generado()
    })

    output$descargar_codigo <- downloadHandler(
      filename = function() {
        paste0("StatH3sdm_", format(Sys.Date(), "%Y%m%d"), ".R")
      },
      content = function(file) {
        writeLines(codigo_generado(), file)
      }
    )

    # ── Predicción ────────────────────────────────────────
    prediccion_sf <- reactiveVal(NULL)

    output$mapa_pred_continuo <- leaflet::renderLeaflet({
      leaflet::leaflet() |>
        leaflet::addProviderTiles(leaflet::providers$CartoDB.Positron) |>
        leaflet::setView(lng = 0, lat = 20, zoom = 2)
    })

    output$mapa_pred_cat <- leaflet::renderLeaflet({
      leaflet::leaflet() |>
        leaflet::addProviderTiles(leaflet::providers$CartoDB.Positron) |>
        leaflet::setView(lng = 0, lat = 20, zoom = 2)
    })

    observeEvent(input$predecir, {
      req(modelo_ajustado(), grilla_con_vars())

      withProgress(message = "Generando predicci\u00f3n\u2026", {
        tryCatch({
          m  <- modelo_ajustado()
          gc <- grilla_con_vars()
          gc_dedup <- gc[!duplicated(gc$h3_address), ]
          pred_sf  <- h3sdm::h3sdm_predictors(gc_dedup)

          # Predecir
          p <- h3sdm::h3sdm_predict(m, pred_sf)
          prediccion_sf(p)

          # Transformar a WGS84 para leaflet
          p_vis <- suppressWarnings(sf::st_cast(p, "POLYGON")) |>
            sf::st_transform(4326)
          bbox  <- sf::st_bbox(p_vis)
          vals  <- p_vis$prediction

          # ── Mapa continuo ─────────────────────────────
          pal_cont <- leaflet::colorNumeric(
            palette = "inferno",
            domain  = c(0, 1),
            reverse = TRUE
          )
          leaflet::leafletProxy(ns("mapa_pred_continuo")) |>
            leaflet::clearShapes() |>
            leaflet::clearControls() |>
            leafgl::addGlPolygons(
              data        = p_vis,
              fillColor   = ~pal_cont(prediction),
              fillOpacity = 0.85,
              color       = "transparent",
              weight      = 0
            ) |>
            leaflet::addLegend(
              position = "bottomright",
              pal      = pal_cont,
              values   = c(0, 1),
              title    = "Idoneidad",
              opacity  = 0.8
            ) |>
            leaflet::fitBounds(bbox[["xmin"]], bbox[["ymin"]],
                               bbox[["xmax"]], bbox[["ymax"]])

          # ── Mapa categórico (cuantiles) ───────────────
          breaks <- c(0, 0.2, 0.4, 0.6, 0.8, 1)
          etiquetas <- c("Muy bajo", "Bajo", "Medio", "Alto", "Muy alto")
          colores_cat <- c("#d73027", "#fc8d59", "#fee08b", "#91cf60", "#1a9850")

          p_vis$categoria <- factor(
            cut(vals, breaks = breaks, labels = etiquetas,
                include.lowest = TRUE),
            levels = etiquetas, ordered = TRUE
          )

          pal_cat <- leaflet::colorFactor(
            palette = colores_cat,
            levels  = etiquetas,
            ordered = TRUE
          )

          leaflet::leafletProxy(ns("mapa_pred_cat")) |>
            leaflet::clearShapes() |>
            leaflet::clearControls() |>
            leafgl::addGlPolygons(
              data        = p_vis,
              fillColor   = ~pal_cat(categoria),
              fillOpacity = 0.85,
              color       = "transparent",
              weight      = 0
            ) |>
            leaflet::addLegend(
              position = "bottomright",
              colors   = colores_cat,
              labels   = etiquetas,
              title    = "H\u00e1bitat",
              opacity  = 0.8
            ) |>
            leaflet::fitBounds(bbox[["xmin"]], bbox[["ymin"]],
                               bbox[["xmax"]], bbox[["ymax"]])

          showNotification("Predicci\u00f3n generada.",
                           type = "message", duration = 4)

        }, error = function(e) {
          showNotification(paste("Error:", conditionMessage(e)),
                           type = "error", duration = 8)
        })
      })
    })

    output$resumen_prediccion <- renderUI({
      p <- prediccion_sf()
      if (is.null(p)) return(NULL)
      vals <- p$prediction
      div(class = "alert alert-info small py-2 px-3 mt-2 mb-0",
          bsicons::bs_icon("check-circle-fill", class = "me-1"),
          strong(nrow(p)), " hex\u00e1gonos",
          tags$br(),
          "Media: ", strong(round(mean(vals, na.rm = TRUE), 3)),
          tags$br(),
          "Rango: ", strong(round(min(vals, na.rm = TRUE), 3)),
          " \u2013 ", strong(round(max(vals, na.rm = TRUE), 3))
      )
    })

    # ── AOA presente ──────────────────────────────────────
    output$mapa_aoa <- leaflet::renderLeaflet({
      leaflet::leaflet() |>
        leaflet::addProviderTiles(leaflet::providers$CartoDB.Positron) |>
        leaflet::setView(lng = 0, lat = 20, zoom = 2)
    })

    output$mapa_di <- leaflet::renderLeaflet({
      leaflet::leaflet() |>
        leaflet::addProviderTiles(leaflet::providers$CartoDB.Positron) |>
        leaflet::setView(lng = 0, lat = 20, zoom = 2)
    })

    output$mapa_aoa_cont <- leaflet::renderLeaflet({
      leaflet::leaflet() |>
        leaflet::addProviderTiles(leaflet::providers$CartoDB.Positron) |>
        leaflet::setView(lng = 0, lat = 20, zoom = 2)
    })

    output$mapa_aoa_cat <- leaflet::renderLeaflet({
      leaflet::leaflet() |>
        leaflet::addProviderTiles(leaflet::providers$CartoDB.Positron) |>
        leaflet::setView(lng = 0, lat = 20, zoom = 2)
    })

    observeEvent(input$calcular_aoa, {
      req(prediccion_sf(), modelo_ajustado(), dat_rv())

      withProgress(message = "Calculando AOA\u2026", {
        tryCatch({
          p   <- prediccion_sf()
          m   <- modelo_ajustado()
          dat <- dat_rv()
          cv  <- cv_split_rv()

          result <- h3sdm::h3sdm_aoa(
            newdata    = p,
            train      = dat,
            fit_object = m,
            cv         = cv
          )

          result <- result |>
            dplyr::mutate(prediction_aoa = dplyr::if_else(AOA == 1L,
                                                          prediction,
                                                          NA_real_))
          aoa_sf(result)

          r_vis <- suppressWarnings(sf::st_cast(result, "POLYGON")) |>
            sf::st_transform(4326)
          bbox  <- sf::st_bbox(r_vis)
          n_out <- sum(result$AOA == 0L, na.rm = TRUE)
          pct   <- round(100 * n_out / nrow(result), 1)

                    # Reducir a columnas necesarias para leafgl
          r_vis <- r_vis[, c("h3_address", "prediction", "DI", "AOA", "prediction_aoa")]

          # ── Mapa AOA binario ──────────────────────────────────
          pal_aoa <- leaflet::colorFactor(
            palette  = c("#d9d9d9", "#2166ac"),
            levels   = c(0L, 1L),
            na.color = "#d9d9d9"
          )
          leaflet::leafletProxy(ns("mapa_aoa")) |>
            leaflet::clearShapes() |>
            leaflet::clearControls() |>
            leafgl::addGlPolygons(
              data        = r_vis,
              fillColor   = ~pal_aoa(AOA),
              fillOpacity = 0.85,
              color       = "transparent",
              weight      = 0
            ) |>
            leaflet::addLegend(
              position = "bottomright",
              colors   = c("#2166ac", "#d9d9d9"),
              labels   = c("Dentro del AOA", "Fuera del AOA"),
              title    = "AOA",
              opacity  = 0.8
            ) |>
            leaflet::fitBounds(bbox[["xmin"]], bbox[["ymin"]],
                               bbox[["xmax"]], bbox[["ymax"]])

          # ── Mapa DI ─────────────────────────────────────────
          pal_di <- leaflet::colorNumeric(
            palette  = "YlOrRd",
            domain   = r_vis$DI,
            na.color = "#d9d9d9"
          )
          leaflet::leafletProxy(ns("mapa_di")) |>
            leaflet::clearShapes() |>
            leaflet::clearControls() |>
            leafgl::addGlPolygons(
              data        = r_vis,
              fillColor   = ~pal_di(DI),
              fillOpacity = 0.85,
              color       = "transparent",
              weight      = 0
            ) |>
            leaflet::addLegend(
              position = "bottomright",
              pal      = pal_di,
              values   = r_vis$DI,
              title    = "DI",
              opacity  = 0.8
            ) |>
            leaflet::fitBounds(bbox[["xmin"]], bbox[["ymin"]],
                               bbox[["xmax"]], bbox[["ymax"]])

          # ── Mapa continuo (idoneidad dentro AOA) ────────────────
          pal_cont <- leaflet::colorNumeric(
            palette  = "inferno",
            domain   = c(0, 1),
            reverse  = TRUE,
            na.color = "#d9d9d9"
          )
          leaflet::leafletProxy(ns("mapa_aoa_cont")) |>
            leaflet::clearShapes() |>
            leaflet::clearControls() |>
            leafgl::addGlPolygons(
              data        = r_vis,
              fillColor   = ~pal_cont(prediction_aoa),
              fillOpacity = 0.85,
              color       = "transparent",
              weight      = 0
            ) |>
            leaflet::addLegend(
              position = "bottomright",
              pal      = pal_cont,
              values   = c(0, 1),
              title    = "Idoneidad\n(AOA)",
              opacity  = 0.8
            ) |>
            leaflet::fitBounds(bbox[["xmin"]], bbox[["ymin"]],
                               bbox[["xmax"]], bbox[["ymax"]])

          # ── Mapa categórico (idoneidad dentro AOA) ──────────────
          etiquetas   <- c("Muy bajo", "Bajo", "Medio", "Alto", "Muy alto")
          colores_cat <- c("#d73027", "#fc8d59", "#fee08b", "#91cf60", "#1a9850")
          vals_aoa    <- r_vis$prediction_aoa
          breaks_aoa  <- c(0, 0.2, 0.4, 0.6, 0.8, 1)
          r_vis$categoria_aoa <- factor(
            cut(vals_aoa, breaks = breaks_aoa, labels = etiquetas,
                include.lowest = TRUE),
            levels = etiquetas, ordered = TRUE
          )
          pal_cat <- leaflet::colorFactor(
            palette  = colores_cat,
            levels   = etiquetas,
            ordered  = TRUE,
            na.color = "#d9d9d9"
          )
          leaflet::leafletProxy(ns("mapa_aoa_cat")) |>
            leaflet::clearShapes() |>
            leaflet::clearControls() |>
            leafgl::addGlPolygons(
              data        = r_vis,
              fillColor   = ~pal_cat(categoria_aoa),
              fillOpacity = 0.85,
              color       = "transparent",
              weight      = 0
            ) |>
            leaflet::addLegend(
              position = "bottomright",
              colors   = c(colores_cat, "#d9d9d9"),
              labels   = c(etiquetas, "Fuera del AOA"),
              title    = "Hábitat\n(AOA)",
              opacity  = 0.8
            ) |>
            leaflet::fitBounds(bbox[["xmin"]], bbox[["ymin"]],
                               bbox[["xmax"]], bbox[["ymax"]])

          showNotification(
            paste0("AOA calculado. ", pct, "% de hexágonos fuera del AOA."),
            type = "message", duration = 4
          )

        }, error = function(e) {
          showNotification(paste("Error:", conditionMessage(e)),
                           type = "error", duration = 8)
        })
      })
    })

    output$resumen_aoa <- renderUI({
      r <- aoa_sf()
      if (is.null(r)) return(NULL)
      n_in  <- sum(r$AOA == 1L)
      n_out <- sum(r$AOA == 0L)
      pct   <- round(100 * n_out / nrow(r), 1)
      div(class = "alert alert-info small py-2 px-3 mt-2 mb-0",
          bsicons::bs_icon("check-circle-fill", class = "me-1"),
          strong(nrow(r)), " hex\u00e1gonos",
          tags$br(),
          "Dentro del AOA: ", strong(n_in),
          tags$br(),
          "Fuera del AOA: ", strong(n_out),
          " (", strong(pct), "%)"
      )
    })

    output$dl_aoa <- downloadHandler(
      filename = function() paste0("aoa_presente_", Sys.Date(), ".gpkg"),
      content  = function(file) {
        req(aoa_sf())
        sf::st_write(aoa_sf(), file, delete_dsn = TRUE, quiet = TRUE)
      }
    )

    # ── AOA futuro ────────────────────────────────────────
    output$mapa_aoa_futuro <- leaflet::renderLeaflet({
      leaflet::leaflet() |>
        leaflet::addProviderTiles(leaflet::providers$CartoDB.Positron) |>
        leaflet::setView(lng = 0, lat = 20, zoom = 2)
    })

    output$mapa_di_futuro <- leaflet::renderLeaflet({
      leaflet::leaflet() |>
        leaflet::addProviderTiles(leaflet::providers$CartoDB.Positron) |>
        leaflet::setView(lng = 0, lat = 20, zoom = 2)
    })

    output$mapa_aoa_futuro_cont <- leaflet::renderLeaflet({
      leaflet::leaflet() |>
        leaflet::addProviderTiles(leaflet::providers$CartoDB.Positron) |>
        leaflet::setView(lng = 0, lat = 20, zoom = 2)
    })

    output$mapa_aoa_futuro_cat <- leaflet::renderLeaflet({
      leaflet::leaflet() |>
        leaflet::addProviderTiles(leaflet::providers$CartoDB.Positron) |>
        leaflet::setView(lng = 0, lat = 20, zoom = 2)
    })

    observeEvent(input$calcular_aoa_futuro, {
      req(pred_futuro_sf(), modelo_ajustado(), dat_rv())

      withProgress(message = "Calculando AOA futuro\u2026", {
        tryCatch({
          p   <- pred_futuro_sf()
          m   <- modelo_ajustado()
          dat <- dat_rv()
          cv  <- cv_split_rv()

          result <- h3sdm::h3sdm_aoa(
            newdata    = p,
            train      = dat,
            fit_object = m,
            cv         = cv
          )

          result <- result |>
            dplyr::mutate(prediction_aoa = dplyr::if_else(AOA == 1L,
                                                          prediction,
                                                          NA_real_))
          aoa_futuro_sf(result)

          r_vis <- suppressWarnings(sf::st_cast(result, "POLYGON")) |>
            sf::st_transform(4326)
          bbox  <- sf::st_bbox(r_vis)
          n_out <- sum(result$AOA == 0L, na.rm = TRUE)
          pct   <- round(100 * n_out / nrow(result), 1)

          # Reducir a columnas necesarias para leafgl
          r_vis <- r_vis[, c("h3_address", "prediction", "DI", "AOA", "prediction_aoa")]

          etiquetas   <- c("Muy bajo", "Bajo", "Medio", "Alto", "Muy alto")
          colores_cat <- c("#d73027", "#fc8d59", "#fee08b", "#91cf60", "#1a9850")

          # ── Mapa AOA binario futuro ──────────────────────────
          pal_aoa <- leaflet::colorFactor(
            palette  = c("#d9d9d9", "#2166ac"),
            levels   = c(0L, 1L),
            na.color = "#d9d9d9"
          )
          leaflet::leafletProxy(ns("mapa_aoa_futuro")) |>
            leaflet::clearShapes() |>
            leaflet::clearControls() |>
            leafgl::addGlPolygons(
              data        = r_vis,
              fillColor   = ~pal_aoa(AOA),
              fillOpacity = 0.85,
              color       = "transparent",
              weight      = 0
            ) |>
            leaflet::addLegend(
              position = "bottomright",
              colors   = c("#2166ac", "#d9d9d9"),
              labels   = c("Dentro del AOA", "Fuera del AOA"),
              title    = "AOA futuro",
              opacity  = 0.8
            ) |>
            leaflet::fitBounds(bbox[["xmin"]], bbox[["ymin"]],
                               bbox[["xmax"]], bbox[["ymax"]])

          # ── Mapa DI futuro ─────────────────────────────────────────
          pal_di <- leaflet::colorNumeric(
            palette  = "YlOrRd",
            domain   = r_vis$DI,
            na.color = "#d9d9d9"
          )
          leaflet::leafletProxy(ns("mapa_di_futuro")) |>
            leaflet::clearShapes() |>
            leaflet::clearControls() |>
            leafgl::addGlPolygons(
              data        = r_vis,
              fillColor   = ~pal_di(DI),
              fillOpacity = 0.85,
              color       = "transparent",
              weight      = 0
            ) |>
            leaflet::addLegend(
              position = "bottomright",
              pal      = pal_di,
              values   = r_vis$DI,
              title    = "DI futuro",
              opacity  = 0.8
            ) |>
            leaflet::fitBounds(bbox[["xmin"]], bbox[["ymin"]],
                               bbox[["xmax"]], bbox[["ymax"]])

          # ── Mapa continuo futuro (idoneidad dentro AOA) ──────────────
          pal_cont <- leaflet::colorNumeric(
            palette  = "inferno",
            domain   = c(0, 1),
            reverse  = TRUE,
            na.color = "#d9d9d9"
          )
          leaflet::leafletProxy(ns("mapa_aoa_futuro_cont")) |>
            leaflet::clearShapes() |>
            leaflet::clearControls() |>
            leafgl::addGlPolygons(
              data        = r_vis,
              fillColor   = ~pal_cont(prediction_aoa),
              fillOpacity = 0.85,
              color       = "transparent",
              weight      = 0
            ) |>
            leaflet::addLegend(
              position = "bottomright",
              pal      = pal_cont,
              values   = c(0, 1),
              title    = "Idoneidad\nfutura (AOA)",
              opacity  = 0.8
            ) |>
            leaflet::fitBounds(bbox[["xmin"]], bbox[["ymin"]],
                               bbox[["xmax"]], bbox[["ymax"]])

          # ── Mapa categórico futuro (idoneidad dentro AOA) ────────────
          vals_aoa   <- r_vis$prediction_aoa
          breaks_aoa <- c(0, 0.2, 0.4, 0.6, 0.8, 1)
          r_vis$categoria_aoa <- factor(
            cut(vals_aoa, breaks = breaks_aoa, labels = etiquetas,
                include.lowest = TRUE),
            levels = etiquetas, ordered = TRUE
          )
          pal_cat <- leaflet::colorFactor(
            palette  = colores_cat,
            levels   = etiquetas,
            ordered  = TRUE,
            na.color = "#d9d9d9"
          )
          leaflet::leafletProxy(ns("mapa_aoa_futuro_cat")) |>
            leaflet::clearShapes() |>
            leaflet::clearControls() |>
            leafgl::addGlPolygons(
              data        = r_vis,
              fillColor   = ~pal_cat(categoria_aoa),
              fillOpacity = 0.85,
              color       = "transparent",
              weight      = 0
            ) |>
            leaflet::addLegend(
              position = "bottomright",
              colors   = c(colores_cat, "#d9d9d9"),
              labels   = c(etiquetas, "Fuera del AOA"),
              title    = "H\u00e1bitat\nfuturo (AOA)",
              opacity  = 0.8
            ) |>
            leaflet::fitBounds(bbox[["xmin"]], bbox[["ymin"]],
                               bbox[["xmax"]], bbox[["ymax"]])

          showNotification(
            paste0("AOA futuro calculado. ", pct,
                   "% de hex\u00e1gonos fuera del AOA."),
            type = "message", duration = 4
          )
        }, error = function(e) {
          showNotification(paste("Error:", conditionMessage(e)),
                           type = "error", duration = 8)
        })
      })
    })

    output$resumen_aoa_futuro <- renderUI({
      r <- aoa_futuro_sf()
      if (is.null(r)) return(NULL)
      n_in  <- sum(r$AOA == 1L)
      n_out <- sum(r$AOA == 0L)
      pct   <- round(100 * n_out / nrow(r), 1)
      div(class = "alert alert-info small py-2 px-3 mt-2 mb-0",
          bsicons::bs_icon("check-circle-fill", class = "me-1"),
          strong(nrow(r)), " hex\u00e1gonos",
          tags$br(),
          "Dentro del AOA: ", strong(n_in),
          tags$br(),
          "Fuera del AOA: ", strong(n_out),
          " (", strong(pct), "%)"
      )
    })

    output$dl_aoa_futuro <- downloadHandler(
      filename = function() paste0("aoa_futuro_", Sys.Date(), ".gpkg"),
      content  = function(file) {
        req(aoa_futuro_sf())
        sf::st_write(aoa_futuro_sf(), file, delete_dsn = TRUE, quiet = TRUE)
      }
    )


    # ── Interpretación ────────────────────────────────────
    explainer_obj  <- reactiveVal(NULL)
    importancia_df <- reactiveVal(NULL)

    # Calcular importancia
    observeEvent(input$calcular_importancia, {
      req(modelo_ajustado())
      withProgress(message = "Calculando importancia de variables\u2026", {
        tryCatch({
          m   <- modelo_ajustado()
          req(m)

          pa  <- dataset_pa(); req(pa)
          gc  <- grilla_con_vars(); req(gc)
          pa_base  <- pa[!duplicated(pa$h3_address), c("h3_address", "presence")]
          gc_dedup <- gc[!duplicated(gc$h3_address), ]
          pred_sf  <- h3sdm::h3sdm_predictors(gc_dedup)
          dat      <- h3sdm::h3sdm_data(pa_base, pred_sf)

          exp <- h3sdm::h3sdm_explain(m$final_model, data = dat)
          explainer_obj(exp)

          vars_pred <- setdiff(names(exp$data),
                               c("h3_address", "x", "y", "presence"))

          imp <- DALEX::model_parts(
            explainer = exp,
            variables = vars_pred,
            type      = "difference"
          )
          importancia_df(imp)
          showNotification("Importancia calculada.", type = "message", duration = 3)
        }, error = function(e) {
          showNotification(paste("Error:", conditionMessage(e)),
                           type = "error", duration = 8)
        })
      })
    })

    # Plot importancia
    output$plot_importancia <- renderPlot({
      imp <- importancia_df(); req(imp)
      df  <- as.data.frame(imp)
      df  <- df[df$permutation == 0 & df$variable != "_baseline_" &
                  df$variable != "_full_model_", ]
      df  <- df[order(df$dropout_loss, decreasing = TRUE), ]

      ggplot2::ggplot(df,
        ggplot2::aes(x = dropout_loss,
                     y = reorder(variable, dropout_loss),
                     fill = dropout_loss)) +
        ggplot2::geom_col(show.legend = FALSE) +
        ggplot2::scale_fill_gradient(low = colores$secundario,
                                     high = colores$primario) +
        ggplot2::labs(x = "P\u00e9rdida por permutaci\u00f3n",
                      y = NULL,
                      title = "Importancia de variables") +
        ggplot2::theme_minimal(base_size = 12) +
        ggplot2::theme(panel.grid.major.y = ggplot2::element_blank())
    })

    # Curva ROC
    output$plot_roc <- renderPlot({
      m <- modelo_ajustado(); req(m)
      tryCatch({
        preds <- tune::collect_predictions(m$cv_model)

        if (!".pred_1" %in% names(preds)) {
          p <- ggplot2::ggplot() +
            ggplot2::annotate("text", x = 0.5, y = 0.5,
                              label = "Predicciones no disponibles",
                              color = colores$texto) +
            ggplot2::theme_void()
          return(p)
        }

        roc_df <- yardstick::roc_curve(preds,
                                        truth    = presence,
                                        .pred_1,
                                        event_level = "second")
        auc_val <- yardstick::roc_auc(preds,
                                       truth    = presence,
                                       .pred_1,
                                       event_level = "second")$.estimate

        ggplot2::ggplot(roc_df,
          ggplot2::aes(x = 1 - specificity, y = sensitivity)) +
          ggplot2::geom_abline(slope = 1, intercept = 0,
                               linetype = "dashed", color = colores$texto) +
          ggplot2::geom_line(color = colores$primario, linewidth = 1.2) +
          ggplot2::annotate("text", x = 0.7, y = 0.1,
                            label = paste0("AUC = ", round(auc_val, 3)),
                            color = colores$primario, size = 5, fontface = "bold") +
          ggplot2::labs(x = "1 - Especificidad",
                        y = "Sensibilidad",
                        title = "Curva ROC") +
          ggplot2::theme_minimal(base_size = 12)
      }, error = function(e) {
        ggplot2::ggplot() +
          ggplot2::annotate("text", x = 0.5, y = 0.5,
                            label = paste("Error:", conditionMessage(e)),
                            color = colores$peligro, size = 4) +
          ggplot2::theme_void()
      })
    })

    # Selector de variables para PDP
    output$sel_vars_pdp <- renderUI({
      exp <- explainer_obj()
      if (is.null(exp)) {
        return(p(class = "small text-muted",
                 "Calcula importancia primero."))
      }
      vars <- setdiff(names(exp$data), c("h3_address", "x", "y", "presence"))
      checkboxGroupInput(
        ns("vars_pdp"),
        label   = "Variables (m\u00e1x. 2-3):",
        choices = vars,
        selected = vars[1:min(2, length(vars))]
      )
    })

    # Calcular y mostrar PDP
    observeEvent(input$calcular_pdp, {
      req(explainer_obj(), input$vars_pdp)
      withProgress(message = "Calculando PDP\u2026", {
        tryCatch({
          pdp <- ingredients::partial_dependence(
            explainer_obj(),
            variables = input$vars_pdp
          )
          output$plot_pdp <- renderPlot({
            plot(pdp) +
              ggplot2::theme_minimal(base_size = 12) +
              ggplot2::scale_color_manual(values = colores$tableau) +
              ggplot2::labs(title = NULL, subtitle = NULL, color = NULL) +
              ggplot2::theme(legend.position = "none")
          })
        }, error = function(e) {
          showNotification(paste("Error:", conditionMessage(e)),
                           type = "error", duration = 8)
        })
      })
    })

    # ── Ajustar modelo ────────────────────────────────────
    modelo_ajustado  <- reactiveVal(NULL)
    cv_split_rv      <- reactiveVal(NULL)
    algoritmo_activo <- reactiveVal("logreg")
    dat_rv           <- reactiveVal(NULL)
    aoa_sf           <- reactiveVal(NULL)
    aoa_futuro_sf    <- reactiveVal(NULL)

    # Sincronizar tarjeta activa
    observeEvent(input$algoritmo, {
      req(nchar(input$algoritmo) > 0)
      algoritmo_activo(input$algoritmo)
      colores_alg <- list(
        logreg = "background:#E6F1FB; border:2px solid #1170AA;",
        rf     = "background:#E1F5EE; border:2px solid #0F6E56;",
        xgb    = "background:#FFF3E0; border:2px solid #FC7D0B;",
        gam    = "background:#F3E9FD; border:2px solid #6B3FA0;"
      )
      base_style <- "border-radius:8px; padding:8px; cursor:pointer;"
      default    <- paste0("background:var(--color-background-secondary);",
                           "border:1.5px solid var(--color-border-tertiary);",
                           base_style)
      for (alg in c("logreg", "rf", "xgb", "gam")) {
        card_id <- paste0("#", ns(paste0("card_", alg)))
        estilo  <- if (alg == input$algoritmo)
          paste0(colores_alg[[alg]], base_style)
        else default
        shinyjs::runjs(paste0(
          'document.querySelector("', card_id,
          '").setAttribute("style", "', estilo, '");'
        ))
      }
    })

    # Fórmula GAM automática
    output$formula_gam_ui <- renderUI({
      pa <- dataset_pa(); req(pa)
      df   <- sf::st_drop_geometry(pa)
      vars <- setdiff(names(df), c("h3_address", "presence"))
      vars_num <- vars[sapply(df[, vars, drop = FALSE], is.numeric)]
      formula_str <- paste0(
        "presence ~ ",
        paste(paste0("s(", vars_num, ")"), collapse = " + "),
        " + s(x, y, bs = \"tp\")"
      )
      div(
        code(class = "small d-block p-2 mb-1",
             style = "background:#f8f9fa; border-radius:4px; white-space:pre-wrap;",
             formula_str)
      )
    })

    # Ajustar modelo
    observeEvent(input$ajustar_modelo, {
      req(dataset_pa())
      pa  <- dataset_pa()
      alg <- algoritmo_activo()

      # Validar que haya variables extraídas
      if (is.null(grilla_con_vars())) {
        showNotification("Extrae variables ambientales primero.",
                         type = "warning"); return()
      }

      withProgress(message = paste("Ajustando", alg, "\u2026"), {
        tryCatch({

          # Seguir vignette: h3sdm_data agrega x e y
          gc       <- grilla_con_vars(); req(gc)
          pa_base  <- pa[!duplicated(pa$h3_address), c("h3_address", "presence")]
          gc_dedup <- gc[!duplicated(gc$h3_address), ]
          pred_sf  <- h3sdm::h3sdm_predictors(gc_dedup)
          dat      <- h3sdm::h3sdm_data(pa_base, pred_sf)
          dat_rv(dat)

          # 3. Presence data para evaluación
          presence_data <- dat |>
            dplyr::filter(presence == "1")

          # 2. Recipe
          if (alg == "gam") {
            rec <- h3sdm::h3sdm_recipe_gam(dat, response_col = "presence")
          } else {
            rec <- h3sdm::h3sdm_recipe(dat, response_col = "presence")
          }

          # Estandarizar si el usuario lo pide
          if (input$estandarizar) {
            rec <- recipes::step_normalize(rec, recipes::all_numeric_predictors())
          }

          # 3. Especificación del modelo
          model_spec <- switch(alg,
            logreg = parsnip::logistic_reg() |>
              parsnip::set_engine("glm") |>
              parsnip::set_mode("classification"),
            rf = parsnip::rand_forest(
              trees = input$rf_trees,
              mtry  = if (is.na(input$rf_mtry) || input$rf_mtry < 1) {
                # Default: sqrt del número de predictores
                df_dat <- sf::st_drop_geometry(dat)
                vars_p <- setdiff(names(df_dat), c("h3_address", "presence", "x", "y"))
                max(1, floor(sqrt(length(vars_p))))
              } else input$rf_mtry
            ) |>
              parsnip::set_engine("ranger") |>
              parsnip::set_mode("classification"),
            xgb = parsnip::boost_tree(
              trees       = input$xgb_trees,
              learn_rate  = input$xgb_lr
            ) |>
              parsnip::set_engine("xgboost") |>
              parsnip::set_mode("classification"),
            gam = parsnip::gen_additive_mod() |>
              parsnip::set_engine("mgcv") |>
              parsnip::set_mode("classification")
          )

          # 4. Workflow
          if (alg == "gam") {
            # Construir fórmula GAM desde dat
            df_dat   <- sf::st_drop_geometry(dat)
            vars_dat <- setdiff(names(df_dat), c("h3_address", "presence", "x", "y"))
            vars_num <- vars_dat[sapply(df_dat[, vars_dat, drop = FALSE], is.numeric)]
            formula_str <- if (input$editar_formula && nchar(input$formula_gam_manual) > 5)
              input$formula_gam_manual
            else
              paste0("presence ~ ",
                     paste(paste0("s(", vars_num, ")"), collapse = " + "),
                     " + s(x, y, bs = \"tp\")")
            wf <- h3sdm::h3sdm_workflow_gam(
              gam_spec = model_spec,
              recipe   = rec,
              formula  = as.formula(formula_str)
            )
          } else {
            wf <- h3sdm::h3sdm_workflow(model_spec = model_spec, recipe = rec)
          }

          # 5. CV espacial — validar geometrías antes
          pa_valid <- sf::st_make_valid(dat)
          cv_args  <- list(
            data    = pa_valid,
            method  = input$cv_method,
            v       = input$cv_folds,
            repeats = input$cv_repeats
          )
          if (input$cv_method == "block") {
            cv_args$square   <- input$block_shape == "square"
            cv_args$cellsize <- input$block_size
          }
          cv_split <- do.call(h3sdm::h3sdm_spatial_cv, cv_args)
          cv_split_rv(cv_split)

          # 6. Ajustar
          fitted <- h3sdm::h3sdm_fit_model(
            workflow      = wf,
            data_split    = cv_split,
            presence_data = presence_data
          )

          modelo_ajustado(fitted)
          showNotification("Modelo ajustado correctamente.",
                           type = "message", duration = 4)

        }, error = function(e) {
          showNotification(paste("Error:", conditionMessage(e)),
                           type = "error", duration = 10)
        })
      })
    })

    # Estado del ajuste
    output$estado_ajuste <- renderUI({
      m <- modelo_ajustado()
      if (is.null(m)) return(NULL)
      div(class = "alert alert-success small py-2 px-3 mt-2 mb-0",
          bsicons::bs_icon("check-circle-fill", class = "me-1"),
          "Modelo listo para predecir.")
    })

    # Tabla de métricas
    output$tabla_metricas <- renderUI({
      m <- modelo_ajustado(); req(m)
      metrics <- m$metrics
      if (is.null(metrics)) {
        metrics <- tune::collect_metrics(m$cv_model)
      }
      df <- as.data.frame(metrics)
      df <- df[, intersect(names(df), c(".metric", "mean", "std_err",
                                         "conf_low", "conf_high"))]
      df$mean    <- round(df$mean, 4)
      if ("std_err"   %in% names(df)) df$std_err   <- round(df$std_err, 4)
      if ("conf_low"  %in% names(df)) df$conf_low  <- round(df$conf_low, 4)
      if ("conf_high" %in% names(df)) df$conf_high <- round(df$conf_high, 4)
      names(df)[names(df) == ".metric"] <- "M\u00e9trica"
      names(df)[names(df) == "mean"]    <- "Media"

      tags$table(
        class = "table table-sm small mb-0",
        tags$thead(
          style = paste0("background:", colores$primario, "; color:#fff;"),
          tags$tr(lapply(names(df), tags$th))
        ),
        tags$tbody(
          apply(df, 1, function(row) {
            tags$tr(lapply(row, tags$td))
          })
        )
      )
    })

    # Plot bloques espaciales CV
    output$plot_bloques <- renderPlot({
      cv <- cv_split_rv(); req(cv)
      spatialsample::autoplot(cv)
    })

    # ── Presencias / Pseudoausencias ──────────────────────
    dataset_pa <- reactiveVal(NULL)

    # Mapa base PA
    output$mapa_pa <- leaflet::renderLeaflet({
      leaflet::leaflet() |>
        leaflet::addProviderTiles(leaflet::providers$CartoDB.Positron) |>
        leaflet::setView(lng = 0, lat = 20, zoom = 2)
    })

    # Resumen de insumos disponibles
    output$resumen_insumos <- renderUI({
      items <- list(
        list(
          ok  = !is.null(aoi_sf()),
          txt = "AOI definido"
        ),
        list(
          ok  = !is.null(registros_sf()) && nrow(registros_sf()) > 0,
          txt = if (!is.null(registros_sf()))
            paste0("Registros: ", nrow(registros_sf())) else "Registros"
        ),
        list(
          ok  = !is.null(grilla_sf()),
          txt = if (!is.null(grilla_sf()))
            paste0("Grilla H3 res-", input$resolucion_h3,
                   " (", n_hex_real() %||% nrow(grilla_sf()), " hex)")
          else "Grilla H3"
        ),
        list(
          ok  = !is.null(grilla_con_vars()) &&
                ncol(sf::st_drop_geometry(grilla_con_vars())) > 1,
          txt = if (!is.null(grilla_con_vars())) {
            n_vars <- ncol(sf::st_drop_geometry(grilla_con_vars())) - 1
            paste0("Variables: ", n_vars)
          } else "Variables ambientales"
        )
      )

      tags$ul(
        class = "small mb-0",
        lapply(items, function(item) {
          tags$li(
            bsicons::bs_icon(
              if (item$ok) "check-circle-fill" else "circle",
              style = paste0("color:", if (item$ok) colores$exito else "#CCCCCC"),
              class = "me-1"
            ),
            item$txt
          )
        })
      )
    })

    # Generar dataset PA
    observeEvent(input$generar_pa, {
      if (is.null(aoi_sf())) {
        showNotification("Define el AOI primero.", type = "warning"); return()
      }
      if (is.null(registros_sf()) || nrow(registros_sf()) == 0) {
        showNotification("Descarga registros primero.", type = "warning"); return()
      }

      withProgress(message = "Generando dataset presencia/pseudoausencia\u2026", {
        tryCatch({
          # Proyectar registros y AOI al CRS de trabajo
          crs_op       <- crs_trabajo()
          registros_op <- sf::st_transform(registros_sf(), crs_op)
          aoi_op       <- sf::st_transform(aoi_sf(), crs_op)

          # Generar PA en el CRS de trabajo
          pa <- h3sdm::h3sdm_pa_from_records(
            records       = registros_op,
            aoi_sf        = aoi_op,
            res           = as.integer(input$resolucion_h3),
            n_pseudoabs   = input$n_pseudoabs,
            buffer_k      = as.integer(input$buffer_k),
            predictors_sf = grilla_con_vars()
          )

          # Filtro de outliers ambientales (opcional) — se aplica sobre el PA generado
          if (isTRUE(input$aplicar_filtro_outliers)) {
            if (is.null(grilla_con_vars())) {
              showNotification(
                "El filtro de outliers requiere variables ambientales extraídas. Extrae las variables primero en la pestaña correspondiente.",
                type = "warning", duration = 8)
            } else {
              n_pres_antes <- sum(pa$presence == "1")
              pa <- h3sdm::h3sdm_filter_outliers(pa)
              n_pres_despues <- sum(pa$presence == "1")
              n_removidos <- n_pres_antes - n_pres_despues
              if (n_removidos > 0) {
                showNotification(
                  paste0("Filtro de outliers: ", n_removidos,
                         " presencia(s) eliminada(s) como outliers ambientales."),
                  type = "message", duration = 5)
              } else {
                showNotification(
                  "Filtro de outliers: no se detectaron outliers ambientales.",
                  type = "message", duration = 4)
              }
            }
          }

          # Volver a WGS84 para visualización y join con variables
          pa <- sf::st_transform(pa, 4326)

          # Unir con variables si están disponibles
          if (!is.null(grilla_con_vars())) {
            vars_df <- sf::st_drop_geometry(grilla_con_vars())
            # Deduplicar h3_address en vars_df por si hay filas repetidas del cast
            vars_df <- vars_df[!duplicated(vars_df$h3_address), ]
            pa_joined <- dplyr::left_join(
              sf::st_drop_geometry(pa),
              vars_df,
              by = "h3_address"
            )
            pa <- sf::st_sf(pa_joined,
                            geometry = sf::st_geometry(pa),
                            crs      = sf::st_crs(pa))
          }

          dataset_pa(pa)

          n_pres <- sum(pa$presence == "1")
          n_abs  <- sum(pa$presence == "0")

          # Cast y transformar a WGS84 para leafgl
          pa_vis  <- suppressWarnings(sf::st_cast(pa, "POLYGON")) |>
            sf::st_transform(4326)
          bbox    <- sf::st_bbox(sf::st_transform(pa, 4326))
          pal_pa  <- leaflet::colorFactor(
            palette = c(colores$secundario, colores$acento),
            levels  = c("0", "1")
          )
          leaflet::leafletProxy(ns("mapa_pa")) |>
            leaflet::clearShapes() |>
            leaflet::clearControls() |>
            leafgl::addGlPolygons(
              data        = pa_vis,
              fillColor   = ~pal_pa(presence),
              fillOpacity = 0.7,
              color       = "#ffffff",
              weight      = 0.3
            ) |>
            leaflet::addLegend(
              position = "bottomright",
              pal      = pal_pa,
              values   = pa$presence,
              title    = "Presencia",
              labels   = c("Pseudoausencia", "Presencia"),
              opacity  = 0.8
            ) |>
            leaflet::fitBounds(bbox[["xmin"]], bbox[["ymin"]],
                               bbox[["xmax"]], bbox[["ymax"]])

          showNotification(
            paste0("Dataset generado: ", n_pres, " presencias, ",
                   n_abs, " pseudoausencias."),
            type = "message", duration = 5)

        }, error = function(e) {
          showNotification(paste("Error:", conditionMessage(e)),
                           type = "error", duration = 8)
        })
      })
    })

    # Resumen del dataset PA
    output$resumen_pa <- renderUI({
      pa <- dataset_pa()
      if (is.null(pa)) return(NULL)
      n_pres <- sum(pa$presence == "1")
      n_abs  <- sum(pa$presence == "0")
      n_vars <- ncol(sf::st_drop_geometry(pa)) - 2  # menos h3_address y presence
      div(class = "alert alert-info small py-2 px-3 mt-2 mb-0",
          bsicons::bs_icon("check-circle-fill", class = "me-1"),
          strong(n_pres + n_abs), " filas | ",
          strong(n_pres), " presencias | ",
          strong(n_abs), " pseudoausencias | ",
          strong(n_vars), " variables")
    })

    # Tabla del dataset PA
    output$tabla_pa <- DT::renderDT({
      pa <- dataset_pa(); req(pa)
      df <- sf::st_drop_geometry(pa)
      DT::datatable(df,
                    options = list(pageLength = 10, scrollX = TRUE),
                    rownames = FALSE, class = "table-sm")
    })

    # ── Selección de variables ────────────────────────────
    grilla_con_vars  <- reactiveVal(NULL)
    vars_seleccionadas <- reactiveVal(NULL)

    # Checkboxes de variables disponibles
    output$checkboxes_vars <- renderUI({
      grilla <- grilla_con_vars(); req(grilla)
      df   <- sf::st_drop_geometry(grilla)
      vars <- setdiff(names(df), "h3_address")
      sel  <- vars_seleccionadas() %||% vars
      checkboxGroupInput(
        ns("vars_keep"),
        label   = NULL,
        choices = vars,
        selected = sel
      )
    })

    # Calcular y mostrar matriz de correlación
    output$plot_correlacion <- renderPlot({
      grilla <- grilla_con_vars(); req(grilla)
      df   <- sf::st_drop_geometry(grilla)
      vars <- setdiff(names(df), "h3_address")
      nums <- vars[sapply(df[, vars, drop = FALSE], is.numeric)]
      req(length(nums) >= 2)

      mat_cor <- cor(df[, nums, drop = FALSE], use = "pairwise.complete.obs")

      # Convertir a data.frame largo para ggplot2
      df_cor <- as.data.frame(as.table(mat_cor))
      names(df_cor) <- c("Var1", "Var2", "r")

      ggplot2::ggplot(df_cor, ggplot2::aes(x = Var1, y = Var2, fill = r)) +
        ggplot2::geom_tile(color = "white") +
        ggplot2::geom_label(ggplot2::aes(
          label = round(r, 2)),
          size = 4, color = "black", fill = "white",
          label.padding = ggplot2::unit(0.15, "lines"),
          label.size = 0) +
        ggplot2::scale_fill_gradient2(
          low      = colores$peligro,
          mid      = "white",
          high     = colores$primario,
          midpoint = 0,
          limits   = c(-1, 1),
          name     = "r"
        ) +
        ggplot2::labs(x = NULL, y = NULL) +
        ggplot2::theme_minimal(base_size = 18) +
        ggplot2::theme(
          axis.text.x  = ggplot2::element_text(angle = 45, hjust = 1, size = 16),
          axis.text.y  = ggplot2::element_text(size = 16),
          panel.grid   = ggplot2::element_blank()
        )
    })

    # Eliminar por correlación
    observeEvent(input$eliminar_cor, {
      grilla <- grilla_con_vars(); req(grilla)
      df   <- sf::st_drop_geometry(grilla)
      vars <- setdiff(names(df), "h3_address")
      nums <- vars[sapply(df[, vars, drop = FALSE], is.numeric)]
      req(length(nums) >= 2)

      umbral  <- input$umbral_cor
      mat_cor <- cor(df[, nums, drop = FALSE], use = "pairwise.complete.obs")

      # Algoritmo greedy: eliminar variable con más correlaciones altas
      eliminar <- c()
      mat_abs  <- abs(mat_cor)
      diag(mat_abs) <- 0
      while (any(mat_abs > umbral, na.rm = TRUE)) {
        n_altas <- colSums(mat_abs > umbral, na.rm = TRUE)
        peor    <- names(which.max(n_altas))
        eliminar <- c(eliminar, peor)
        mat_abs  <- mat_abs[!rownames(mat_abs) %in% peor,
                             !colnames(mat_abs) %in% peor,
                             drop = FALSE]
      }

      if (length(eliminar) > 0) {
        vars_actuales <- input$vars_keep %||% vars
        nuevas <- vars_actuales[!vars_actuales %in% eliminar]
        vars_seleccionadas(nuevas)
        updateCheckboxGroupInput(session, "vars_keep", selected = nuevas)
        showNotification(
          paste0(length(eliminar), " variable(s) marcadas para eliminar: ",
                 paste(eliminar, collapse = ", ")),
          type = "message", duration = 6)
      } else {
        showNotification(
          paste0("No hay variables con correlaci\u00f3n > ", umbral, "."),
          type = "message", duration = 4)
      }
    })

    # Aplicar selección manual
    observeEvent(input$aplicar_seleccion, {
      req(input$vars_keep, grilla_con_vars())
      grilla <- grilla_con_vars()
      df     <- sf::st_drop_geometry(grilla)
      vars_a_mantener <- c("h3_address", input$vars_keep)
      vars_a_mantener <- vars_a_mantener[vars_a_mantener %in% names(df)]
      # Mantener solo las columnas seleccionadas + geometría
      grilla_filtrada <- grilla[, vars_a_mantener]
      grilla_con_vars(grilla_filtrada)
      vars_seleccionadas(input$vars_keep)
      showNotification(
        paste0(length(input$vars_keep), " variables conservadas."),
        type = "message", duration = 4)
    })

    # Resumen de selección
    output$resumen_seleccion <- renderUI({
      grilla <- grilla_con_vars()
      if (is.null(grilla)) return(
        p(class = "small text-muted mb-0", "Extrae variables primero.")
      )
      df   <- sf::st_drop_geometry(grilla)
      vars <- setdiff(names(df), "h3_address")
      div(
        p(class = "small mb-1",
          bsicons::bs_icon("check-circle-fill", class = "me-1",
                           style = paste0("color:", colores$exito)),
          strong(length(vars)), " variable(s) activas"),
        tags$ul(class = "small mb-0",
                lapply(vars, tags$li))
      )
    })

    # ── Variables ambientales ─────────────────────────────

    # Mapa de variables
    output$mapa_variables <- leaflet::renderLeaflet({
      leaflet::leaflet() |>
        leaflet::addProviderTiles(leaflet::providers$CartoDB.Positron) |>
        leaflet::setView(lng = 0, lat = 20, zoom = 2)
    })

    # Extraer numéricas
    observeEvent(input$extraer_num, {
      req(input$raster_num, grilla_sf())
      withProgress(message = "Extrayendo variables num\u00e9ricas\u2026", {
        tryCatch({
          rasters <- lapply(input$raster_num$datapath, terra::rast)
          stack   <- if (length(rasters) > 1) do.call(c, rasters) else rasters[[1]]
          # Solo renombrar si hay nombres duplicados
          if (any(duplicated(names(stack)))) {
            nombres <- names(stack)
            nombres <- make.unique(nombres, sep = "_")
            names(stack) <- nombres
          }
          # Transformar grilla al CRS de trabajo elegido por el usuario
          grilla  <- sf::st_transform(grilla_sf(), crs_trabajo())
          result  <- h3sdm::h3sdm_extract_num(stack, grilla)

          # Combinar con variables existentes sin duplicar
          gc_actual <- grilla_con_vars()
          if (!is.null(gc_actual)) {
            vars_nuevas <- setdiff(names(sf::st_drop_geometry(result)),
                                   c("h3_address", names(sf::st_drop_geometry(gc_actual))))
            if (length(vars_nuevas) > 0) {
              df_nuevo <- sf::st_drop_geometry(result)[, c("h3_address", vars_nuevas)]
              df_actual <- sf::st_drop_geometry(gc_actual)
              df_merged <- dplyr::left_join(df_actual, df_nuevo, by = "h3_address")
              result <- sf::st_sf(df_merged, geometry = sf::st_geometry(gc_actual))
            } else {
              result <- gc_actual
            }
          }
          grilla_con_vars(result)
          showNotification(
            paste(terra::nlyr(stack), "variable(s) num\u00e9rica(s) extra\u00eddas."),
            type = "message", duration = 4)
        }, error = function(e) {
          showNotification(paste("Error:", conditionMessage(e)),
                           type = "error", duration = 8)
        })
      })
    })

    # Extraer categóricas
    observeEvent(input$extraer_cat, {
      req(input$raster_cat, grilla_sf())
      withProgress(message = "Extrayendo variables categ\u00f3ricas\u2026", {
        tryCatch({
          rcat_path <- input$raster_cat$datapath[
            !grepl("\\.aux\\.xml$", input$raster_cat$name,
                   ignore.case = TRUE)][1]
          rcat <- terra::rast(rcat_path)

          # Transformar grilla al CRS de trabajo y desduplicar h3_address
          grilla_base <- grilla_con_vars() %||% grilla_sf()
          grilla_base <- sf::st_transform(grilla_base, crs_trabajo())
          grilla_unique <- grilla_base[!duplicated(grilla_base$h3_address), ]

          result <- h3sdm::h3sdm_extract_cat(
            rcat, grilla_unique, proportion = TRUE)

          # Cast a POLYGON para leafgl
          result <- suppressWarnings(sf::st_cast(result, "POLYGON"))
          grilla_con_vars(result)

          # Verificar columnas nuevas
          cols_nuevas <- setdiff(names(sf::st_drop_geometry(result)),
                                 names(sf::st_drop_geometry(grilla_unique)))
          if (length(cols_nuevas) > 0) {
            showNotification(
              paste0(length(cols_nuevas),
                     " variable(s) categ\u00f3rica(s) extra\u00eddas: ",
                     paste(cols_nuevas, collapse = ", ")),
              type = "message", duration = 6)
          } else {
            showNotification(
              "Extracci\u00f3n completada pero no se agregaron columnas. ",
              type = "warning", duration = 6)
          }
        }, error = function(e) {
          showNotification(paste("Error:", conditionMessage(e)),
                           type = "error", duration = 8)
        })
      })
    })

    # Calcular métricas IT
    observeEvent(input$calcular_it, {
      req(input$raster_it, grilla_sf())
      withProgress(message = "Calculando m\u00e9tricas IT del paisaje\u2026", {
        tryCatch({
          rit_path <- input$raster_it$datapath[
            !grepl("\\.aux\\.xml$", input$raster_it$name,
                   ignore.case = TRUE)][1]
          req(rit_path)
          rcat   <- terra::rast(rit_path)
          grilla <- grilla_con_vars() %||% grilla_sf()
          grilla <- sf::st_transform(grilla, crs_trabajo())
          result <- h3sdm::h3sdm_calculate_it_metrics(rcat, grilla)
          grilla_con_vars(result)
          showNotification("M\u00e9tricas IT calculadas.",
                           type = "message", duration = 4)
        }, error = function(e) {
          showNotification(paste("Error:", conditionMessage(e)),
                           type = "error", duration = 8)
        })
      })
    })

    # Selector de variable para visualizar
    output$sel_variable_mapa <- renderUI({
      grilla <- grilla_con_vars(); req(grilla)
      vars_num <- names(sf::st_drop_geometry(grilla))
      vars_num <- vars_num[vars_num != "h3_address"]
      vars_num <- vars_num[sapply(sf::st_drop_geometry(grilla)[vars_num],
                                  is.numeric)]
      if (length(vars_num) == 0) return(NULL)
      selectInput(ns("var_mapa"), "Variable a visualizar:",
                  choices = vars_num, selected = vars_num[1])
    })

    # Actualizar mapa cuando cambia la variable seleccionada
    observeEvent(input$var_mapa, {
      grilla     <- grilla_con_vars(); req(grilla, input$var_mapa)
      grilla_vis <- suppressWarnings(sf::st_cast(grilla, "POLYGON")) |> sf::st_transform(4326)
      vals_vis   <- sf::st_drop_geometry(grilla_vis)[[input$var_mapa]]
      # Reemplazar NA con la media para que leafgl no falle
      vals_vis[is.na(vals_vis)] <- mean(vals_vis, na.rm = TRUE)
      pal  <- leaflet::colorNumeric("YlOrRd", domain = range(vals_vis, na.rm = TRUE))
      cols <- pal(vals_vis)
      bbox <- sf::st_bbox(grilla_vis)
      leaflet::leafletProxy(ns("mapa_variables")) |>
        leaflet::clearShapes() |>
        leaflet::clearControls() |>
        leafgl::addGlPolygons(
          data        = grilla_vis,
          group       = "vars",
          color       = cols,
          fillColor   = cols,
          fillOpacity = 0.8
        ) |>
        leaflet::addLegend(
          position = "bottomright",
          pal      = pal,
          values   = vals_vis,
          title    = input$var_mapa,
          opacity  = 0.8
        ) |>
        leaflet::fitBounds(bbox[["xmin"]], bbox[["ymin"]],
                           bbox[["xmax"]], bbox[["ymax"]])
    })

    # Resumen de NAs
    output$resumen_nas <- renderUI({
      grilla <- grilla_con_vars()
      if (is.null(grilla)) return(
        p(class = "small text-muted mb-2",
          "Extrae variables primero.")
      )
      df   <- sf::st_drop_geometry(grilla)
      vars <- setdiff(names(df), "h3_address")
      nas  <- sapply(df[, vars, drop = FALSE], function(x) sum(is.na(x)))
      nas  <- nas[nas > 0]

      if (length(nas) == 0) {
        div(class = "alert alert-success small py-2 px-3 mb-2",
            bsicons::bs_icon("check-circle-fill", class = "me-1"),
            "No hay valores faltantes.")
      } else {
        total_filas <- nrow(df)
        tagList(
          div(class = "alert alert-warning small py-2 px-3 mb-2",
              bsicons::bs_icon("exclamation-triangle-fill", class = "me-1"),
              strong(sum(apply(df[, names(nas), drop = FALSE], 1, anyNA))),
              " filas con al menos un NA de ",
              strong(total_filas), " totales."),
          tags$ul(class = "small mb-2",
                  lapply(names(nas), function(v)
                    tags$li(code(v), ": ", strong(nas[[v]]), " NA")))
        )
      }
    })

    # Eliminar filas con NA
    observeEvent(input$eliminar_nas, {
      grilla <- grilla_con_vars(); req(grilla)
      df_orig <- sf::st_drop_geometry(grilla)
      vars    <- setdiff(names(df_orig), "h3_address")
      n_antes <- nrow(grilla)
      grilla_limpia <- grilla[complete.cases(sf::st_drop_geometry(grilla)[vars]), ]
      n_despues <- nrow(grilla_limpia)
      grilla_con_vars(grilla_limpia)
      showNotification(
        paste0(n_antes - n_despues, " filas eliminadas. Quedan ", n_despues, "."),
        type = "message", duration = 4)
    })

    # Imputar NAs con la media
    observeEvent(input$imputar_nas, {
      grilla <- grilla_con_vars(); req(grilla)
      df   <- sf::st_drop_geometry(grilla)
      vars <- setdiff(names(df), "h3_address")
      for (v in vars) {
        if (any(is.na(df[[v]])) && is.numeric(df[[v]])) {
          media <- mean(df[[v]], na.rm = TRUE)
          grilla[[v]][is.na(grilla[[v]])] <- media
        }
      }
      grilla_con_vars(grilla)
      showNotification("NA imputados con la media de cada variable.",
                       type = "message", duration = 4)
    })

    # Tabla de predictores
    output$tabla_predictores <- DT::renderDT({
      grilla <- grilla_con_vars(); req(grilla)
      df <- sf::st_drop_geometry(grilla)
      DT::datatable(df,
                    options = list(pageLength = 10, scrollX = TRUE),
                    rownames = FALSE, class = "table-sm")
    })

    # Resumen de variables extraídas
    output$resumen_variables <- renderUI({
      grilla <- grilla_con_vars()
      if (is.null(grilla)) {
        p(class = "small text-muted mb-0",
          bsicons::bs_icon("exclamation-circle", class = "me-1"),
          "No hay variables extra\u00eddas todav\u00eda.")
      } else {
        df   <- sf::st_drop_geometry(grilla)
        vars <- setdiff(names(df), "h3_address")
        div(
          p(class = "small mb-1",
            bsicons::bs_icon("check-circle-fill", class = "me-1",
                             style = paste0("color:", colores$exito)),
            strong(length(vars)), " variable(s) disponibles:"),
          tags$ul(class = "small mb-0",
                  lapply(vars, tags$li))
        )
      }
    })

    # ── Grilla H3 ─────────────────────────────────────────
    grilla_sf  <- reactiveVal(NULL)
    n_hex_real <- reactiveVal(NULL)

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
          )
          n_hex  <- nrow(grilla)  # conteo real antes del cast
          grilla_sf(grilla)       # guardar MULTIPOLYGON original
          n_hex_real(n_hex)
          grilla_vis <- suppressWarnings(sf::st_cast(grilla, "POLYGON")) |>
            sf::st_transform(4326)
          bbox <- sf::st_bbox(grilla_vis)
          leaflet::leafletProxy(ns("mapa_grilla")) |>
            leaflet::clearGroup("grilla") |>
            leaflet::clearGroup("aoi_grilla") |>
            leafgl::addGlPolygons(
              data        = grilla_vis,
              group       = "grilla",
              color       = colores$primario,
              fillColor   = colores$secundario,
              fillOpacity = 0.2,
              weight      = 1
            ) |>
            leaflet::addPolygons(
              data = sf::st_transform(aoi_sf(), 4326), group = "aoi_grilla",
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
            tags$li(paste0("Hex\u00e1gonos H3: ", n_hex_real() %||% nrow(grilla))),
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
          leaflet::addPolygons(data = sf::st_transform(aoi_sf(), 4326), group = "aoi_reg",
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

      resumen <- div(
        class = "alert alert-info small py-2 px-3 mt-2 mb-0",
        bsicons::bs_icon("check-circle-fill", class = "me-1"),
        strong(nrow(recs)), " registros descargados."
      )

      # Tabla por fuente si existe columna provider
      if ("provider" %in% names(recs)) {
        conteos <- sort(table(recs$provider), decreasing = TRUE)
        filas <- lapply(names(conteos), function(p) {
          tags$tr(tags$td(p), tags$td(style = "text-align:right;", conteos[[p]]))
        })
        tabla_fuentes <- div(
          class = "mt-2",
          p(class = "small text-muted mb-1",
            bsicons::bs_icon("info-circle", class = "me-1"),
            "Registros por fuente:"),
          tags$table(
            class = "table table-sm small mb-0",
            tags$thead(
              style = paste0("background:", colores$primario, "; color:#fff;"),
              tags$tr(tags$th("Fuente"), tags$th(style = "text-align:right;", "N"))
            ),
            tags$tbody(filas)
          )
        )
        tagList(resumen, tabla_fuentes)
      } else {
        resumen
      }
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
