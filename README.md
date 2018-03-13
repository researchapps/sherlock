# Sherlock

[![https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg](https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg)](https://singularity-hub.org/collections/726)

This is a repository for container build files to help users of Sherlock. If you are a user and need help, please submit an issue and we will help you build a container! When you are happy with your container, we recommend that you add the `Singularity` or `Dockerfile` file to a new repo, and build automatically with [Singularity Hub](https://singularity-hub.org) or [Docker Hub](https://hub.docker.com/). Generally, your workflow will look like the following:

 - Install Singularity and/or Docker to work locally
 - Ask for help via an [issue](https://www.github.com/researchapps/sherlock/issues) if you don't know how to start
 - Create a build specification file, a text file called Singularity, for your software needs. You can start with another user's as an example. You can also start with a Dockerfile, and then pull it to a Singularity image from Docker Hub.
 - Ask for help with your file! This is what this repo is here for. You can submit issues with questions, and we will discuss and work together on the issues.
 - Test your build locally. 

## Installation
You should first [install Singularity](https://singularityware.github.io/install-linux) and [Docker](https://docs.docker.com/install/) so that you can build images on your host. If you use a Mac, you will need to install Singularity in a virtual machine like Vagrant. Singularity is going to allow us to interact exactly the same, but with an image that we can use on Sherlock! The biggest difference is that a Singularity image is a read online, single file (a format called squasfs so
it is compressed) that we can physically move around and execute like a script.


## General Usage
On your local machine, building usually looks something like the following:


      sudo singularity build mynewimage.img Singularity
      

If it has a runscript, you can run as follows:

      singularity run mynewimage.img # or
      ./mynewimage.img


If you are having trouble with the runscript, shell inside like this to look around. The runscript is a file at the base of the image (`/`) called singularity.

     singularity shell mynewimage.img

You can also (on your local machine) use the `--writable` option to test installation of software. You should have your build file open in another window and copy down commands that work, and ensure that the entire build goes successfully from start to finish without an error. Remember, any command that you issue and don't write done is NOT reproducible!

## Singularity Hub

Note to Sherlock users: this functionality is not yet added to Sherlock, but will be available upon the next release of Singularity in March. For now, you can upload images the old school way (FTP). When this is enabled, you will be able to push the build file to Github, and then link your repo to Singularity Hub. Then using the image on sherlock will come down to:

      module load system
      module load singularity/2.4
      singularity run shub://reponame/mynewimage
