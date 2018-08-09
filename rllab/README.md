# Rllab: Custom Python Environment with Singularity

This is an example of using a Singularity container to install python.
You can customize this base image to add software or additional python modules that you might need.

## Build the Image

The image is built from the Singularity file in this repository, and it must be done on your host
where you have sudo, and then transferred to the cluster environment. 
You can build the container locally on your machine and transfer it to sherlock, (or) you can 
use a container already provided. Read ahead, brave pythonista!


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
cp /scratch/users/vsochat/share/rllab.simg $SCRATCH
```

### Option 2: Bulid It
You can also customize the commands in the [Singularity recipe](Singularity.rllab)
and then build the image on your local machine, and transfer it to sherlock.
It might look something like this:

```bash
# on your local machine where you have sudo
$ sudo singularity build rllab.simg Singularity.rllab

# transfer "rllab.simg" to the scratch folder of <username>
$ scp rllab.simg <username>@login.sherlock.stanford.edu:/scratch/users/<username>/rllab.simg
```

## Usage
The container's entrypoint is python 2, so if you run it, you will get a python 2 shell!

```bash
$ singularity run rllab.simg 
Python 2.7.6 (default, Nov 23 2017, 15:49:48) 
[GCC 4.8.4] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> quit()
```

Here is how to execute a command to it (any command!) For example, to list files at the root (/)

```bash
$ singularity exec rllab.simg ls /
anaconda2  environment	lib64	  mnt  proc  scratch	  sys
bin	   etc		lscratch  net  root  share	  tmp
boot	   home		media	  oak  run   singularity  usr
dev	   lib		misc	  opt  sbin  srv	  var
```

You'll notice in the above that the /scratch (and other sherlock directories)
are automatically bound in the contianer, cool!
And here is another option, shell into the container (to get bash first) and then
interact with python.

```bash
$ singularity shell rllab.simg 
Singularity: Invoking an interactive shell within container...

Singularity rllab.simg:/scratch/users/vsochat/share> which python
/usr/bin/python
```

If you need any kind of GPU, aside from being on a GPU node, made sure to add the `--nv` flag to your
singularity <action> command, and to load the cuda module too.

```bash
# What CUDA libraries are available?
module spider cuda

# Load the latest
module load cuda

# Shell into the container
singularity shell --nv rllab.simg
```

If you have any questions, please reach out to @vsoch by posting an issue on the issue board!
