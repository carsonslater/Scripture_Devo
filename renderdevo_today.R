#!/usr/bin/env Rscript

# This script renders a specific devotional Rmd file.
# It defaults to the current date if no argument is provided.
#
# USAGE:
# Rscript render_today.R
# Rscript render_today.R 2025-11-14

# --- Setup ---
suppressPackageStartupMessages(library("here"))
if (!requireNamespace("rmarkdown", quietly = TRUE)) {
  stop("The 'rmarkdown' package is required. Please install it.", call. = FALSE)
}

# --- 1. Get Target Date ---

args <- commandArgs(trailingOnly = TRUE)
target_date <- NULL

if (length(args) == 0) {
  # No argument provided, default to today
  target_date <- Sys.Date()
  message(
    "No date argument provided, defaulting to today: ",
    format(target_date)
  )
} else {
  # An argument was provided, try to parse it
  target_date_str <- args[1]
  target_date <- as.Date(target_date_str, format = "%Y-%m-%d")

  if (is.na(target_date)) {
    stop(
      "Invalid date format: '",
      target_date_str,
      "'.\n",
      "Please use the YYYY-MM-DD format.",
      call. = FALSE
    )
  }
  message("Using specified date: ", format(target_date))
}

# --- 2. Identify Target .Rmd File ---

# Format the date to match your file naming convention (YYYYMMDD)
target_formatted <- format(target_date, "%Y%m%d")
rmd_filename <- paste0("Devo_", target_formatted, ".Rmd")
rmd_input_path <- here::here("Daily_Devos", rmd_filename)

# --- 3. Check if the File Exists ---

if (!file.exists(rmd_input_path)) {
  stop(
    "File not found: ",
    rmd_filename,
    "\n",
    "Please make sure this file exists in the 'Daily_Devos' directory.",
    call. = FALSE
  )
}

# --- 4. Render the File to PDF ---

message("Rendering ", rmd_filename, " to PDF...")

output_dir <- here::here("Rendered_Devos")

rmarkdown::render(
  input = rmd_input_path,
  output_format = "pdf_document",
  output_dir = output_dir,
  quiet = TRUE
)

# --- 5. Success Message ---
pdf_filename <- sub("\\.Rmd$", ".pdf", rmd_filename)
message(
  "Successfully rendered: ",
  file.path(basename(output_dir), pdf_filename)
)
