# Scripture Devo

Purpose

- Produce a sequence of daily devotional R Markdown files from a single Rmd template and render them to PDF using a consistent LaTeX template and YAML-driven parameters.

What this repository accomplishes

- Generates one R Markdown file per date from a parameter set (date, author, etc.).
- Injects parameter values into the template YAML for each file.
- Renders generated Rmd files to PDF, producing standardized devotional PDFs and accompanying LaTeX artifacts.

Key components

- `Create_Devo.R` — driver that assembles parameters, invokes the generator, and renders outputs.

- `generate_devo.R` — core function that populates a template and writes one Rmd per parameter row.
- `Devo_Template.Rmd` — base R Markdown template used to produce each daily file.
- `svm-latex-ms.tex` — LaTeX template that controls final PDF styling.
- `Daily_Devos/` — generated R Markdown files (one per date).
- `Rendered_Devos/` — compiled PDF outputs and LaTeX artifacts (.tex, logs, aux).

Design notes

- The generator edits the YAML section of the template to set params for each output file, then writes a date-stamped Rmd (Devo_YYYYMMDD.Rmd).
- Rendering uses rmarkdown/pandoc with the project LaTeX template so PDFs share a uniform layout.
- File and directory creation is handled so the workflow can be run repeatedly without manual folder setup.

Dependencies (conceptual)

- R (tested on R 4.5.x)
- LaTeX (pdflatex or equivalent available on PATH)
- R packages: tidyr, purrr, fs, here, rmarkdown, knitr (and mariner if used in the workflow)

Customization points

- Modify Devo_Template.Rmd to change content structure or YAML parameters.
- Adjust svm-latex-ms.tex for PDF appearance (fonts, margins, headers/footers).
- Change parameter generation (date range, author, additional params) in Create_Devo.R.

Outputs

- Per-day PDF files named Devo_YYYYMMDD.pdf in Rendered_Devos/.
- Corresponding Rmd files in Daily_Devos/ for reproducibility and manual edits.

Troubleshooting pointers

- Missing template errors indicate template_path or Devo_Template.Rmd is not found.
- LaTeX failures surface as .log files in Rendered_Devos/; check those for missing packages or compile errors.
- Package loading errors indicate required R packages must be installed.

Contact / maintenance

- Update generate_devo.R for changes to parameter mapping or YAML handling.
- Update Devo_Template.Rmd and the LaTeX template for content and styling changes.
