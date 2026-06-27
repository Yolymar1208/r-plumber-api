# Dockerfile — R Plumber API for R Research Assistant
# Base image: Rocker R with all common packages pre-installed

FROM rocker/r-ver:4.4.1

# Install system dependencies for R packages
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    && rm -rf /var/lib/apt/lists/*

# Install R packages
RUN Rscript -e "install.packages(c( \
    'plumber', \
    'jsonlite', \
    'readxl', \
    'dplyr', \
    'tidyr', \
    'ggplot2', \
    'janitor', \
    'car', \
    'effectsize', \
    'psych', \
    'gtsummary', \
    'gt' \
  ), repos='https://cran.rstudio.com/', dependencies=TRUE)"

# Create app directory
WORKDIR /app

# Copy API files
COPY plumber.R .
COPY entrypoint.R .

# Expose port (Render sets PORT env var automatically)
EXPOSE 8000

# Start the API
CMD ["Rscript", "entrypoint.R"]
