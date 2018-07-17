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
                                         git

# Updates and Installs
RUN Rscript -e "install.packages('Seurat')"
