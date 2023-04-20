#' Check if development deck exists
#'
#' @param name name of folder or lesson
#'
#' @return relative path to slides in `inst/dev/`
#' @export check_dev_dir
#'
#' @importFrom stringr str_detect
#' @importFrom glue glue
#' @importFrom cli cli_abort
#' @importFrom rprojroot find_root_file from_wd
#'
#' @examples
#' check_dev_dir("test")
check_dev_dir <- function(name) {
      root_dir <- rprojroot::find_root_file(criterion = rprojroot::from_wd)
      all_dirs <- list.dirs(root_dir, full.names = TRUE, recursive = TRUE)
      # search for match
      inst_dev_dir <- all_dirs[stringr::str_detect(all_dirs, glue::glue("inst/dev/{name}$"))]
      # check
      if (length(inst_dev_dir) == 0) {
        cli::cli_abort(glue::glue("no inst/dev/{name} folder!"))
      } else {
        return(inst_dev_dir)
      }
}
#' Create production folder
#'
#' @param name name of development folder to move into production
#'
#' @return folder in `inst/prod`
#' @export create_prod_dir
#'
#' @importFrom fs dir_create
#' @importFrom cli cli_alert
#' @importFrom glue glue
#' @importFrom rprojroot find_root_file from_wd
#'
#' @examples
#' create_prod_dir("test")
create_prod_dir <- function(name) {
  dev_dir <- check_dev_dir(name)
  # create new production folder
  root_dir <- rprojroot::find_root_file(criterion = rprojroot::from_wd)
  prod_dir <- file.path(root_dir, "inst/prod", basename(dev_dir))
  if (dir.exists(prod_dir)) {
    cli::cli_alert_info(glue::glue("inst/prod/{name} located"))
  } else {
    cli::cli_text(glue::glue("{name} does not exist in inst/prod/..."))
    fs::dir_create(prod_dir)
    cli::cli_alert_success(glue::glue("inst/prod/{name} created!"))
  }
}
#' Create development pdf slides
#'
#' @param name name of development folder
#'
#' @return pdf slides in `inst/dev`
#' @export create_pdf_slides
#'
#' @importFrom purrr walk2
#' @importFrom fs file_copy dir_create
#' @importFrom cli cli_abort cli_alert
#' @importFrom glue glue
#' @importFrom rprojroot find_root_file from_wd
#' @importFrom pagedown chrome_print
#'
#' @examples
#' create_pdf_slides("test")
create_pdf_slides <- function(name) {
      dev_dir <- check_dev_dir(name)
      create_prod_dir(name = name)
      # dev html file
      html_file <- list.files(path = dev_dir,
                              pattern = "slides.html$",
                              full.names = TRUE)
      # create pdf path (dev)
      pdf_dev_file <- stringr::str_replace_all(html_file, ".html", ".pdf")
      # create pdf path (prod)
      pdf_prod_file <- stringr::str_replace_all(pdf_dev_file, "/dev/", "/prod/")
      if (length(html_file) < 1) {
        cli::cli_abort(glue::glue("no 'html' slides in inst/dev/{name}!"))
      } else {
      pagedown::chrome_print(input = html_file, output = pdf_prod_file,
        timeout = 360)
        cli::cli_alert_success(
          glue::glue("'html' slides converted to 'pdf' in inst/prod/{name}!"))
      }
}
#' Copy development pdf slides to production
#'
#' @param name name of development folder
#'
#' @return copied pdf slides in `inst/dev`
#' @export copy_dev_slides
#'
#' @importFrom purrr walk2
#' @importFrom fs file_copy dir_create
#' @importFrom cli cli_abort cli_alert
#' @importFrom glue glue
#' @importFrom rprojroot find_root_file from_wd
#' @importFrom stringr str_replace_all
#'
#' @examples
#' copy_dev_slides("test")
copy_dev_slides <- function(name) {
      dev_dir <- check_dev_dir(name)
      # dev pdf file
      dev_pdf_file <- list.files(path = dev_dir,
                              pattern = "slides.pdf$",
                              full.names = TRUE)
      prod_pdf_file <- stringr::str_replace_all(dev_pdf_file, "/dev", "/prod")
      if (!file.exists(dev_pdf_file)) {
        cli::cli_abort(glue::glue("no 'pdf' file in inst/dev/{name}!"))
      } else {
        fs::file_copy(path = dev_pdf_file, new_path = prod_pdf_file,
                      overwrite = TRUE)
        cli::cli_alert_success(
          glue::glue("copied 'pdf' file to inst/prod/{name}!"))
      }
}
#' Create .Rproj file in production folder
#'
#' @param name name of folder/project
#'
#' @return folder in inst/prod
#' @export create_rproj_file
#'
#' @importFrom fs path_wd
#' @importFrom cli cli_abort
#' @importFrom readr write_lines
#'
#' @examples
#' create_rproj_file("test")
create_rproj_file <- function(name) {
  rproj_content <- "Version: 1.0

RestoreWorkspace: Default
SaveWorkspace: Default
AlwaysSaveHistory: Default

EnableCodeIndexing: Yes
UseSpacesForTab: Yes
NumSpacesForTab: 2
Encoding: UTF-8

RnwWeave: Sweave
LaTeX: XeLaTeX

  "
  inst_dir <- fs::path_wd("inst/")
  inst_prod_dir <- paste0(inst_dir, "/", "prod", collapse = "/")
  if (!dir.exists(inst_prod_dir)) {
    dir.create(inst_prod_dir)
  }

  inst_prod_rproj_dir <- paste0(inst_prod_dir, "/", name, collapse = "/")
  if (!dir.exists(inst_prod_rproj_dir)) {
    dir.create(inst_prod_rproj_dir)
  } else {
    rproj_file <- paste0(inst_prod_rproj_dir, "/", name, ".Rproj")
    readr::write_lines(x = rproj_content, file = rproj_file)
        cli::cli_alert(
          glue::glue("{name}.Rproj file created in inst/prod/{name}!"))
  }
}
#' Copy development data folder to production
#'
#' @param name name of development folder
#'
#' @return copied data folder to `inst/prod/data`
#' @export copy_dev_data
#'
#' @importFrom purrr walk2 map_chr walk
#' @importFrom fs file_copy dir_create
#' @importFrom cli cli_alert_success cli_alert
#' @importFrom glue glue
#' @importFrom stringr str_replace_all
#' @importFrom rprojroot find_root_file from_wd
#'
#' @examples
#' copy_dev_data("test")
copy_dev_data <- function(name) {
      dev_dir <- check_dev_dir(name)
      # create production folder
      root_dir <- rprojroot::find_root_file(criterion = rprojroot::from_wd)
      prod_dir <- file.path(root_dir, "inst/prod", basename(dev_dir))
      # create production data folder path
      prod_data_dir <- file.path(prod_dir, "data")
      # create development data folder path
      dev_data_dir <- file.path(dev_dir, "data")
      # dev data files
      dev_data_files <- list.files(path = dev_data_dir,
                            full.names = TRUE,
                            recursive = TRUE)
      # prod data files
      prod_data_files <- stringr::str_replace_all(dev_data_files, "/dev/", "/prod/")
     if (length(dev_data_files) < 1) {
       cli::cli_alert(glue::glue("no data filees in inst/dev/{name} to copy!"))
     } else {
       prod_data_dirs <- purrr::map_chr(.x = prod_data_files, .f = dirname)
       purrr::walk(.x = prod_data_dirs, .f = fs::dir_create)
       # copy files
       purrr::walk2(.x = dev_data_files, .y = prod_data_files,
                    .f = fs::file_copy, overwrite = TRUE)
       cli::cli_alert_success(glue::glue("data files copied to inst/prod/{name}!"))
     }
}
#' Copy development image folder to production
#'
#' @param name name of development folder
#'
#' @return copied image folder to `inst/prod/img`
#' @export copy_dev_img
#'
#' @importFrom purrr walk2
#' @importFrom fs file_copy dir_create
#' @importFrom cli cli_alert
#' @importFrom glue glue
#' @importFrom rprojroot find_root_file from_wd
#'
#' @examples
#' copy_dev_img("test")
copy_dev_img <- function(name) {
      dev_dir <- check_dev_dir(name)
      # create production folder
      root_dir <- rprojroot::find_root_file(criterion = rprojroot::from_wd)
      prod_dir <- file.path(root_dir, "inst/prod", basename(dev_dir))
      # create production img folder
      prod_img_dir <- file.path(prod_dir, "img")
      # dev folders
      dev_dirs <- list.dirs(path = dev_dir,
                            full.names = TRUE)
      # get folder matches
      dir_matches <- stringr::str_detect(dev_dirs, "img$")
      # subset matches
      prod_dirs <- dev_dirs[dir_matches]
      if (dir.exists(prod_dir)) {
        fs::dir_create(prod_img_dir)
        purrr::walk2(.x = prod_dirs, .y = prod_img_dir,
                     .f = fs::dir_copy, overwrite = TRUE)
        cli::cli_alert(glue::glue("img folder copied to inst/prod/{name}!"))
      } else {
        cli::cli_alert(glue::glue("no img folder in inst/dev/{name} to copy!"))
      }
}
#' Copy development worksheet folder to production
#'
#' @param name name of development folder
#'
#' @return copied worksheet folder to `inst/prod/worksheets`
#' @export copy_dev_worksheets
#'
#' @importFrom purrr walk2
#' @importFrom fs file_copy dir_create
#' @importFrom cli cli_alert
#' @importFrom glue glue
#' @importFrom rprojroot find_root_file from_wd
#'
#' @examples
#' copy_dev_worksheets("test")
copy_dev_worksheets <- function(name) {
      dev_dir <- check_dev_dir(name)
      # create production folder
      root_dir <- rprojroot::find_root_file(criterion = rprojroot::from_wd)
      prod_dir <- file.path(root_dir, "inst/prod", basename(dev_dir))
      # create production worksheet folder path
      prod_worksheet_dir <- file.path(prod_dir, "worksheets")
      # create development worksheets folder path
      dev_worksheets_dir <- file.path(dev_dir, "worksheets")
      # dev worksheets files
      dev_worksheets_files <- list.files(path = dev_worksheets_dir,
                            full.names = TRUE,
                            recursive = TRUE)

      # prod worksheets files
      prod_worksheets_files <- stringr::str_replace_all(dev_worksheets_files,
                                                        "/dev/", "/prod/")
     if (length(dev_worksheets_files) < 1) {
       cli::cli_alert(glue::glue("no worksheet filees in inst/dev/{name} to copy!"))
     } else {
       prod_worksheet_dirs <- purrr::map_chr(.x = prod_worksheets_files, .f = dirname)
       purrr::walk(.x = prod_worksheet_dirs, .f = fs::dir_create)
       # copy files
       purrr::walk2(.x = dev_worksheets_files, .y = prod_worksheets_files,
                    .f = fs::file_copy, overwrite = TRUE)
       cli::cli_alert_success(
         glue::glue("worksheet files copied to inst/prod/{name}!"))
     }
}
#' Build Production Materials
#'
#' @param name
#'
#' @return production materials in `inst/prod/`
#' @export build_prod
#'
#' @importFrom cli cli_alert
#' @importFrom glue glue
#' @importFrom fs path_wd
#'
#' @examples
#' build_prod("test")
build_prod <- function(name) {

  create_prod_dir(name = name)
  create_rproj_file(name = name)
  create_pdf_slides(name = name)
  copy_dev_slides(name = name)
  copy_dev_data(name = name)
  copy_dev_worksheets(name = name)

  inst_dir <- fs::path_wd("inst/")
  inst_prod_dir <- paste0(inst_dir, "/", "prod", collapse = "/")
  prod_dir <- paste0(inst_prod_dir, "/", name)
  if (dir.exists(prod_dir)) {
  cli::cli_alert(glue::glue("The following files have been copied to \n"))
  fs::dir_tree(path = prod_dir)
  } else {
    cli::cli_alert(glue::glue("Problem copying {prod_dir}"))
  }
}
#' Remove production folder
#'
#' @return removed folder message
#' @export remove_prod_dir
#'
#' @importFrom cli cli_alert
#' @importFrom rprojroot find_root_file from_wd
#' @importFrom stringr str_detect
#'
#' @examples
#' remove_prod_dir("test")
remove_prod_dir <- function(name) {
  root_dir <- rprojroot::find_root_file(criterion = rprojroot::from_wd)
  all_dirs <- list.dirs(root_dir, full.names = TRUE, recursive = TRUE)
  inst_prod_dir <- all_dirs[stringr::str_detect(all_dirs, "inst/prod$")]
  prod_dir <- paste0(inst_prod_dir, "/", name)
  if (dir.exists(prod_dir)) {
    cli::cli_alert(glue::glue("inst/prod/{name}/ folder has been removed"))
    unlink(prod_dir, recursive = TRUE, force = TRUE)
  } else {
    cli::cli_alert(glue::glue("no inst/prod/{name}/ folder to remove"))
  }
}
