FROM ubuntu:16.04

# docker build -t srcc/dfnworks .

# Container installs dfnWorks, dependencies, intended for use on Sherlock
# Author: Alex Miltenberger, Stanford University, ammilten@stanford.edu

MAINTAINER vsochat@stanford.edu

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y python \
                                         python-dev \ 
                                         python-tk \
                                         build-essential \
                                         wget unzip git \
                                         cmake g++ gfortran



# ------------------------PETSc--------------------------
ENV DFNWORKS /
ENV PETSC_DIR $DFNWORKS/petsc
ENV PETSC_ARCH arch-linux2-c-debug

RUN mkdir -p petsc && \
    git clone -b maint https://bitbucket.org/petsc/petsc petsc && \
    echo "PETSC DOWNLOAD COMPLETE. CONFIGURING PETSC." && \
    cd petsc && \
    ./configure --download-mpich=yes --download-hdf5=yes --download-fblaslapack=yes --download-metis=yes --download-parmetis=yes --localedir=$DFNWORKS && \
    make all test

# ------------------------PFLOTRAN------------------------

RUN mkdir -p pflotran && \
    cd $DFNWORKS && \
    git clone https://bitbucket.org/pflotran/pflotran && \
    echo "PFLOTRAN DOWNLOADED. COMPILING PFLOTRAN." && \
    cd pflotran/src/pflotran &&\
    make pflotran

# --------------------------LaGriT------------------------
RUN cd $DFNWORKS && \
    wget https://github.com/lanl/LaGriT/releases/download/V3.3/LaGriT.V3.3.Linux && \
    chmod +x LaGriT.V3.3.Linux

# -------------------------dfnWorks------------------------

RUN cd $DFNWORKS && \
    git clone https://github.com/dfnWorks/dfnWorks-Version2.0 && \
    cd dfnWorks-Version2.0/pydfnworks/bin && \
    python fix_paths.py

# Modify paths.py file as specified in manual
RUN cd $DFNWORKS/dfnWorks-Version2.0/pydfnworks/pydfnworks && ls && \
    sed -i "19s|.*|    os.environ['DFNWORKS_PATH'] = '$DFNWORKS/dfnWorks-Version2.0/'|" paths.py && \
    sed -i "26s|.*|    os.environ['PETSC_DIR'] = '$DFNWORKS/petsc/'|" paths.py && \
    sed -i "27s|.*|    os.environ['PETSC_ARCH'] = 'arch-linux2-c-debug'|" paths.py && \
    sed -i "32s|.*|    os.environ['PFLOTRAN_DIR'] = '$DFNWORKS/pflotran/'|" paths.py && \
    sed -i "36s|.*|    os.environ['python_dfn'] = '/usr/bin/python2.7'|" paths.py && \
    sed -i "41s|.*|    os.environ['lagrit_dfn'] = '$DFNWORKS/LaGriT.V3.3.Linux'|" paths.py

# -------------------------Python------------------------

RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    pip install --user h5py numpy scipy matplotlib PyVTK


RUN cd $DFNWORKS/dfnWorks-Version2.0/C_uge_correct && make && \
    cd $DFNWORKS/dfnWorks-Version2.0/DFNGen && make && \
    cd $DFNWORKS/dfnWorks-Version2.0/ParticleTracking && make && \
    cd $DFNWORKS/dfnWorks-Version2.0/pydfnworks && \
    python setup.py install --user

RUN cd $DFNWORKS/dfnWorks-Version2.0/pydfnworks/bin && python test.py
