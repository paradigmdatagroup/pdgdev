#' Create development folder in `inst/dev/`
#'
#' @param name name of folder
#'
#' @return folder in dev
#' @export create_dev_slide_dir
#'
#' @importFrom rprojroot find_root_file from_wd
#' @importFrom stringr str_detect
#' @importFrom fs dir_tree dir_create
#' @importFrom cli cli_alert
#'
#' @examples
#' create_dev_slide_dir("foo")
create_dev_slide_dir <- function(name) {
  root_dir <- rprojroot::find_root_file(criterion = rprojroot::from_wd)
  all_dirs <- list.dirs(root_dir, full.names = TRUE, recursive = TRUE)
  inst_dev_dir <- all_dirs[stringr::str_detect(all_dirs, "inst/dev$")]
  new_dev_dir <- paste0(inst_dev_dir, "/", name)
  # return(new_dev_dir)
  if (dir.exists(new_dev_dir)) {
    fs::dir_tree(inst_dev_dir, recurse = FALSE)
    cli::cli_alert("folder already exists in dev!")
  } else {
    fs::dir_create(new_dev_dir)
    cli::cli_alert("'{name}' folder created in inst/dev/!")
  }
}

#' Get `slides.Rmd` file from `inst/dev/` folder
#'
#' @param name name of development folder
#'
#' @return slides.Rmd file
#' @export get_slides_rmd
#'
#' @importFrom rprojroot find_root_file from_wd
#' @importFrom stringr str_detect
#' @importFrom fs dir_tree dir_create
#' @importFrom cli cli_abort
#'
#' @examples
#' get_slides_rmd("foo")
get_slides_rmd <- function(name) {
  root_dir <- rprojroot::find_root_file(criterion = rprojroot::from_wd)
  all_dirs <- list.dirs(root_dir, full.names = TRUE, recursive = TRUE)
  inst_dev_name_dir <- all_dirs[stringr::str_detect(all_dirs, paste0("inst/dev/", name, "$"))]
  slides_rmd <- list.files(inst_dev_name_dir, full.names = TRUE, pattern = "slides.Rmd")
  if (length(slides_rmd) == 0) {
    cli::cli_abort("No slides.Rmd file!")
  } else {
    return(slides_rmd)
  }
}

#' Write YAML head for slides.Rmd
#'
#' @param name name of slides and development folder
#'
#' @return slides file with YAML
#' @export write_slide_yaml
#'
#' @importFrom rprojroot find_root_file from_wd
#' @importFrom stringr str_detect
#' @importFrom fs dir_tree dir_create
#' @importFrom cli cli_abort
#'
#' @examples
#' write_slide_yaml("foo")
write_slide_yaml <- function(name) {
  slides_rmd <- get_slides_rmd(name = name)
  # return(slides_rmd)
  yaml_header <- "---
title: '{name}'
subtitle: ''
author: 'Martin Frigaard'
institute: 'Paradigm Data Group'
date: '`r Sys.Date()`'
output:
  xaringan::moon_reader:
    css:
      - default
      - css/styles.css
    lib_dir: libs
    seal: false
    nature:
      highlightStyle: github
      highlightLines: true
      countIncrementalSlides: false
      ratio: '16:9'
---"
  readr::write_lines(x = glue::glue(yaml_header), file = slides_rmd, append = FALSE)
}

#' Write meta code chunk for slides.Rmd
#'
#' @param name name of slides and development folder
#'
#' @return slides file with meta chunk
#' @export write_slide_meta
#'
#' @importFrom rprojroot find_root_file from_wd
#' @importFrom stringr str_detect
#' @importFrom fs dir_tree dir_create
#' @importFrom cli cli_abort
#'
#' @examples
#' write_slide_meta("foo")
write_slide_meta <- function(name) {
  slides_rmd <- get_slides_rmd(name = name)
  # return(slides_rmd)
  meta_chunk <- "\n\n\n\`\`\`{{r meta, echo=FALSE}}
library(metathis)
meta() |>
  meta_general(
    description = '{name}',
    generator = 'xaringan and remark.js'
  ) |>
  meta_name('github-repo' = 'paradigmdatagroup/{name}/') |>
  meta_social(
    title = '{name}',
    url = 'https://github.com/paradigmdatagroup/{name}/',
    og_type = 'website',
    og_author = 'Martin Frigaard'
  )
\`\`\`"
  readr::write_lines(x = glue::glue(meta_chunk), file = slides_rmd, append = TRUE)
}

#' Write setup code chunk for slides.Rmd
#'
#' @param name name of slides and development folder
#'
#' @return slides file with setup chunk
#' @export write_slide_setup
#'
#' @importFrom rprojroot find_root_file from_wd
#' @importFrom stringr str_detect
#' @importFrom fs dir_tree dir_create
#' @importFrom cli cli_abort
#'
#' @examples
#' write_slide_setup("foo")
write_slide_setup <- function(name) {
  slides_rmd <- get_slides_rmd(name = name)
setup_chunk <- "\n\n\n\`\`\`{{r setup, include=FALSE}}
dateWritten <- format(Sys.Date(), format = '%B %d %Y')
today <- format(Sys.Date(), format = '%B %d %Y')
library(knitr)
library(rmarkdown)
library(fontawesome)
library(gtsummary)
options(
    htmltools.dir.version = FALSE,
    knitr.table.format = 'html',
    knitr.kable.NA = ''
)
knitr::opts_chunk$set(
    warning = FALSE,
    message = FALSE,
    fig.path = 'www/',
    fig.width = 7.252,
    fig.height = 4,
    comment = ' ',
    fig.retina = 3 # Better figure resolution
)
# knitr::opts_knit$set(root.dir = 'slides/')
# Enables the ability to show all slides in a tile overview by pressing 'o'
xaringanExtra::use_tile_view()
xaringanExtra::use_panelset()
xaringanExtra::use_clipboard()
xaringanExtra::use_share_again()
xaringanExtra::style_share_again(share_buttons = 'all')
xaringanExtra::use_extra_styles(
  hover_code_line = TRUE,
  mute_unhighlighted_code = FALSE
)
\`\`\`"
 readr::write_lines(x = glue::glue(setup_chunk), file = slides_rmd, append = TRUE)
}

#' Write slide header for slides.Rmd
#'
#' @param name name of slides and development folder
#'
#' @return slides file with header
#' @export write_slide_header
#'
#' @importFrom rprojroot find_root_file from_wd
#' @importFrom stringr str_detect
#' @importFrom fs dir_tree dir_create
#' @importFrom cli cli_abort
#'
#' @examples
#' write_slide_header("foo")
write_slide_header <- function(name) {
  slides_rmd <- get_slides_rmd(name = name)
slide_header <- "layout: true

<!-- this adds the link footer to all slides, depends on footer-small class in css-->

<div class='footer-small'><span>https://github.com/paradigmdatagroup/{name}/</div>

---
name: title-slide
class: title-slide, center, middle, inverse

# `r rmarkdown::metadata$title`
#.fancy[`r rmarkdown::metadata$subtitle`]

<br>

.large[by Martin Frigaard]

Written: `r dateWritten`

Updated: `r today`
\n\n\n"
  readr::write_lines(x = glue::glue(slide_header), file = slides_rmd, append = TRUE)
}

#' Create the development slide .Rmd file
#'
#' @param name name of development folder/file
#'
#' @return slides.Rmd file
#' @export create_dev_slide_file
#'
#' @importFrom rprojroot find_root_file from_wd
#' @importFrom stringr str_detect
#' @importFrom fs dir_tree dir_create
#' @importFrom glue glue
#' @importFrom cli cli_alert
#'
#' @examples
#' create_dev_slide_file("foo")
create_dev_slide_file <- function(name) {
  root_dir <- rprojroot::find_root_file(criterion = rprojroot::from_wd)
  all_dirs <- list.dirs(root_dir, full.names = TRUE, recursive = TRUE)
  inst_dev_dir <- all_dirs[stringr::str_detect(all_dirs, "inst/dev$")]
  new_dev_dir <- paste0(inst_dev_dir, "/", name)
  new_dev_file <- paste0(new_dev_dir, "/", "slides.Rmd")
  # return(new_dev_file)
  if (file.exists(new_dev_file)) {
    fs::dir_tree(new_dev_dir, recurse = FALSE)
    cli::cli_alert("slides.Rmd file already exists!")
  } else if (!file.exists(new_dev_file) & dir.exists(new_dev_dir)) {
    fs::file_create(new_dev_file)
    write_slide_yaml(name = name)
    write_slide_meta(name = name)
    write_slide_setup(name = name)
    write_slide_header(name = name)
    cli::cli_alert(glue::glue("slides.Rmd file created in inst/dev/{name}!"))
    # ((!file.exists(new_dev_file) & !dir.exists(new_dev_dir)))
  } else {
    cli::cli_alert(glue::glue("no {name} folder in inst/dev--creating now..."))
    fs::dir_create(new_dev_dir)
    fs::file_create(new_dev_file)
    cli::cli_alert(glue::glue("slides.Rmd file created in inst/dev/{name}!"))
    write_slide_yaml(name = name)
    write_slide_meta(name = name)
    write_slide_setup(name = name)
    write_slide_header(name = name)
  }
}

#' Create slide development folders
#'
#' @param name name of folder/lesson
#'
#' @return css and data folders in inst/dev
#' @export create_slide_folders
#'
#' @importFrom rprojroot find_root_file from_wd
#' @importFrom stringr str_detect
#' @importFrom fs dir_create
#' @importFrom glue glue
#' @importFrom cli cli_alert
#'
#' @examples
#' create_slide_folders("foo")
create_slide_folders <- function(name) {
  root_dir <- rprojroot::find_root_file(criterion = rprojroot::from_wd)
  all_dirs <- list.dirs(root_dir, full.names = TRUE, recursive = TRUE)
  inst_dev_dir <- all_dirs[stringr::str_detect(all_dirs, "inst/dev$")]
  new_dev_dir <- paste0(inst_dev_dir, "/", name)
  new_css_dir <- paste0(new_dev_dir, "/", "css")
  if (dir.exists(new_css_dir)) {
    cli::cli_alert(glue::glue("css folder already exists in inst/dev/{name}!"))
  } else {
    fs::dir_create(new_css_dir)
    cli::cli_alert(glue::glue("created css folder inst/dev/{name}!"))
  }
  new_data_dir <- paste0(new_dev_dir, "/", "data")
  if (dir.exists(new_data_dir)) {
    cli::cli_alert(glue::glue("data folder already exists in inst/dev/{name}!"))
  } else {
    fs::dir_create(new_data_dir)
    cli::cli_alert(glue::glue("created data folder inst/dev/{name}!"))
  }
}

#' Copy CSS template to development css folder
#'
#' @param name name of folder/lesson
#'
#' @return css style file in inst/dev
#' @export copy_css_styles
#'
#' @importFrom rprojroot find_root_file from_wd
#' @importFrom stringr str_detect
#' @importFrom fs file_copy
#' @importFrom glue glue
#' @importFrom cli cli_alert
#'
#' @examples
#' copy_css_styles("foo")
copy_css_styles <- function(name) {
  root_dir <- rprojroot::find_root_file(criterion = rprojroot::from_wd)
  all_dirs <- list.dirs(root_dir, full.names = TRUE, recursive = TRUE)
  inst_dev_css_dir <- all_dirs[stringr::str_detect(all_dirs, glue::glue("inst/dev/{name}/css$"))]
  inst_dev_css_file <- paste0(inst_dev_css_dir, "/", "styles.css")
  # # copy css template
  css_template <- system.file("templates/styles-template.css", package = "pdgdev")
  if (file.exists(inst_dev_css_file)) {
    cli::cli_alert(glue::glue("css file already exists in inst/dev/{name}!"))
  } else {
    fs::file_copy(path = css_template, new_path = inst_dev_css_file, overwrite = TRUE)
    cli::cli_alert(glue::glue("created styles.css file inst/dev/{name}!"))
  }
}


#' Build development materials
#'
#' @param name name of lesson
#'
#' @return development folder
#' @export build_dev
#'
#' @examples
#' build_dev("foo")
build_dev <- function(name) {
  create_dev_slide_dir(name = name)
  create_dev_slide_file(name = name)
  create_slide_folders(name = name)
  copy_css_styles(name = name)
  # root dir
  root_dir <- rprojroot::find_root_file(criterion = rprojroot::from_wd)
  new_dev_dir <- file.path(glue::glue("{root_dir}/inst/dev/{name}"))
  fs::dir_tree(new_dev_dir)
}

#' Remove development folder
#'
#' @return removed folder message
#' @export remove_dev_dir
#'
#' @importFrom cli cli_alert
#' @importFrom rprojroot find_root_file from_wd
#' @importFrom stringr str_detect
#'
#' @examples
#' remove_prod_dir("foo")
remove_dev_dir <- function(name) {
  root_dir <- rprojroot::find_root_file(criterion = rprojroot::from_wd)
  all_dirs <- list.dirs(root_dir, full.names = TRUE, recursive = TRUE)
  inst_dev_dir <- all_dirs[stringr::str_detect(all_dirs, "inst/dev$")]
  dev_dir <- paste0(inst_dev_dir, "/", name)
  if (dir.exists(dev_dir)) {
    cli::cli_alert(glue::glue("inst/dev/{name}/ folder has been removed"))
    unlink(dev_dir, recursive = TRUE, force = TRUE)
  } else {
    cli::cli_alert(glue::glue("no inst/dev/{name}/ folder to remove"))
  }
}
