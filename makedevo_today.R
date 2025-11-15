#!/usr/bin/env Rscript

# This script generates and (optionally) renders a single
# devotional Rmd file for the current date.
# Run from the terminal in the project's root directory:
# Rscript makedevo_today.R

# --- Setup ---
# Load required libraries
suppressPackageStartupMessages(library("here"))
# Your 'generate_devo.R' script uses 'fs' and 'purrr' internally.

# Load the helper function
source(here::here("generate_devo.R"))

# --- 1. Define Today's Parameters ---

# Your 'generate_devo' function expects the date in "Month Day, Year" format
today_params <- data.frame(
  date = format(Sys.Date(), "%B %d, %Y"),
  author = "Carson Slater" # Based on your Create_Devo.R script
)

# --- 2. Generate the .Rmd File ---

# This calls your existing function to create the .Rmd file.
# The function invisibly returns the path(s) to the file(s) it created.
rmd_file_paths <- generate_devo(
  params_df = today_params,
  output_dir = here::here("Daily_Devos"),
  template_path = here::here("Devo_Template.Rmd")
)

message("Successfully created: ", rmd_file_paths[1])

# --- 3. (Optional) Render the .Rmd to PDF ---

# Based on your 'Create_Devo.R' script, you might also want to render
# the file immediately. Uncomment the lines below to enable this.

message("Rendering PDF to 'Rendered_Devos'...")
if (requireNamespace("rmarkdown", quietly = TRUE)) {
  rmarkdown::render(
    input = rmd_file_paths[1],
    output_format = "pdf_document",
    output_dir = here::here("Rendered_Devos"),
    quiet = TRUE
  )

  # Get the name of the PDF file
  pdf_path <- sub("\\.Rmd$", ".pdf", rmd_file_paths[1]) |>
    basename()

  message("Rendering complete: ", file.path("Rendered_Devos", pdf_path))
} else {
  message("'rmarkdown' package not found. Skipping render step.")
}
