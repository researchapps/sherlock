FROM continuumio/miniconda
MAINTAINER vsochat@stanford.edu

# https://github.com/opendrift/opendrift/wiki
# docker build -t vanessa/opendrift .

ENV DEBIAN_FRONTEND noninteractive
ENV PATH /code/opendrift/opendrift/scripts:$PATH

# Dependencies for opendrift
RUN apt-get update && apt-get install -y build-essential \
                                         apt-utils \ 
                                         unzip \
                                         vim \
                                         git \
                                         gfortran \
                                         libgeos-dev \
                                         gdal-bin && \
                                         ldconfig

# Updates and Installs
RUN pip install --upgrade pip
RUN /opt/conda/bin/conda install --yes hdf4 numpy scipy matplotlib basemap \
                                       netcdf4 configobj pillow gdal pyproj ffmpeg

# We need basemap 1.1.0
RUN /opt/conda/bin/conda install --yes --channel conda-forge basemap basemap-data-hires

RUN mkdir /code && cd /code && \
    git clone https://www.github.com/opendrift/opendrift && \ 
    cd opendrift && \
   /opt/conda/bin/python setup.py develop

WORKDIR /code

# Test
# cd /code/opendrift && ./testall
