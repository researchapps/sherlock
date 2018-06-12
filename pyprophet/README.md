# Pyprophet

Here is how I pulled a container with pyprophet installed on my local machine, and then copied it
to Sherlock. Note that this didn't work on Sherlock because of a but we are working on!

```bash

# Pull the pyprophet image
# See here https://hub.docker.com/r/hroest/pyprophet/

$ singularity pull --name pyprophet.simg docker://hroest/pyprophet

# scp to sherlock!
$ scp pyprophet.simg vsochat@login.sherlock.stanford.edu:/scratch/users/vsochat/share/pyprophet.simg

```

Once it's on Sherlock, you would be best off to copy it to your scratch for safekeeping.
You can of course put the image where you like, but the files are large so `$HOME`
is not recommended!

```bash
# make sure images are cached in scratch
export SINGULARITY_CACHEDIR=$SCRATCH/.singularity

cp /scratch/users/vsochat/share/pyprophet.simg $SINGULARITY_CACHEDIR

```

Here is how to load Singularity and interact with the container. Note that the module
that we want (pyprophet) is installed with the python inside the container:

```bash

# Load Singularity 2.5.1
module load singularity

# Shell into the container you copied above
$ singularity shell pyprophet.simg 
Singularity: Invoking an interactive shell within container...

Singularity pyprophet.simg:~> which python
/usr/bin/python
Singularity pyprophet.simg:~> python
Python 2.7.3 (default, Dec 18 2014, 19:10:20) 
[GCC 4.6.3] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import pyprophet
>>> quit()

```

If you run into strange errors, you might have some conflict with modules on your
python path (note that by default your `$HOME` and `$SCRATCH` are mounted to the
container! You can test this by setting the `PYTHONPATH` to be empty when you shell inside,
OR using `--cleanenv`:

```bash

PYTHONPATH= singularity shell pyprophet.simg 
singularity shell --cleanenv pyprophet.simg 

```
