# Using MRTrix with Singularity

This is an example of using a Singularity container to use MRTrix on the Sherlock cluster.

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

Next, we will pull the Docker Image for MRTrix from [Docker Hub](https://hub.docker.com/r/neurology/mrtrix/) directly into a Singularity container.

```bash
$ singularity pull docker://neurology/mrtrix
WARNING: pull for Docker Hub is not guaranteed to produce the
WARNING: same image on repeated pull. Use Singularity Registry
WARNING: (shub://) to pull exactly equivalent images.
Docker image path: index.docker.io/neurology/mrtrix:latest
Cache folder set to /scratch/users/vsochat/.singularity/docker
[8/8] |===================================| 100.0% 
Importing: base Singularity environment
Exploding layer: sha256:5040bd2983909aa8896b9932438c3f1479d25ae837a5f6220242a264d0221f2d.tar.gz
Exploding layer: sha256:57f87117812128cb8e3be67b0f704111dc7a435305333b94b3a0ab759ae610f5.tar.gz
Exploding layer: sha256:d773c42a51ff36435a6b56a7cdcfc413e917130854f7d6c3c291fa9f51310c4e.tar.gz
Exploding layer: sha256:9e0c7182df1359765e9652d3b506646a03584e84f6bc249c4db37ddb83efcba0.tar.gz
Exploding layer: sha256:664aaf79d77cceaa454b26c692d51244677cfbb2bccb9f65df03eddfd2602fa5.tar.gz
Exploding layer: sha256:46c9a3cf133fa42ce4d2acdc18639de8453b4fbbf3a593f80c0458c239c668fc.tar.gz
Exploding layer: sha256:b4fe712c28302ccf48738c7f040d8992360949175bb3ad193df1ad6333d6325b.tar.gz
Exploding layer: sha256:c8d09852d81194d0e6513c8fc0326f52f256e5987a483036605bc9c8800c6fe9.tar.gz
Exploding layer: sha256:159d066557cee8d52d3236faa839627e080319f4af6a30d41b7114016d4a72d7.tar.gz
WARNING: Building container as an unprivileged user. If you run this container as root
WARNING: it may be missing some functionality.
Building Singularity image...
```

## Using the image
Let's shell inside the image to interact with the software!


```bash
$ singularity shell /scratch/users/vsochat/.singularity/mrtrix.simg
Singularity: Invoking an interactive shell within container...

Singularity mrtrix.simg:~> 
```
 
The suite of mrtrix executables is here:

```bash
Singularity mrtrix.simg:/mrtrix> ls /mrtrix/release/bin/
5tt2gmwmi	 dwi2mask	      fod2dec		  mrfilter     sh2response     tckstats
5tt2vis		 dwi2noise	      fod2fixel		  mrinfo       shbasis	       tensor2metric
5ttedit		 dwi2tensor	      label2colour	  mrmath       shconv	       transformcalc
afdconnectivity  dwidenoise	      label2mesh	  mrmesh       shview	       transformconvert
amp2sh		 dwiextract	      labelconvert	  mrmetric     tck2connectome  tsfdivide
connectome2tck	 dwinormalise	      maskfilter	  mrpad        tckconvert      tsfinfo
dcmedit		 fixel2sh	      mesh2pve		  mrregister   tckedit	       tsfmult
dcminfo		 fixel2tsf	      meshconvert	  mrresize     tckgen	       tsfsmooth
dirflip		 fixel2voxel	      meshfilter	  mrstats      tckglobal       tsfthreshold
dirgen		 fixelcalc	      mraverageheader	  mrthreshold  tckinfo	       voxel2fixel
dirmerge	 fixelcfestats	      mrcalc		  mrtransform  tckmap	       warp2metric
dirorder	 fixelcorrespondence  mrcat		  mrview       tcknormalise    warpconvert
dirsplit	 fixellog	      mrcheckerboardmask  peaks2amp    tckresample     warpcorrect
dirstat		 fixelreorient	      mrclusterstats	  sh2amp       tcksample       warpinit
dwi2adc		 fixelstats	      mrconvert		  sh2peaks     tcksift
dwi2fod		 fixelthreshold       mrcrop		  sh2power     tcksift2

exit
```

Your scratch and home will automatically be bound to the container for you to interact with
files. To interact with a tool from the "outside" of the container (without shelling in)
you can use the `exec` command. Note that we have exited from the container above by typing "exit" and
we are again on the interactive node (sh-08-37):

```bash
[vsochat@sh-08-37 ~]$ singularity exec /scratch/users/vsochat/.singularity/mrtrix.simg ls /mrtrix/release/bin
5tt2gmwmi	 dwi2mask	      fod2dec		  mrfilter     sh2response     tckstats
5tt2vis		 dwi2noise	      fod2fixel		  mrinfo       shbasis	       tensor2metric
5ttedit		 dwi2tensor	      label2colour	  mrmath       shconv	       transformcalc
afdconnectivity  dwidenoise	      label2mesh	  mrmesh       shview	       transformconvert
amp2sh		 dwiextract	      labelconvert	  mrmetric     tck2connectome  tsfdivide
connectome2tck	 dwinormalise	      maskfilter	  mrpad        tckconvert      tsfinfo
dcmedit		 fixel2sh	      mesh2pve		  mrregister   tckedit	       tsfmult
dcminfo		 fixel2tsf	      meshconvert	  mrresize     tckgen	       tsfsmooth
dirflip		 fixel2voxel	      meshfilter	  mrstats      tckglobal       tsfthreshold
dirgen		 fixelcalc	      mraverageheader	  mrthreshold  tckinfo	       voxel2fixel
dirmerge	 fixelcfestats	      mrcalc		  mrtransform  tckmap	       warp2metric
dirorder	 fixelcorrespondence  mrcat		  mrview       tcknormalise    warpconvert
dirsplit	 fixellog	      mrcheckerboardmask  peaks2amp    tckresample     warpcorrect
dirstat		 fixelreorient	      mrclusterstats	  sh2amp       tcksample       warpinit
dwi2adc		 fixelstats	      mrconvert		  sh2peaks     tcksift
dwi2fod		 fixelthreshold       mrcrop		  sh2power     tcksift2
```
```bash
[vsochat@sh-08-37 ~]$ singularity exec /scratch/users/vsochat/.singularity/mrtrix.simg mcookie
62cbbe4fdbee3cec48049743aa1299cf
```

Thus, if you want to run a command in a script, you would load the module, and execute commands to the container.

```
module load singularity
singularity exec [container] [commands]
```
