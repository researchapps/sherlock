# Pytorch Dev

[Pytorch](https://hub.docker.com/r/pytorch/pytorch/tags/) on Docker Hub can be easily used to pull container layers into a Singularity
container on the Sherlock cluster. We do this via a [Docker Container](https://hub.docker.com/r/weatherlab/ncview/) with the [Singularity Software](https://singularityware.github.io).

We will be using the Docker tag `0.4.1-cuda9-cudnn7-devel` to pull a container with pytorch dev that (should be) ready to go with CUDA libraries installed.


## Getting Started 

First, get an interactive node, and load Singularity
```bash
sdev
module load singularity
```

Note that at the writing of this tutorial, Singualarity 2.5.1 is the installed version.
Next, create and export the variable for the `SINGULARITY_CACHEDIR` so pulling Docker layers
doesn't happen in your home (which would fill it up).

```bash
mkdir -p $SCRATCH/.singularity
export SINGULARITY_CACHEDIR=$SCRATCH/.singularity
```

If you want this to be quasi permanent for your user account on Sherlock, you can
add it to your bash profile. 

### Option 1: Use a Provided Container
If you want to skip pulling (and note you should come back to this if you want to, in the future,
pull a container from Docker Hub onto Sherlock yourself!) you can start with the container provided
by @vsoch.


```bash
cp /scratch/users/vsochat/share/ pytorch-0.4.1-cuda9-cudnn7-devel.simg $SCRATCH
```

Then jump down to [Usage](#Usage)

### Option 2: Pull the Container
If you want to try pulling your own container from Docker Hub, just pull it!

```bash
$ singularity pull docker://pytorch/pytorch:0.4.1-cuda9-cudnn7-devel
```

The container is usually pulled to your cache, and you can move around if wanted:

```bash
mv $SCRATCH/.singularity/pytorch-0.4.1-cuda9-cudnn7-devel.simg $PWD
```

## Usage
To run python with pytorch, you can just `exec` the command for python to the container! 
Actually, we can issue any command for the container to run, using the operating system
and software installed inside. Here let's first do `which python3` to see where it is
installed in the container, and then `python3` to run it.

```bash
$ singularity exec pytorch-0.4.1-cuda9-cudnn7-devel.simg which  python3
/opt/conda/bin/python3
[vsochat@sh-08-37 /scratch/users/vsochat/share]$ singularity exec pytorch-0.4.1-cuda9-cudnn7-devel.simg python3
Python 3.6.5 |Anaconda, Inc.| (default, Apr 29 2018, 16:14:56) 
[GCC 7.2.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> 
...
```

And you can import pytorch, of course!

```python
import torch
```

However, to harness the GPU from the host, you will need to shell into the container (or `exec` a command to it) first loading the CUDA library of your choice, and then using the `--nv` flag (nvidia) for singularity.

```bash

# What CUDA libraries are available?
module spider cuda

# Load the latest
module load cuda

# Shell into the container
singularity shell --nv pytorch-0.4.1-cuda9-cudnn7-devel.simg
```

Finally, let's say you wanted to extend the container (customize it in some way).
You could either write a Dockerfile [like this one](https://github.com/pytorch/pytorch/blob/master/docker/pytorch/Dockerfile), create
an automated build on Docker Hub and then pull it with Singularity as we just did, OR you can write a Singularity recipe
that bootstraps the same container (and makes changes to it). The header would look like this:

```bash
From: pytorch/pytorch:0.4.1-cuda9-cudnn7-devel
Bootstrap: docker

%post
   apt-get update && apt-get install -y git ...
   # your commands here!

%environment
    export MYVAR=MYVAL
```

See the Singularity Documentation for more information on writing recipes.

## Custom Container
A user requested a container with the following (additional) modules, which will be available via
the Dockerfile in this folder as `docker://vanessa/pytorch-dev`

```bash
numpy 
random 
skimage 
scipy 
matplotlib 
pickle
```

This is built from the Dockerfile in this repository, pushed to Docker Hub, and then can be pulled
equivalently onto the Sherlock cluster.

```bash
singularity pull docker://vanessa/pytorch-dev
```
