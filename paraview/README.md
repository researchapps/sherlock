# A Custom Python Environment with Singularity

This is an example of using a Singularity container to use Paraview, specifically from [this Docker container](https://hub.docker.com/r/openfoam/openfoam4-paraview50/).

## Image Generation
We can pull the image from Docker Hub:

```bash
singularity pull docker://openfoam/openfoam4-paraview50
```

This file is also provided on the Sherlock cluster by @vsoch

```bash
cp /scratch/users/vsoch/share/paraview.simg $SCRATCH
```

Here are the directories created in the image for sherlock, in case you need to bind to share files:

    -/scratch
    -/share/PI
    -/scratch-local


## Using the image

 
      module load singularity
      singularity shell paraview.simg


The paraview executable is located at `/opt/paraviewopenfoam50/bin/paraview` or you can execute a command to it:

      singularity exec paraview.simg ls /


Notice that we are using `exec` to send a command directly to the container.

## Customize the Image

If you need to make changes to the image, on your local machine, [install Singularity](https://singularityware.github.io/install-linux)
and then create a recipe file called `Singularity` with the following content:

```bash
Bootstrap: docker
From: docker://openfoam/openfoam4-paraview50

%environment
   export MYVAR=MYVAL

%post
   echo "Write you changes here!"
```

Then build the image.

```bash
sudo singularity build paraview.simg Singularity
```
