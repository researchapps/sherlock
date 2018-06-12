# Freesurfer

Here is how I pulled the freesurfer image on my local machine, and then copied it
to Sherlock. Note that this didn't work on Sherlock because of a version of the xz
library that was too new.

```bash

# Pull the vistalab freesurfer image
# See here https://hub.docker.com/r/vistalab/freesurfer/ to confirm v.5.3.0
singularity pull --name freesurfer.simg docker://vistalab/freesurfer

# scp to Sherlock
scp freesurfer.simg vsochat@login.sherlock.stanford.edu:/scratch/users/vsochat/share/freesurfer.simg

```

Once it's on Sherlock, you would be best off to copy it to your scratch for safekeeping.
You can of course put the image where you like, but the files are large so `$HOME`
is not recommended!

```bash
# make sure images are cached in scratch
export SINGULARITY_CACHEDIR=$SCRATCH/.singularity

cp /scratch/users/vsochat/share/freesurfer.simg $SINGULARITY_CACHEDIR

```

Here is how to load Singularity and interact with the container. Note that the software
we want (tkregister2) is inside the container:

```bash

# Load Singularity 2.5.1
module load singularity

# Copy the container from the shared folder
$ singularity shell freesurfer.simg 
Singularity: Invoking an interactive shell within container...

Singularity freesurfer.simg:~> which tkregister2
/opt/freesurfer/bin/tkregister2
Singularity freesurfer.simg:~> 

```
