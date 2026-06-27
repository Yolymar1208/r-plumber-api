# entrypoint.R — starts the Plumber API server
# Render.com calls this file to start the service

library(plumber)

port <- as.integer(Sys.getenv("PORT", unset = "8000"))

cat("Starting R Research Assistant Plumber API on port", port, "\n")
cat("R version:", R.version$version.string, "\n")

pr <- plumb("plumber.R")

pr$run(
  host   = "0.0.0.0",
  port   = port,
  debug  = FALSE,
  docs   = FALSE  # disable Swagger UI in production
)
