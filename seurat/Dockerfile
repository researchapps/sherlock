FROM r-base
MAINTAINER vsochat@stanford.edu

# https://satijalab.org/seurat/install.html
# docker build -t vanessa/seurat .

ENV DEBIAN_FRONTEND noninteractive

# Dependencies for opendrift
RUN apt-get update && apt-get install -y build-essential \
                                         apt-utils \ 
                                         unzip \
                                         vim \
                                         git \
                                         libssl-dev \
                                         libcurl4-openssl-dev

# Updates and Installs
RUN Rscript -e "install.packages('httr')"
RUN Rscript -e "install.packages('plotly')"
RUN apt-get install -y libhdf5-dev
RUN Rscript -e "install.packages('hdf5r')"
RUN Rscript -e "install.packages('Seurat')"
