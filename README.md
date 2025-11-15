# 📖 Scripture Devotional Workflow

This project is a complete system for generating, managing, and rendering daily devotional templates for scripture study. It uses R and R Markdown, wrapped in simple shell commands, to create a seamless daily workflow.

Instead of manually copying templates, this system lets you generate a new, pre-named, and pre-dated file from your terminal. After writing, you can render it to a PDF with another simple command.

## ✨ Features

* **One-Command Creation:** Generate today's `.Rmd` file, named and dated, using `makedevo`.
* **Parameterized Template:** The `.Rmd` template automatically populates the date and author in the final PDF.
* **One-Command Render:** Render today's (or any specific day's) `.Rmd` file to a PDF in the `Rendered_Devos` folder using `renderdevo`.
* **Custom LaTeX Template:** Uses a custom `.tex` template for beautifully typeset PDFs.
* **Scalable:** Includes helper scripts to batch-generate files if needed.

-----

## 🔧 Setup

To get this workflow running, you need to set up your R environment and your `zsh` shell functions.

### 1\. System Dependencies

This workflow requires **Pandoc** to render PDFs. The easiest way to install it system-wide is with Homebrew (on macOS):

```sh
brew install pandoc
```

### 2\. R Packages

Install the necessary R packages. You can do this from an R console:

```r
install.packages(c("here", "rmarkdown", "pandoc", "purrr", "fs", "tidyr"))
```

*(Note: The `pandoc` R package is a good fallback, but the system-wide install is recommended.)*

### 3\. Shell Functions

The core of this workflow relies on two shell functions, `makedevo` and `renderdevo`. Add the following functions to your `~/.zshrc` file:

1. Open your `zsh` config file:

    ```sh
    open ~/.zshrc
    ```

2. Find the **absolute path** to your project folder by running `pwd` inside it.
    *(e.g., `/Users/yourname/Projects/Scripture_Devo`)*

3. Paste the following functions at the end of your `.zshrc` file, **replacing the placeholder path** with your real path.

    ```zsh
    # --------------------------------------------------
    # SCRIPTURE DEVO WORKFLOW
    # --------------------------------------------------

    # Function to create today's devotional Rmd
    makedevo() {
      # Change to the script's directory
      cd /path/to/your/Scripture_Devo && \
      # Run the creation script
      Rscript makedevo_today.R && \
      # Return to the original directory
      cd -
    }

    # Function to render a devotional (defaults to today)
    renderdevo() {
      # Change to the script's directory
      cd /path/to/your/Scripture_Devo && \
      # Run the render script, passing all arguments ($@)
      # If no args are given, R script will default to today
      Rscript renderdevo_today.R "$@" && \
      # Return to the original directory
      cd -
    }
    ```

4. Save the file and "source" it to activate the new functions:

    ```sh
    source ~/.zshrc
    ```

-----

## 🚀 Daily Workflow

Your daily process is now just two commands.

### Step 1: Create Today's File

Run this command in your terminal (from any directory):

```sh
makedevo
```

This will run `makedevo_today.R`, which creates a new file in the `Daily_Devos/` folder, named `Devo_YYYYMMDD.Rmd`.

### Step 2: Write Your Notes

Open the newly created `.Rmd` file in your text editor or RStudio and fill out the sections.

### Step 3: Render Your PDF

When you are finished writing, run this command:

```sh
renderdevo
```

This will run `renderdevo_today.R`, which finds the `.Rmd` for the current date, renders it to PDF using the LaTeX template, and saves the final `Devo_YYYYMMDD.pdf` in the `Rendered_Devos/` folder.

#### To Render a Different Date

If you missed a day and want to render it, just pass the date in `YYYY-MM-DD` format:

```sh
renderdevo 2025-11-04
```

-----

## 📂 Project Structure

A high-level overview of the key files and directories.

```
.
├── Daily_Devos
├── Devo_Template.Rmd
├── README.md
├── Reading_Plan.pdf
├── Rendered_Devos
├── generate_devo.R
├── makedevo_today.R
├── renderdevo_today.R
└── svm-latex-ms.tex
```

* **`README.md`**: This file.
* **`makedevo_today.R`**: R script to create today's `.Rmd` file. (Called by `makedevo` shell function).
* **`renderdevo_today.R`**: R script to render a `.Rmd` to PDF. (Called by `renderdevo` shell function).
* **`generate_devo.R`**: The core R function used by `makedevo_today.R` to create new `.Rmd` files from the template.
* **`Devo_Template.Rmd`**: The master R Markdown template.
* **`svm-latex-ms.tex`**: The custom LaTeX template for PDF styling.
* **`Daily_Devos/`**: Staging area for all generated `.Rmd` files.
* **`Rendered_Devos/`**: Final output directory for all completed PDFs.
* **`Reading_Plan.pdf`**: Your personal reading plan document.
Design notes

* The generator edits the YAML section of the template to set params for each output file, then writes a date-stamped Rmd (Devo_YYYYMMDD.Rmd).
* Rendering uses rmarkdown/pandoc with the project LaTeX template so PDFs share a uniform layout.
* File and directory creation is handled so the workflow can be run repeatedly without manual folder setup.

Dependencies (conceptual)

* R (tested on R 4.5.x)
* LaTeX (pdflatex or equivalent available on PATH)
* R packages: tidyr, purrr, fs, here, rmarkdown, knitr (and mariner if used in the workflow)

Customization points

* Modify Devo_Template.Rmd to change content structure or YAML parameters.
* Adjust svm-latex-ms.tex for PDF appearance (fonts, margins, headers/footers).
* Change parameter generation (date range, author, additional params) in Create_Devo.R.

Outputs

* Per-day PDF files named Devo_YYYYMMDD.pdf in Rendered_Devos/.
* Corresponding Rmd files in Daily_Devos/ for reproducibility and manual edits.

Troubleshooting pointers

* Missing template errors indicate template_path or Devo_Template.Rmd is not found.
* LaTeX failures surface as .log files in Rendered_Devos/; check those for missing packages or compile errors.
* Package loading errors indicate required R packages must be installed.

Contact / maintenance

* Update generate_devo.R for changes to parameter mapping or YAML handling.
* Update Devo_Template.Rmd and the LaTeX template for content and styling changes.
