#' Zip development lesson
#'
#' @param lesson folder with lesson materials
#'
#' @return compressed folder
#'
#' @importFrom glue glue
#' @importFrom utils zip
#'
zip_lesson <- function(lesson) {
  lesson_path <- glue::glue("inst/dev/{lesson}")
  lesson_files <- dir(lesson_path, full.names = TRUE)
  utils::zip(zipfile = lesson_path, files = lesson_files)
}
#' Copy zipped lesson from development into production
#'
#' @param zipped zipped lesson folder
#'
#' @return copied zip folder into production
#'
#' @importFrom glue glue
#' @importFrom fs file_exists file_copy
#' @importFrom cli cli_abort
#'
copy_lesson <- function(zipped) {
  lesson_zip <- glue::glue("inst/dev/{zipped}.zip")
  lesson_prod_zip <- glue::glue("inst/lessons/{zipped}.zip")
  if (fs::file_exists("inst/dev/import.zip")) {
    fs::file_copy(path = lesson_zip,
      new_path = lesson_prod_zip,
      overwrite = TRUE)
  } else {
    cli::cli_abort("lesson does not exist!")
  }
}

#' Move lesson from development into production
#'
#' @param lesson name of lesson
#'
#' @return copied zip folder into production
#'
#' @examples
#' new_lesson("import")
new_lesson <- function(lesson) {
  zip_lesson(lesson = lesson)
  copy_lesson(zipped = lesson)
  lesson_zip <- glue::glue("inst/dev/{lesson}.zip")
  unlink(lesson_zip, force = TRUE)
  lesson_prod_zip <- glue::glue("inst/lessons/{lesson}.zip")
  if (fs::file_exists(lesson_prod_zip)) {
    cli::cli_alert_success("lesson is ready to use!")
  }
}
