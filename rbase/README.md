# R 3.5.0 with Singularity

This is an example of using a Singularity container to use R (current version 3.5.0) on Sherlock.

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

Next, we will pull the Docker Image for R from [Docker Hub](https://hub.docker.com/r/library/r-base/) directly into a Singularity container.

```bash
[vsochat@sh-08-37 ~]$ singularity pull docker://r-base
WARNING: pull for Docker Hub is not guaranteed to produce the
WARNING: same image on repeated pull. Use Singularity Registry
WARNING: (shub://) to pull exactly equivalent images.
Docker image path: index.docker.io/library/r-base:latest
Cache folder set to /scratch/users/vsochat/.singularity/docker
[6/6] |===================================| 100.0% 
Importing: base Singularity environment
Exploding layer: sha256:28507814f909cf603558f5943650d7ce4517b063dc8e427275d5f1aebf5258e6.tar.gz
Exploding layer: sha256:bfdf730ffcf7dfd00b2f55985abf4ba8ca4522b96e616c8bc1e4cfd968d76e3f.tar.gz
Exploding layer: sha256:52f18fc3d95b259481e29adc5aedd47ce10a85e6381f4e9b8bafd3d8b70a5713.tar.gz
Exploding layer: sha256:85dc77cd2b8207645232d185e8c640b76c6385c9806e488b4f011691ef00ee0c.tar.gz
Exploding layer: sha256:ff053bdfbff3a193f819400793024b37a0cb609254d57bd934667732224bc186.tar.gz
Exploding layer: sha256:36cce1b4c79ab0efd9e3a68c3e88431f19147a5f76ba7ef665c706be767a8516.tar.gz
Exploding layer: sha256:55f51bcdcebb509737461e2b9690ed4b1108e27db8273f7c118a79a7b64c434c.tar.gz
WARNING: Building container as an unprivileged user. If you run this container as root
WARNING: it may be missing some functionality.
Building Singularity image...
Singularity container built: /scratch/users/vsochat/.singularity/r-base.simg
Cleaning up...
Done. Container is at: /scratch/users/vsochat/.singularity/r-base.simg
```
 
The container downloaded to my cache, but I moved it to my $SCRATCH/share folder.

```bash
[vsochat@sh-08-37 ~]$ mv /scratch/users/vsochat/.singularity/r-base.simg $SCRATCH/share/rbase-3.5.0.simg
```
This means you can copy the container to use for yourself
```bash
cp /scratch/users/vsochat/share/rbase-3.5.0.simg $SCRATCH
```

## Using the image
Now we can shell inside, and show how to interact with R!

```bash
[vsochat@sh-08-37 ~]$ singularity shell /scratch/users/vsochat/rbase-3.5.0.simg 
Singularity: Invoking an interactive shell within container...

Singularity rbase-3.5.0.simg:~> which R
/usr/bin/R
Singularity rbase-3.5.0.simg:~> R --version
R version 3.5.0 (2018-04-23) -- "Joy in Playing"
Copyright (C) 2018 The R Foundation for Statistical Computing
Platform: x86_64-pc-linux-gnu (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under the terms of the
GNU General Public License versions 2 or 3.
For more information about these matters see
http://www.gnu.org/licenses/.

Singularity rbase-3.5.0.simg:~> 
```

Your scratch and home will automatically be bound to the container for you to interact with
files. To interact with a tool from the "outside" of the container (without shelling in)
you can use the `exec` command. Note that we have exited from the container above by typing "exit" and we are again on the interactive node. Here are examples of things you might want to do...

```bash
singularity exec rbase-3.5.0.simg ls /
        srv  tmp  var
boot  environment  home  lib32	libx32	media	  mnt	oak  proc  run	 scratch  singularity  sys  usr
```

If you run the container, you go right into R:
```bash
$ singularity run rbase-3.5.0.simg 

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
