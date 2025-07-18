library(dplyr)
if (!requireNamespace("readxl")) stop("read_xlsx is a required package")

slidesdb_dir <- Sys.getenv("SLIDESDB_DIR")
if (!dir.exists(slidesdb_dir)) stop(paste0(slidesdb_dir, " does not exist"))

slidesdb_xlsx <- Sys.getenv("SLIDESDB_XLSX")
if (!file.exists(file.path(slidesdb_dir, slidesdb_xlsx))) stop(paste0(slidesdb_xlsx, " does not exist"))

slidesdb_tbl <- readxl::read_xlsx(file.path(slidesdb_dir, slidesdb_xlsx))

sldimg_dir_src <- file.path(slidesdb_dir, "images")
if (!dir.exists(sldimg_dir_src)) stop(paste0(sldimg_dir_src, " does not exist"))

## Define the directory where images for slides should go (must do this in a code chunk??)
sldimg_dir_dest <- file.path(getwd(), "images/")
if (!dir.exists(sldimg_dir_dest)) stop(paste0(sldimg_dir_dest, " does not exist"))

## Set the `slides_img_dir` option which is commonly used in slideutils::su_img_build()
options(slides_img_dir = sldimg_dir_dest)

get_slide <- function(slide_name, version = NULL) {
  res <- character(0)
  
  for (one_slide_name in slide_name) {
    candidate_slides_tbl <- dplyr::filter(slidesdb_tbl, slide_name == .env$one_slide_name)
    
    if (nrow(candidate_slides_tbl) == 0) {
      stop(paste0("Can't find a row in the slide database for: ", one_slide_name))
    } else {
      
      ## Use the latest version if not specified
      if (is.null(version)) {
        version_use <- max(candidate_slides_tbl$version) 
      } else {
        version_use <- version
      }
      
      this_slide_tbl <- dplyr::filter(candidate_slides_tbl, version == version_use) 
      
      if (nrow(this_slide_tbl) == 0) { 
        stop(paste0("Can't find a row in the slide database for version", version_use, " of ", one_slide_name))
      }
      
      if (nrow(this_slide_tbl) == 0) { 
        stop(paste0("Can't find a row in the slide database for version", version_use, " of ", one_slide_name))
      }
      
      ## Copy over any missing images if needed
      if (!is.na(this_slide_tbl$images)) {
        images_fn <- trimws(unlist(strsplit(this_slide_tbl$images, ",")))
        
        missing_images_fn <- images_fn[!file.exists(file.path(sldimg_dir_dest, images_fn))]
        if (length(missing_images_fn) > 0) {
          
          for (missing_fn in missing_images_fn) {
            copied_yn <- file.copy(from = file.path(sldimg_dir_src, missing_fn),
                                   to = file.path(sldimg_dir_dest, missing_fn) )
            if (copied_yn) {
              message(paste0("\n - copied ", missing_fn, " to images"))
            } else {
              stop(paste0("Did not find ", missing_fn, " in ", sldimg_dir_src))
            }
          }
        }  
      }
      
      ## Return the full path to the Rmd
      res <- c(res, with(this_slide_tbl, paste0(slidesdb_dir, "/", one_slide_name, ".", version_use, ".Rmd")))
    }
    
  }
  
  res
  
}