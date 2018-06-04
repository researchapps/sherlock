# NCview

[Ncview](http://meteora.ucsd.edu/~pierce/ncview_home_page.html) is visualization software for oceanography, and helps with loading a specific kind of file called [netCDF](https://en.wikipedia.org/wiki/NetCDF). Here is how to use it on the Sherlock
cluster via a [Docker Container](https://hub.docker.com/r/weatherlab/ncview/) with the [Singularity Software](https://singularityware.github.io).

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
add it to your bash profile. Next, pull the container.

```bash
$ singularity pull --name ncview.simg docker://weatherlab/ncview
```

The container is usually pulled to your cache, and you can move around if wanted:

```bash
mv $SCRATCH/.singularity/ncview.simg ncview.simg
```

To run ncview, you can just run the container like an executable! Importantly, since the container
wants to write a config file to `/home/ncview` you should bind your home there so it doesn't error.

```bash
singularity run --bind $HOME:/home/ncview ncview.simg 
Ncview 2.1.7 David W. Pierce  29 March 2016
http://meteora.ucsd.edu:80/~pierce/ncview_home_page.html
Copyright (C) 1993 through 2015, David W. Pierce
Ncview comes with ABSOLUTELY NO WARRANTY; for details type `ncview -w'.
...
```

Finally, let's say you wanted to extend the container (customize it in some way).
You could either write a Dockerfile [like this one](https://hub.docker.com/r/weatherlab/ncview/~/dockerfile/), create
an automated build on Docker Hub and then pull it with Singularity as we just did, OR you can write a Singularity recipe
that bootstraps the same container (and makes changes to it). The header would look like this:

```bash
From: weatherlab/ncview
Bootstrap: docker

%post
   apt-get update && apt-get install -y git ...
   # your commands here!

%environment
    export MYVAR=MYVAL
```

See the Singularity Documentation for more information on writing recipes.


# NCO

The NetCDF operators are also available in several containers, [here is an example](https://github.com/lloydcotten/docker-mettools) that I found.

```bash
$ singularity pull --name nco.simg docker://lloydcotten/mettools:v1
```

For this container you likely want to use the tools interactively, so you can use Singularity shell.

```bash
singularity shell nco.simg
```

It looks like these locations have files of interest!

```bash
Singularity nco.simg:~> ls /usr/local/bin/
cnvgrib  imgcmp  imginfo  jasper  libpng-config  libpng12-config  tmrdemo  wgrib2
```
```bash
ls /usr/bin/nc
ncap              ncbo              ncecat            ncks              ncrcat            ncursesw5-config  
ncap2             ncdiff            nces              ncpdq             ncrename          ncwa              
ncatted           ncea              ncflint           ncra              ncurses5-config   
```
