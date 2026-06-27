FROM rocker/r-ver:4.4.1

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libsodium-dev \
    zlib1g-dev \
    libgfortran-11-dev \
    gfortran \
    liblapack-dev \
    libblas-dev \
    libgmp-dev \
    libmpfr-dev \
    && rm -rf /var/lib/apt/lists/*

# Install plumber FIRST
RUN Rscript -e "install.packages('plumber', repos='https://cran.rstudio.com/')"
RUN Rscript -e "library(plumber); cat('plumber OK\n')"

# Install car dependencies explicitly first
RUN Rscript -e "install.packages(c('MASS','nnet','pbkrtest','quantreg','lme4','MatrixModels','SparseM','abind'), repos='https://cran.rstudio.com/')"
RUN Rscript -e "install.packages('car', repos='https://cran.rstudio.com/', dependencies=TRUE)"
RUN Rscript -e "library(car); cat('car OK\n')"

# Install remaining packages
RUN Rscript -e "install.packages('jsonlite', repos='https://cran.rstudio.com/')"
RUN Rscript -e "install.packages('readxl', repos='https://cran.rstudio.com/')"
RUN Rscript -e "install.packages('janitor', repos='https://cran.rstudio.com/')"
RUN Rscript -e "install.packages('dplyr', repos='https://cran.rstudio.com/')"
RUN Rscript -e "install.packages('effectsize', repos='https://cran.rstudio.com/')"
RUN Rscript -e "install.packages('psych', repos='https://cran.rstudio.com/')"

# Verify all packages
RUN Rscript -e "library(plumber); library(jsonlite); library(readxl); library(janitor); library(dplyr); library(car); library(effectsize); library(psych); cat('All packages OK\n')"

WORKDIR /app
COPY plumber.R .
COPY entrypoint.R .

EXPOSE 8000
CMD ["Rscript", "entrypoint.R"]
