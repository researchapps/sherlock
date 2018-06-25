#!/bin/bash
# This script installs dfnWorks, and all dependencies not already installed, on the Sherlock cluster.
# All dependencies are downloaded from sources and compiled. dfnWorks is downloaded, configured, and compiled.
# At the end dfnWorks is tested by running the test.py script.
# 
# Author: Alex Miltenberger, Stanford University, ammilten@stanford.edu
#
# BEGIN INSTALLATION:

# Set current working directory as root for installation
export DFNWORKS=$PWD
echo "All files will be installed in $DFNWORKS"

module load cmake

# ------------------------PETSc--------------------------
if [ ! -d "petsc" ]; then
    echo "PETSC NOT INSTALLED. DOWNLOADING NOW."
    git clone -b maint https://bitbucket.org/petsc/petsc petsc

    echo "PETSC DOWNLOAD COMPLETE. CONFIGURING PETSC."
    cd petsc
    ./configure --download-mpich=yes --download-hdf5=yes --download-fblaslapack=yes --download-metis=yes --download-parmetis=yes --localedir=$DFNWORKS

    export PETSC_DIR=$DFNWORKS/petsc
    export PETSC_ARCH=arch-linux2-c-debug #Not sure what this is, but it comes with petsc

    echo "PETSC CONFIGURATION COMPLETE. COMPILING PETSC."

    #cd $PETSC_DIR
    make all test

    echo "PETSC INSTALLED."
fi

# ------------------------PFLOTRAN------------------------
if [ ! -d "pflotran" ]; then
    echo "PFLOTRAN NOT INSTALLED. DOWNLOADING NOW."
    cd $DFNWORKS

    git clone https://bitbucket.org/pflotran/pflotran
    echo "PFLOTRAN DOWNLOADED. COMPILING PFLOTRAN."

    cd pflotran/src/pflotran
    make pflotran

    echo "PFLOTRAN INSTALLED."
fi

# --------------------------LaGriT------------------------
if [ ! -f "LaGriT.V3.3.Linux" ]; then

    echo "LAGRIT NOT INSTALLED. DOWNLOADING LAGRIT PREBUILT BINARIES."
    cd $DFNWORKS
    wget https://github.com/lanl/LaGriT/releases/download/V3.3/LaGriT.V3.3.Linux
    chmod +x LaGriT.V3.3.Linux

    echo "LAGRIT INSTALLED."
fi

# -------------------------dfnWorks------------------------
# Download
if [ ! -d "dfnWorks-Version2.0" ]; then
    cd $DFNWORKS
    echo "DFNWORKS NOT INSTALLED. DOWNLOADING NOW."
    git clone https://github.com/dfnWorks/dfnWorks-Version2.0

    echo "DFNWORKS DOWNLOADED."
fi

echo "SETTING UP DFNWORKS"

# Fix paths
cd $DFNWORKS/dfnWorks-Version2.0/pydfnworks/bin
python fix_paths.py

# Modify paths.py file as specified in manual
cd $DFNWORKS/dfnWorks-Version2.0/pydfnworks/pydfnworks

sed -i "19s|.*|    os.environ['DFNWORKS_PATH'] = '$DFNWORKS/dfnWorks-Version2.0/'|" paths.py
sed -i "26s|.*|    os.environ['PETSC_DIR'] = '$DFNWORKS/petsc/'|" paths.py
sed -i "27s|.*|    os.environ['PETSC_ARCH'] = 'arch-linux2-c-debug'|" paths.py
sed -i "32s|.*|    os.environ['PFLOTRAN_DIR'] = '$DFNWORKS/pflotran/'|" paths.py
sed -i "36s|.*|    os.environ['python_dfn'] = '/usr/bin/python2.7'|" paths.py
sed -i "41s|.*|    os.environ['lagrit_dfn'] = '$DFNWORKS/LaGriT.V3.3.Linux'|" paths.py

# Add python modules
module load python
pip install --user h5py numpy scipy matplotlib PyVTK

# Make subfolders
echo "COMPILING C_uge_correct."
cd $DFNWORKS/dfnWorks-Version2.0/C_uge_correct
make

echo "COMPILING DFNGEN."
cd $DFNWORKS/dfnWorks-Version2.0/DFNGen
make

echo "COMPILING PARTICLE TRACKING."
cd $DFNWORKS/dfnWorks-Version2.0/ParticleTracking
make

# Run setup script
echo "RUNNING SETUP SCRIPT."
cd $DFNWORKS/dfnWorks-Version2.0/pydfnworks
python setup.py install --user

# Testing
echo "TESTING."
rm -rf ~/test_output_files
cd $DFNWORKS/dfnWorks-Version2.0/pydfnworks/bin
python test.py

