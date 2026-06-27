FROM rocker/r-ver:4.4.1

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Install plumber FIRST
RUN Rscript -e "install.packages('plumber', repos='https://cran.rstudio.com/')"

# Verify plumber works before continuing
RUN Rscript -e "library(plumber); cat('plumber OK\n')"

# Install remaining packages one by one
RUN Rscript -e "install.packages('jsonlite', repos='https://cran.rstudio.com/')"
RUN Rscript -e "install.packages('readxl', repos='https://cran.rstudio.com/')"
RUN Rscript -e "install.packages('janitor', repos='https://cran.rstudio.com/')"
RUN Rscript -e "install.packages('dplyr', repos='https://cran.rstudio.com/')"
RUN Rscript -e "install.packages('car', repos='https://cran.rstudio.com/')"
RUN Rscript -e "install.packages('effectsize', repos='https://cran.rstudio.com/')"
RUN Rscript -e "install.packages('psych', repos='https://cran.rstudio.com/')"

WORKDIR /app
COPY plumber.R .
COPY entrypoint.R .

EXPOSE 8000
CMD ["Rscript", "entrypoint.R"]
