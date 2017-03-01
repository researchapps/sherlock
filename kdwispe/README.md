# ASE/GPAW with Python 2

This is an anaconda (python 2.7*) image that is intended to run [ase-anharmonics](https://github.com/keldLundgaard/ase-anharmonics) has installed the following:


      platform        Linux-4.4.0-62-generic-x86_64-with-debian-8.5
      python-2.7.13   /opt/conda/bin/python
      ase-3.13.0      /opt/conda/lib/python2.7/site-packages/ase/
      numpy-1.12.0    /opt/conda/lib/python2.7/site-packages/numpy/
      scipy-0.18.1    /opt/conda/lib/python2.7/site-packages/scipy/
      gpaw

And includes libraries for LAPACK, BLAS, etc (see [Singularity](Singularity) for complete installation steps. We start with a base image that has anaconda (python 2) which means a debian OS. 

## Image Generation
Generally, you can create the image as follows:

      singularity create --size 4000 ase.img
      singularity bootstrap ase.img Singularity


Or you can create a Github repo with the Singularity file at the base, and connect to [Singularity Hub](https://singularity-hub.org) for it to build for you. The installation will install the git repo for ase harmonics, and run tests at the end, and also create directories to be bound on the sherlock cluster:

    -/scratch
    -/share/PI
    -/scratch-local

A demo of the steps to generate the container, and the installation, is [available here]() and the [asciinema file](asciinema-example.json) provided in this folder.

## Runscript

The runscript is what gets executed when you run the container as an executable:

      ./ase.img

and in this case will open up a python interpreter, the one associated with the software installed at `/opt/conda/bin/python`. The core software for ase-anharmonics was downloaded to `/ase-anharmonics`, and this was done primarily to run tests. If you intend to be working (and changing) the files, it is recommended that you work with them from your home folder, and connect to them via the image. Your scratch folders, along with home, should bind automatically, so it would be best to put the software here, and then use the python in the image by calling it as an executable, eg:

    ./ase.img script.py
