
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pdgdev

<!-- badges: start -->
<!-- badges: end -->

The goal of `pdgdev` is to provide a set of tools for developing
materials for PDG slides and materials.

## Installation

This is a private repo, so only users can access.

## Build development materials

Build production folder `foo`

``` r
library(pdgdev)
build_dev("foo")
#> → 'foo' folder created in inst/dev/!
#> → slides.Rmd file created in inst/dev/foo!
#> → created css folder inst/dev/foo!
#> → created data folder inst/dev/foo!
#> → created styles.css file inst/dev/foo!
#> /Users/mjfrigaard/projects/pkgs/pdgdev/inst/dev/foo
#> ├── css
#> │   └── styles.css
#> ├── data
#> └── slides.Rmd
```

Remove `foo` folder from development:

``` r
remove_dev_dir("foo")
#> → inst/dev/foo/ folder has been removed
```

``` r
fs::dir_tree("inst/dev/", recurse = FALSE)
#> inst/dev/
#> ├── import
#> ├── iteration
#> ├── objects
#> ├── reshape
#> ├── rmarkdown
#> ├── tables
#> ├── test
#> └── transform
```

## Copy development materials to production

After creating materials in `inst/dev/`, copy them into `inst/prod/`
with `build_prod()`

``` r
build_prod("test")
#> → inst/prod/test created!
#> → test.Rproj file created in inst/prod/test!
#> ✔ copied 'pdf' file to inst/prod/test!
#> ✔ data files copied to inst/prod/test!
#> ✔ worksheet files copied to inst/prod/test!
#> → The following files have been copied to
#> /Users/mjfrigaard/projects/pkgs/pdgdev/inst/prod/test
#> ├── data
#> │   ├── csv
#> │   │   └── nhanes_11_12.csv
#> │   ├── downloads
#> │   │   └── medical.sas7bdat
#> │   ├── medical.sas7bdat
#> │   └── sas
#> │       ├── elemapi-2000.sas7bdat
#> │       ├── elemapi2-2000.sas7bdat
#> │       ├── hsb2.sas7bdat
#> │       └── nations.sas7bdat
#> ├── slides.pdf
#> ├── test.Rproj
#> └── worksheets
#>     └── test.Rmd
```

Remove `test` folder from production:

``` r
remove_prod_dir("test")
#> → inst/prod/test/ folder has been removed
```

``` r
fs::dir_tree("inst/prod/", recurse = FALSE)
#> inst/prod/
#> ├── import
#> ├── iteration
#> └── objects
```
