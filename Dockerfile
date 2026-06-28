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
    libgsl-dev \
    cmake \
    && rm -rf /var/lib/apt/lists/*

RUN Rscript -e "install.packages('plumber', repos='https://cran.rstudio.com/')"
RUN Rscript -e "library(plumber); cat('plumber OK\n')"
RUN Rscript -e "install.packages('Matrix', repos='https://cran.rstudio.com/')"
RUN Rscript -e "install.packages('lme4', repos='https://cran.rstudio.com/')"
RUN Rscript -e "library(lme4); cat('lme4 OK\n')"
RUN Rscript -e "install.packages(c('pbkrtest','SparseM','quantreg','abind','nnet','MASS'), repos='https://cran.rstudio.com/')"
RUN Rscript -e "install.packages('carData', repos='https://cran.rstudio.com/')"
RUN Rscript -e "install.packages('car', repos='https://cran.rstudio.com/')"
RUN Rscript -e "library(car); cat('car OK\n')"
RUN Rscript -e "install.packages('jsonlite', repos='https://cran.rstudio.com/')"
RUN Rscript -e "install.packages('readxl', repos='https://cran.rstudio.com/')"
RUN Rscript -e "install.packages('janitor', repos='https://cran.rstudio.com/')"
RUN Rscript -e "install.packages('dplyr', repos='https://cran.rstudio.com/')"
RUN Rscript -e "install.packages('effectsize', repos='https://cran.rstudio.com/')"
RUN Rscript -e "install.packages('psych', repos='https://cran.rstudio.com/')"
RUN Rscript -e "install.packages('lubridate', repos='https://cran.rstudio.com/')"
RUN Rscript -e "install.packages('survival', repos='https://cran.rstudio.com/')"
RUN Rscript -e "install.packages('ggplot2', repos='https://cran.rstudio.com/')"

RUN Rscript -e "library(plumber); library(jsonlite); library(readxl); library(janitor); library(dplyr); library(car); library(effectsize); library(psych); library(lubridate); library(survival); library(ggplot2); cat('All packages OK\n')"

WORKDIR /app
COPY plumber.R .
COPY entrypoint.R .

EXPOSE 8000
CMD ["Rscript", "entrypoint.R"]
