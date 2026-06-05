# Launch the ShinyApp (Do not remove this comment)
# To deploy, run: rsconnect::deployApp()
# Or use the blue button on top of this file
pkgload::load_all(export_all = FALSE, helpers = FALSE, attach_testthat = FALSE)

source("/Users/manuel_nuevo/R_MS/R_packages/h3sdm/R/h3sdm_aoa.R")
environment(h3sdm_aoa) <- asNamespace("h3sdm")
assignInNamespace("h3sdm_aoa", h3sdm_aoa, ns = "h3sdm")

source("/Users/manuel_nuevo/R_MS/R_packages/h3sdm/R/h3sdm_pa.R")
environment(h3sdm_pa) <- asNamespace("h3sdm")
assignInNamespace("h3sdm_pa", h3sdm_pa, ns = "h3sdm")

source("/Users/manuel_nuevo/R_MS/R_packages/h3sdm/R/h3sdm_pa_from_records.R")
environment(h3sdm_pa_from_records) <- asNamespace("h3sdm")
assignInNamespace("h3sdm_pa_from_records", h3sdm_pa_from_records, ns = "h3sdm")

options("golem.app.prod" = TRUE)
StatH3sdm::run_app()

