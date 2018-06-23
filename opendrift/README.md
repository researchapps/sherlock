# OpenDrift Singularity

This is an example of using a Singularity container to use OpenDrift on the Sherlock cluster.


## Load Singularity
If you aren't familiar with Singularity, it's a container technology that lets you "bring your own environment." It's akin to packaging software and then being able to run it anywhere that Singularity is installed. You can read more about it [here](https://singularityware.github.io). To get started, you will want to get an interactive node, load the module, and export a cache directory for images.

```bash
$ sdev
$ export SINGULARITY_CACHEDIR=$SCRATCH/.singularity
$ module load singularity
```

Next, we will pull the Docker Image for OpenShift from [Docker Hub](https://hub.docker.com/vanessa/opendrift/) (and note that I'm working on doing a PR to the openshift repository so this is provided by them as well) directly into a Singularity container.

```bash
$ singularity pull --name opendrift.simg docker://vanessa/opendrift
```

## Using the image
Let's shell inside the image to interact with the software! I'm not sure how OpenShift
is used, but I can show you where it is. First, shell inside to explore!


```bash
singularity shell opendrift.simg
python
Python 2.7.15 |Anaconda, Inc.| (default, May  1 2018, 23:32:55) 
[GCC 7.2.0] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import opendrift
>>> quit()
```

To execute a command to the container from the outside (on the host without shelling
inside) you can use exec:


```bash
[vsochat@sh-08-37 ~]$ singularity exec /scratch/users/vsochat/.singularity/openshift.simg python
myscript.py
```

Thus, if you want to use the container in a batch job, you would load the module, and execute commands to the container.

```bash
module load singularity
singularity exec [container] python ...
```
