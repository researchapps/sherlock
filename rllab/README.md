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

## Testing with Exo

### Step 1. Build an updated container

The [Dockerfile](Dockerfile) here is from [the main repo](https://github.com/rll/rllab/blob/master/docker/Dockerfile) and is [built here](https://hub.docker.com/r/dementrock/rllab3-shared/)
on Dockerhub.  Here is how I built it, and then pulled to my local machine (and transferred to Sherlock):

```bash
$ docker build -t vanessa/rllab .
$ docker push vanessa/rllab
```

Then pull into Singularity container


```bash
singularity pull docker://vanessa/rllab
```

Then transfer to Sherlock

```bash
scp rllab.simg vsochat@login.sherlock.stanford.edu:/scratch/users/vsochat/share/rllab.simg
```

Then log into sherlock and get an interactive node.

```bash
sdev
cd $SCRATCH
git clone https://github.com/ngeley/Exo-tmp
cd Exo-temp
$ echo $PYTHONPATH

```
Note that `PYTHONPATH` outside the container is unset. The python on my path is also
the standard, vanilla system python

```bash
$ which python
/usr/bin/python
```

### Step 2. Debug the issue

Let's shell into the container
(this might be somewhere else on your `SCRATCH`.

```bash
# Note that their pythonpath just has the rllab root
$ singularity shell /scratch/users/vsochat/share/rllab.simg 
Singularity: Invoking an interactive shell within container...

# Python is now in container
Singularity rllab.simg:/scratch/users/vsochat/Exo-tmp> which python
/opt/conda/envs/rllab3/bin/python

# And on python path
Singularity rllab.simg:/scratch/users/vsochat/Exo-tmp> echo $PYTHONPATH
/opt/code/rllab:
```

```bash
# Note that we have the Exo repo still here in the $PWD
Singularity rllab.simg:/scratch/users/vsochat/Exo-tmp> ls
50k-seed42-newparams.txt  50k-seed46.txt	     Singularity.rllab	       constants.py	      learn_params.py	  simulator.py
50k-seed43-newparams.txt  CMAvsTRPO.png		     TRPO_eley.png	       create_python_data.py  matlab_utils.py	  source_setup.py
50k-seed44-newparams.txt  Exoskeleton progress.docx  TRPO_mo.png	       evaluate.py	      plot_50ks.py	  training-data-1.pkl
50k-seed45-newparams.txt  Exoskeleton progress.pdf   __pycache__	       exo_env.py	      simulate.py	  trpo_exo.py
50k-seed46-newparams.txt  README.md		     aal5054_Zhang_SM_data_S1  fit_torques.m	      simulate_states.py  util.py
```

and that in /opt/code/rllab we have the rllab repo (where we installed from)

```bash
ls /opt/code/rllab
CHANGELOG.md  README.md  circle.yml  dist    docs	      examples	rllab.egg-info	scripts   tests
LICENSE       build	 contrib     docker  environment.yml  rllab	sandbox		setup.py  vendor
```

Now let's do the call that had an error:

```bash
/opt/conda/envs/rllab3/bin/python trpo_exo.py -s 42 -t 50000 -l 
[cli_0]: write_line error; fd=10 buf=:cmd=init pmi_version=1 pmi_subversion=1
:
system msg for write_line failure : Bad file descriptor
[cli_0]: Unable to write to PMI_fd
[cli_0]: write_line error; fd=10 buf=:cmd=get_appnum
:
system msg for write_line failure : Bad file descriptor
Fatal error in PMPI_Init_thread: Other MPI error, error stack:
MPIR_Init_thread(392): 
MPID_Init(107).......: channel initialization failed
MPID_Init(389).......: PMI_Get_appnum returned -1
```

Reproduced the error! Doing some debugging, we get this error with just about any
algorithm import from rllab. I decided to look into one, and here is the trace of imports:

```python
--> from rllab.algos.trpo import TRPO
--> from rllab.algos.npo import NPO
--> from rllab.algos.batch_polopt import BatchPolopt
--> from rllab.sampler.base import BaseSampler
--> from rllab.misc import special
```
ahh and here is the bugger:

```python
import theano.tensor.nnet
```

### Step 3. Isolate and address the error

I looked into the Theano source code, and realized there are these `PMI_*`
variables that can be set for MPI (which I saw when I first saw the error):

```bash
Singularity rllab.simg:/scratch/users/vsochat/Exo-tmp> env | grep PMI
PMI_SIZE=1
PMI_RANK=0
PMI_JOBID=23434976.0
PMI_FD=10
```

Let's disable them :)

```bash
unset PMI_FD PMI_SIZE PMI_RANK PMI_JOBID
```

### Step 4. Try, try Again!


```bash
/opt/conda/envs/rllab3/bin/python trpo_exo.py -s 42 -t 50000 -l 
ERROR (theano.sandbox.cuda): nvcc compiler not found on $PATH. Check your nvcc installation and try again.
Fontconfig warning: ignoring C.UTF-8: not a valid language tag
/opt/conda/envs/rllab3/lib/python3.5/site-packages/theano/tensor/signal/downsample.py:6: UserWarning: downsample module has been moved to the theano.tensor.signal.pool module.
  "downsample module has been moved to the theano.tensor.signal.pool module.")
using seed 42
2018-08-11 02:01:33.186289 UTC | Populating workers...
2018-08-11 02:01:33.186711 UTC | Populated
0% [##############################] 100% | ETA: 00:00:00
Total time elapsed: 00:00:00
2018-08-11 02:01:33.320479 UTC | itr #0 | fitting baseline...
2018-08-11 02:01:33.372817 UTC | itr #0 | fitted
=: Compiling function f_loss
done in 10.502 seconds
=: Compiling function constraint
done in 2.548 seconds
2018-08-11 02:01:46.432174 UTC | itr #0 | computing loss before
2018-08-11 02:01:46.432794 UTC | itr #0 | performing update
2018-08-11 02:01:46.432989 UTC | itr #0 | computing descent direction
=: Compiling function f_grad
...
```
It ran a hugely long thing after that :) 

We didn't load with CUDA, but it's working! Let's leave the container, load cuda,
and try this bit again. Note that I'm exiting the container AND the sdev node (because 
I want a gpu)

### Step 5. Cuda' done it with Cuda!

**important** you will likely need to also load cudan, when I loaded cudan and cuda I was able to detect GPU, BUT
the library errored out and said I needed to update theano. SO your task is to figure out the right version of theano
and cuda. I can then update the container, and I think we should also ask the maintainer WHY the older versions are
used. Then when we have an answer to this question and a good version of theano to install, we can try try again.
I'll put my (failed) effort here to get us started.

```bash
# Note I am asking for gpu
srun --partition gpu --gres gpu:1 --pty bash

# Go to Exo folder again, with our script
$ cd $SCRATCH/Exo-tmp

# load cuda, etc
$ module use system
$ module load singularity
$ module load cudnn
$ module load cuda

# unset MPI junk
unset PMI_FD PMI_SIZE PMI_RANK PMI_JOBID
```
Ok this is ugly, we need to bind the libraries that we need to the container.

```bash
# shell into the container WITH --nv flag for nvidia
$ singularity shell --nv --bind /usr/lib64/nvidia --bind /opt/dell --bind /share/software:/opt/software /scratch/users/vsochat/share/rllab.simg 
Singularity: Invoking an interactive shell within container...

Singularity rllab.simg:/scratch/users/vsochat/Exo-tmp> 
```
And now we need to export the `LD_LIBRARY_PATH` and `PATH` that correspond:

```bash
export PATH=/usr/lib64/nvidia:/opt/software/user/open/cuda/9.0.176/bin:/opt/software/user/open/cuda/9.0.176/nvvm/bin:/opt/software/user/open/singularity/2.5.2/bin:/opt/software/user/open/libarchive/3.3.2/bin:/opt/software/user/open/xz/5.2.3/bin:/opt/software/user/srcc/bin:$PATH
export LD_LIBRARY_PATH=/usr/lib64/nvidia:/opt/software/user/open/cuda/9.0.176/lib64:/opt/software/user/open/cuda/9.0.176/nvvm/lib64:/opt/software/user/open/cuda/9.0.176/extras/Debugger/lib64:/opt/software/user/open/cuda/9.0.176/extras/CUPTI/lib64:/opt/software/user/open/singularity/2.5.2/lib:/opt/software/user/open/libarchive/3.3.2/lib:/opt/software/user/open/xz/5.2.3/lib:/opt/software/user/open/zlib/1.2.11/lib:$LD_LIBRARY_PATH
```

Sanity check we still have the right python?

```bash
Singularity rllab.simg:/scratch/users/vsochat/Exo-tmp> which python
/opt/conda/envs/rllab3/bin/python
```

To summarize, above we just:

 - got a gpu node
 - changed directory to the Exo-tmp so we have our script
 - loaded the cuda module
 - shelled into the container with `--nv` and the libraries we loaded bound to the container
 - exported the `LD_LIBRARY_PATH` and `PATH` variable to be found!

Now let's run our script.

```bash
/opt/conda/envs/rllab3/bin/python trpo_exo.py -s 42 -t 50000 -l 
```

This (unfortunately) just hangs, and using an older cuda (or not using cudnn) spits out an error
that the version is too new (even with the older). I've opened an issue [here](https://github.com/rll/rllab/issues/244)
to discuss with the maintainer.

