# Using PyNio with Singularity

This is an example of using a Singularity container to use PyNio on the Sherlock cluster.

## Load Singularity
If you aren't familiar with Singularity, it's a container technology that lets you "bring your own
environment." It's akin to packaging software and then being able to run it anywhere that Singularity
is installed. You can read more about it [here](https://singularityware.github.io). To get started,
you will want to get an interactive node, load the module, and export a cache directory for images.

```bash
$ sdev
$ export SINGULARITY_CACHEDIR=$SCRATCH/.singularity
$ module load singularity
```

Next, we will build the Singularity container from a recipe (note that I did this locally, you can't do it on sherlock). The Singularity recipe is with this readme, the file [Singularity](Singularity).

```bash
$ sudo singularity build pynio.simg Singularity
```

## Using the image
Let's shell inside the image to interact with the software!


```bash
$ singularity shell /scratch/users/vsochat/.singularity/pynio.simg
Singularity: Invoking an interactive shell within container...

Singularity pynio.simg:~/Documents/sherlock/pynio> which python
/opt/conda/envs/pynio_env/bin/python
Singularity pynio.simg:~/Documents/sherlock/pynio> python
Python 2.7.15 | packaged by conda-forge | (default, May  8 2018, 14:46:53) 
[GCC 4.8.2 20140120 (Red Hat 4.8.2-15)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import nio
>>> 
```

Your scratch and home will automatically be bound to the container for you to interact with
files. To interact with a tool from the "outside" of the container (without shelling in)
you can use the `exec` command. Note that we have exited from the container above by typing "exit" and
we are again on the interactive node (sh-08-37):

```bash
[vsochat@sh-08-37 ~]$ singularity exec /scratch/users/vsochat/.singularity/pynio.simg which python
/opt/conda/envs/pynio_env/bin/python
```

Thus, if you want to run a command in a script, you would load the module, and execute commands to the container.

```
module load singularity
singularity exec [container] [commands]
```
