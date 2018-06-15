# Dfnworks

This image is provided on Docker Hub as [srcc/dfnworks](https://hub.docker.com/r/srcc/dfnworks/). The first build
was pushed manually, and you can build from this Dockerfile

```
$ docker build -t srcc/dfnworks .
```

## Use on Sherlock

Note that normally you can pull this directly onto Sherlock, but we had problems
with a library so in the meantime I'll show you how I built it locally (and you
can grab the image I then transferred to sherlock). First, here is how to build
locally.

```bash

# Pull the pyprophet image
# See here https://hub.docker.com/r/hroest/pyprophet/

singularity pull --name dfnworks.simg docker://srcc/dfnworks

# scp to sherlock!
$ scp dfnworks.simg vsochat@login.sherlock.stanford.edu:/scratch/users/vsochat/share/dfnworks.simg

```

Once it's on Sherlock, you would be best off to copy it to your scratch for safekeeping.
You can of course put the image where you like, but the files are large so `$HOME`
is not recommended!

```bash
# make sure images are cached in scratch
export SINGULARITY_CACHEDIR=$SCRATCH/.singularity

cp /scratch/users/vsochat/share/dfnworks.simg $SINGULARITY_CACHEDIR

```

Here is how to load Singularity and interact with the container. Note that the module
that we want (pyprophet) is installed with the python inside the container:

```bash

# Load Singularity 2.5.1
module load singularity

# Shell into the container you copied above
$ singularity shell dfnworks.simg 
Singularity: Invoking an interactive shell within container...

Singularity pyprophet.simg:~> which python
/usr/bin/python

 which ipython
/usr/local/bin/ipython
Singularity dfnworks.simg:/scratch/users/vsochat/share> ipython

Singularity pyprophet.simg:~> python
Python 2.7.3 (default, Dec 18 2014, 19:10:20) 
[GCC 4.6.3] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import pydfnworks
>>> quit()
```

If you have conflict with python modules on your host, make sure to unset 
PYTHONPATH and use `--cleanenv` with the container in case there is conflict:

```bash

PYTHONPATH= singularity shell pydfnworks.simg 
singularity shell --cleanenv pydfnworks.simg 

```
