library(plumber)

#* @apiTitle R Research Assistant API
#* @apiDescription Executes R scripts for statistical analysis

#* Health check endpoint
#* @get /health
#* @serializer unboxedJSON
function() {
  list(
    status = "ok",
    r_version = R.version$version.string,
    timestamp = format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ")
  )
}

#* Execute an R script and return its console output
#* @post /execute
#* @serializer unboxedJSON
#* @param req The request object
function(req) {
  body <- tryCatch(
    jsonlite::fromJSON(rawToChar(req$bodyRaw), simplifyVector = FALSE),
    error = function(e) NULL
  )

  if (is.null(body) || is.null(body$script)) {
    plumber::stop_for_status(400L, "Missing 'script' field in request body")
  }

  r_script   <- body$script
  excel_data <- body$excelData
  file_name  <- body$fileName

  # Only rewrite file_path if base64 Excel data was provided
  # If the script already contains download.file(), skip this block
  if (!is.null(excel_data) && nchar(excel_data) > 0 && !grepl("download.file", r_script)) {
    temp_dir <- file.path(tempdir(), "r-research")
    dir.create(temp_dir, showWarnings = FALSE, recursive = TRUE)
    ext <- if (!is.null(file_name)) tools::file_ext(file_name) else "xlsx"
    temp_excel_path <- file.path(temp_dir, paste0("upload_", as.numeric(Sys.time()), ".", ext))
    raw_bytes <- jsonlite::base64_dec(excel_data)
    writeBin(raw_bytes, temp_excel_path)
    r_script <- gsub(
      'file_path\\s*<-\\s*"[^"]*"',
      paste0('file_path <- "', temp_excel_path, '"'),
      r_script
    )
  }

  script_path <- tempfile(fileext = ".R")
  writeLines(r_script, script_path)

  start_time <- proc.time()

  output <- tryCatch({
    result <- system2(
      "Rscript",
      args    = c("--vanilla", script_path),
      stdout  = TRUE,
      stderr  = TRUE,
      timeout = 180
    )
    list(
      success        = (attr(result, "status") %in% c(0, NULL)),
      raw_output     = paste(result, collapse = "\n"),
      error_message  = if (!is.null(attr(result, "status")) && attr(result, "status") != 0)
                         paste(result, collapse = "\n") else NULL
    )
  }, error = function(e) {
    list(
      success       = FALSE,
      raw_output    = "",
      error_message = conditionMessage(e)
    )
  })

  elapsed_ms <- as.integer((proc.time() - start_time)[["elapsed"]] * 1000)
  tryCatch(file.remove(script_path), error = function(e) NULL)

  list(
    success           = output$success,
    raw_output        = output$raw_output,
    error_message     = output$error_message,
    execution_time_ms = elapsed_ms
  )
}

#* Check which required packages are installed
#* @get /packages
#* @serializer unboxedJSON
function() {
  required <- c("readxl", "dplyr", "janitor", "car", "effectsize",
                "psych", "lubridate", "survival", "ggplot2")
  status <- sapply(required, function(pkg) {
    list(
      installed = requireNamespace(pkg, quietly = TRUE),
      version   = tryCatch(as.character(packageVersion(pkg)), error = function(e) "not installed")
    )
  }, USE.NAMES = TRUE)
  list(packages = status)
}
