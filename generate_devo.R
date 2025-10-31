# Carson Slater ----------------------------------------------------------
#
# Date Created: 10.31.2025
# Description: Function to generate multiple R Markdown reports based on a template
# and a set of parameters provided in a data frame.
#
# ------------------------------------------------------------------------

generate_devo <- function(
  params_df,
  template_name = "simple_report",
  template_package = "mariner",
  output_dir = ".",
  template_path = NULL
) {
  # Load the template
  if (!is.null(template_path)) {
    if (!file.exists(template_path)) {
      stop("Template file not found at: ", template_path, call. = FALSE)
    }
    template_content <- readLines(template_path)
  } else {
    package_template_path <- system.file(
      "rmarkdown",
      "templates",
      template_name,
      "skeleton",
      "skeleton.Rmd",
      package = template_package,
      mustWork = TRUE
    )
    template_content <- readLines(package_template_path)
  }

  # Create output directory
  fs::dir_create(output_dir)

  # Function to create one Rmd per parameter row
  create_one_rmd <- function(...) {
    current_params <- list(...)

    # Parse the date into YYYYMMDD format
    date_clean <- format(
      as.Date(current_params$date, format = "%B %d, %Y"),
      "%Y%m%d"
    )

    # Build the filename
    output_filename <- file.path(
      output_dir,
      paste0("Devo_", date_clean, ".Rmd")
    )

    modified_content <- template_content
    yaml_delimiters <- which(grepl("^---$", modified_content))

    if (length(yaml_delimiters) < 2) {
      writeLines(modified_content, output_filename)
      return()
    }

    yaml_header_indices <- (yaml_delimiters[1] + 1):(yaml_delimiters[2] - 1)
    yaml_header <- modified_content[yaml_header_indices]

    params_start_in_yaml <- which(grepl("^params:", yaml_header))
    if (length(params_start_in_yaml) > 0) {
      following_lines <- yaml_header[
        (params_start_in_yaml + 1):length(yaml_header)
      ]
      next_unindented_line <- which(!grepl("^\\s+", following_lines))
      params_end_in_yaml <- if (length(next_unindented_line) > 0) {
        params_start_in_yaml + next_unindented_line[1] - 1
      } else {
        length(yaml_header)
      }

      param_lines_indices <- (params_start_in_yaml + 1):params_end_in_yaml
      for (param_name in names(current_params)) {
        param_value <- current_params[[param_name]]
        pattern <- paste0("(\\s*", param_name, ":\\s*).+")
        replacement_value <- ifelse(
          is.character(param_value),
          paste0("\"", param_value, "\""),
          param_value
        )
        replacement <- paste0("\\1", replacement_value)
        yaml_header[param_lines_indices] <- gsub(
          pattern,
          replacement,
          yaml_header[param_lines_indices]
        )
      }
      modified_content[yaml_header_indices] <- yaml_header
    }

    writeLines(modified_content, output_filename)
  }

  message("Generating ", nrow(params_df), " Rmd files...")
  purrr::pwalk(params_df, create_one_rmd)

  # Output paths
  output_paths <- file.path(
    output_dir,
    paste0(
      "Devo_",
      format(as.Date(params_df$date, format = "%B %d, %Y"), "%Y%m%d"),
      ".Rmd"
    )
  )

  message("Rmd file generation complete.")
  invisible(output_paths)
}
