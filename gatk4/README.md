# GATK4

[Gatk4](https://software.broadinstitute.org/gatk/gatk4) is open source software for germline and cancer genome analysis. Here is how to use it on the Sherlock
cluster via a [Docker Container](https://hub.docker.com/r/broadinstitute/gatk/) with the [Singularity Software](https://singularityware.github.io).


## Provided on Sherlock
If you don't want to pull the container yourself, you can grab one that is pulled by @vsoch for you:

```bash
module use system
module load singularity
cp /scratch/users/vsochat/share/gatk4.simg $SCRATCH
cd ${SCRATCH}
```

Example commands:

```bash
# Shell into the container
singularity shell gatk4.simg
singularity run gatk4.simg
```

The container's main entrypoint (the runscript) is the same as shell, so running it shells inside. Once 
inside, you can interact with the gatk suite of software:

```bash
$ singularity run gatk4.simg 
(gatk) vsochat@sh-08-37:/scratch/users/vsochat/share$ which gatk
/gatk/gatk
(gatk) vsochat@sh-08-37:/scratch/users/vsochat/share$ exit
exit
```

And if you want to execute a command from the outside? Just use `exec`:

```bash
$ singularity exec gatk4.simg gatk

 Usage template for all tools (uses --spark-runner LOCAL when used with a Spark tool)
    gatk AnyTool toolArgs

 Usage template for Spark tools (will NOT work on non-Spark tools)
    gatk SparkTool toolArgs  [ -- --spark-runner <LOCAL | SPARK | GCS> sparkArgs ]

 Getting help
    gatk --list       Print the list of available tools

    gatk Tool --help  Print help on a particular tool

 Configuration File Specification
     --gatk-config-file                PATH/TO/GATK/PROPERTIES/FILE

 gatk forwards commands to GATK and adds some sugar for submitting spark jobs

   --spark-runner <target>    controls how spark tools are run
     valid targets are:
     LOCAL:      run using the in-memory spark runner
     SPARK:      run using spark-submit on an existing cluster 
                 --spark-master must be specified
                 --spark-submit-command may be specified to control the Spark submit command
                 arguments to spark-submit may optionally be specified after -- 
     GCS:        run using Google cloud dataproc
                 commands after the -- will be passed to dataproc
                 --cluster <your-cluster> must be specified after the --
                 spark properties and some common spark-submit parameters will be translated 
                 to dataproc equivalents

   --dry-run      may be specified to output the generated command line without running it
   --java-options 'OPTION1[ OPTION2=Y ... ]'   optional - pass the given string of options to the 
                 java JVM at runtime.  
                 Java options MUST be passed inside a single string with space-separated values.
```

If you want to pull your own image, or build a custom image then pull and use, keep reading!h

## Pull

First, get an interactive node, and load Singularity
```bash
sdev
module use system
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
add it to your bash profile. Next, pull the container. You can browse [available tags](https://hub.docker.com/r/broadinstitute/gatk/tags) if you have preference, or don't specify a tag to get "latest."

```bash
$ singularity pull --name gatk4.simg docker://broadinstitute/gatk  # implies latest
# or
$ singularity pull --name gatk4-4.0.6.0.simg docker://broadinstitute/gatk:4.0.6.0
```

The container is usually pulled to your cache, and you can move around if wanted:

```bash
mv $SCRATCH/.singularity/gatk4.simg gatk4.simg
```

To run the software, you can just run the container like an executable!

```bash

```

Finally, let's say you wanted to extend the container (customize it in some way).
You could either write a Dockerfile [like this one](https://github.com/broadinstitute/gatk/blob/master/Dockerfile) create
an automated build on Docker Hub and then pull it with Singularity as we just did, OR you can write a Singularity recipe
that bootstraps the same container (and makes changes to it). The header would look like this:

```bash
From: broadinstitute/gatk
Bootstrap: docker

%post
   apt-get update && apt-get install -y git ...
   # your commands here!

%environment
    export MYVAR=MYVAL
```

See the Singularity Documentation for more information on writing recipes.
