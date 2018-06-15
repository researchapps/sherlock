FROM ubuntu:16.04

# docker build -t srcc/dfnworks .

# PETSc

ENV PETSC_DIR=/petsc
ENV PETSC_ARCH=arch-linux2-c-debug

RUN apt-get update && apt-get install -y python \
                                         python-dev \ 
                                         python-tk \
                                         build-essential \
                                         wget unzip git \
                                         cmake g++ gfortran
RUN mkdir -p /dfnWorks && \
    git clone -b maint https://bitbucket.org/petsc/petsc && \
    cd petsc && \
    ./configure --download-mpich=yes --prefix=/usr/local --download-hdf5=yes --download-fblaslapack=yes  && \
    make all && \
    make install 

# PFLOTRAN

WORKDIR /
RUN git clone https://bitbucket.org/pflotran/pflotran && \
    cd pflotran/src/pflotran && \
    make pflotran

WORKDIR /
RUN wget https://github.com/lanl/LaGriT/releases/download/V3.3/LaGriT.V3.3.Linux && \
    chmod +x LaGriT.V3.3.Linux

# Setuptools
RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py

# DfnWorks
RUN git clone https://github.com/dfnWorks/dfnWorks-Version2.0 && \
    cd dfnWorks-Version2.0/pydfnworks/bin && python fix_paths.py && \
    cd .. && python setup.py install && pip install ipython && \
    pip install matplotlib
