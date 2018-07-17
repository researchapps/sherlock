# Seurat and Singularity

This is an example of using a Singularity container to use R with the Seurat library (current version 3.5.0 of R) on Sherlock. We do this by building a Docker container, and building a Singularity container from it.

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

## Pull Container

> Note that Vanessa (@vsoch) has done this for you, so you don't need to do the pull itself, but can just copy the image from her scratch! This is shown for your FYI so you can do it in the future, with any Docker container. 

I've prepared two different versions for you - one with an rstudio base, and the other just R:

```bash
cp /scratch/users/vsochat/share/seurat.simg $SCRATCH
cp /scratch/users/vsochat/share/rstudio-seurat.simg
```

This is how Vanessa built the Docker Image for R from [Docker Hub](https://hub.docker.com/r/library/vanessa/seurat/) directly into a Singularity container. The Dockerfile (recipe) for the container is included here ([Dockerfile](Dockerfile)).

```bash
singularity pull docker://vanessa/seurat
singularity pull docker://marcusczi/rstudio-seurat
```
 
The containers downloaded to my cache, but I moved them to my $SCRATCH/share folder.

```bash
mv /scratch/users/vsochat/.singularity/seurat.simg $SCRATCH/share/seurat.simg
mv /scratch/users/vsochat/.singularity/rstudio-seurat.simg $SCRATCH/share/rstudio-seurat.simg
```

This means you can copy the containers to use for yourself

```bash
cp /scratch/users/vsochat/share/seurat.simg $SCRATCH
cp /scratch/users/vsochat/share/rstudio-seurat.simg $SCRATCH
```

## Using the image
For these examples I'll show using one image, and you can choose to use one or both. Now we can shell inside, and show how to interact with R!

```bash
[vsochat@sh-08-37 ~]$ singularity shell seurat.simg 
Singularity: Invoking an interactive shell within container...

Singularity seurat.simg:~> which R
/usr/bin/R
Singularity seurat.simg:~> R --version
R version 3.5.0 (2018-04-23) -- "Joy in Playing"
Copyright (C) 2018 The R Foundation for Statistical Computing
Platform: x86_64-pc-linux-gnu (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under the terms of the
GNU General Public License versions 2 or 3.
For more information about these matters see
http://www.gnu.org/licenses/.

Singularity seurat.simg:~> 
```

Your scratch and home will automatically be bound to the container for you to interact with
files. To interact with a tool from the "outside" of the container (without shelling in)
you can use the `exec` command. Note that we have exited from the container above by typing "exit" and we are again on the interactive node. Here are examples of things you might want to do...

```bash
singularity exec seurat.simg ls /
        srv  tmp  var
boot  environment  home  lib32	libx32	media	  mnt	oak  proc  run	 scratch  singularity  sys  usr
```

If you run the container, you go right into R:
```bash
$ singularity run seurat.simg 

R version 3.5.0 (2018-04-23) -- "Joy in Playing"
Copyright (C) 2018 The R Foundation for Statistical Computing
Platform: x86_64-pc-linux-gnu (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

  Natural language support but running in an English locale

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

> 
```

Thus, if you want to run a command in a script, you would load the module, and execute commands to the container.

```
module load singularity
singularity exec [container] [commands]
```

If you are on the Sherlock cluster at Stanford. you can either copy the image I've pulled, or pull your own directly. if you want to customize the image, you will need to learn about
[building a container](https://www.sylabs.io/guides/2.5.1/user-guide/build_a_container.html), which can only be done on your host.
