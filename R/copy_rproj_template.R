#' Copy .Rproj file to production folder
#'
#' @param folder name of folder/project
#'
#' @return folder in inst/prod
#' @export copy_rproj_template
#'
#' @importFrom fs path_dir path_wd dir_create file_copy
#'
#' @examples
#' copy_rproj_template("test")
copy_rproj_template <- function(folder) {
  template_path <- system.file("templates/template.Rproj", package = "usethis")
  new_rproj_path <- paste0("inst/prod/", folder, "/", folder, ".Rproj", collapse = "/")
  new_rproj_fpath <- as.character(fs::path_wd(new_rproj_path))
  new_rproj_dpath <- fs::path_dir(new_rproj_fpath)
  fs::dir_create(new_rproj_dpath)
  fs::file_copy(path = template_path, new_path = new_rproj_fpath, overwrite = TRUE)
}

