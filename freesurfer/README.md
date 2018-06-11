# Freesurfer

Here is how to run freesurfer (version 5.3.0) on Sherlock using Singularity.

```bash
# make sure images are cached in scratch
export SINGULARITY_CACHEDIR=$SCRATCH/.singularity

# Load Singularity 2.5.1
module load singularity

# Pull the vistalab freesurfer image
# See here https://hub.docker.com/r/vistalab/freesurfer/ to confirm v.5.3.0
singularity pull --name freesurfer.simg docker://vistalab/freesurfer

```
