FROM rocker/r-ver:4.4.1

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

RUN Rscript -e "install.packages('plumber', repos='https://cran.rstudio.com/', dependencies=TRUE)"
RUN Rscript -e "install.packages('jsonlite', repos='https://cran.rstudio.com/', dependencies=TRUE)"
RUN Rscript -e "install.packages(c('readxl','dplyr','tidyr','janitor'), repos='https://cran.rstudio.com/', dependencies=TRUE)"
RUN Rscript -e "install.packages(c('car','effectsize','psych'), repos='https://cran.rstudio.com/', dependencies=TRUE)"
RUN Rscript -e "install.packages(c('gtsummary','ggplot2','gt'), repos='https://cran.rstudio.com/', dependencies=TRUE)"

WORKDIR /app
COPY plumber.R .
COPY entrypoint.R .

EXPOSE 8000
CMD ["Rscript", "entrypoint.R"]
