#!/usr/bin/env Rscript

setwd(funr::get_script_path())

file.remove("_main.Rmd")
source("styler.R")
bookdown::render_book("index.Rmd")
