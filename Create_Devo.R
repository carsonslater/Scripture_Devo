# Create Reports

# pak::pak("thomasqmd/mariner")
library("mariner")

params <- tidyr::expand_grid(
  date = format(
    seq.Date(from = Sys.Date(), to = as.Date("2025-11-30"), by = "day"),
    "%B %d, %Y"
  ),
  author = "Carson Slater"
)

source(here::here("generate_devo.R"))

rmd_files <- generate_devo(
  params_df = params,
  template_name = "generic_report",
  output_dir = here::here("Daily_Devos"),
  template_path = here::here("Devo_Template.Rmd")
)

daily_rmd_paths <- list.files(
  here::here("Daily_Devos"),
  pattern = "\\.Rmd$",
  full.names = TRUE
)

lapply(daily_rmd_paths, function(path) {
  rmarkdown::render(
    input = path,
    output_format = "pdf_document",
    output_dir = here::here("Rendered_Devos")
  )
})

daily_rmd_paths

# rmd_files <-
#   mariner::process_files(
#     rmd_files,
#     output_dir = here::here(
#       "Reports",
#       "zipped_Reports"
#     )
#   )
