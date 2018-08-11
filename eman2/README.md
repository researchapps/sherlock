# Eman 2 Image

These instructions will pull and run the eman2 image on the Sherlock cluster.

```bash
sdev
module use system
module load system singularity 

export SINGULARITY_CACHEDIR=$SCRATCH/.singularity

# type this command, if this is the first time you use this method
mkdir -p ${SINGULARITY_CACHEDIR}

singularity pull --name eman2.simg shub://ResearchIT/eman2:21a 
# showing message, Done, container is at :/scratch/users/userID/.gingularity/eman2.simg

singularity shell $SINGULARITY_CACHEDIR/eman2.simg 
#showing message, Singularity: Invoking an interactive shell within container...
```

Then you should be able to go to your dataset folder and start e2projectmanager.py

