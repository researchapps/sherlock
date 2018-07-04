# Using Mono with Singularity

This is an example of using a Singularity container to use Mono on the Sherlock cluster.

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

Next, we will pull the Docker Image for Mono from [Docker Hub](https://hub.docker.com/_/mono/) directly into a Singularity container.

```bash
$ singularity pull docker://mono
WARNING: pull for Docker Hub is not guaranteed to produce the
WARNING: same image on repeated pull. Use Singularity Registry
WARNING: (shub://) to pull exactly equivalent images.
Docker image path: index.docker.io/library/mono:latest
Cache folder set to /scratch/users/vsochat/.singularity/docker
[4/4] |===================================| 100.0% 
Importing: base Singularity environment
Exploding layer: sha256:4d0d76e05f3c6caf923a71ca3b3d2cc8c834ca61779ae6b6d83547f3dd814980.tar.gz
Exploding layer: sha256:cfe7e083e5a7dcb0fd535b2e6bca578462b1c882a82e392e6c152af889d05bda.tar.gz
Exploding layer: sha256:b9dc1b98bc283f79f52b654779fa9ad1f659d72332e992e69e0813b6ef598861.tar.gz
Exploding layer: sha256:27b9d4da824d858fe32e011231112dc35c1f6410aac11bb5691a79730e62c436.tar.gz
Exploding layer: sha256:e9464bf7d7c7cc25399d42529966ca05b1d3f894f485c8f7fc4201f164dbbda8.tar.gz
WARNING: Building container as an unprivileged user. If you run this container as root
WARNING: it may be missing some functionality.
Building Singularity image...
```

## Using the image
Let's shell inside the image to interact with the software! I'm not sure how Mono
is used, but I can show you where it is. First, shell inside to explore!


```bash
[vsochat@sh-08-37 ~]$ singularity shell /scratch/users/vsochat/.singularity/mono.simg
Singularity: Invoking an interactive shell within container...
```

Where is mono?
```bash
Singularity mono.simg:~> which mono
/usr/bin/mono
```

Can we run it?

```bash
Singularity mono.simg:~> mono
Usage is: mono [options] program [program-options]

Development:
    --aot[=<options>]      Compiles the assembly to native code
    --debug[=<options>]    Enable debugging support, use --help-debug for details
    --debugger-agent=options Enable the debugger agent
    --profile[=profiler]   Runs in profiling mode with the specified profiler module
    --trace[=EXPR]         Enable tracing, use --help-trace for details
    --jitmap               Output a jit method map to /tmp/perf-PID.map
    --help-devel           Shows more options available to developers

Runtime:
    --config FILE          Loads FILE as the Mono config
    --verbose, -v          Increases the verbosity level
    --help, -h             Show usage information
    --version, -V          Show version information
    --runtime=VERSION      Use the VERSION runtime, instead of autodetecting
    --optimize=OPT         Turns on or off a specific optimization
                           Use --list-opt to get a list of optimizations
    --security[=mode]      Turns on the unsupported security manager (off by default)
                           mode is one of cas, core-clr, verifiable or validil
    --attach=OPTIONS       Pass OPTIONS to the attach agent in the runtime.
                           Currently the only supported option is 'disable'.
    --llvm, --nollvm       Controls whenever the runtime uses LLVM to compile code.
    --gc=[sgen,boehm]      Select SGen or Boehm GC (runs mono or mono-sgen)
    --handlers             Install custom handlers, use --help-handlers for details.
    --aot-path=PATH        List of additional directories to search for AOT images.

```
 
Since mono is on the path, this means that we can use the `exec` command provided by Singularity
to execute a command to the container. First exit from the container.


```bash
exit
```

```bash
[vsochat@sh-08-37 ~]$ singularity exec /scratch/users/vsochat/.singularity/mono.simg which mono
/usr/bin/mono
```

Thus, if you want to use mono in the container in a batch job, you would load the module, and execute commands to the container.

```bash
module load singularity
singularity exec [container] mono ...
```

## Mono with MSAmanda
Per user request, I've build a custom container with the included [Dockerfile](Dockerfile) to install
[MSAmanda](http://ms.imp.ac.at/?goto=msamanda) that can be used with Mono. You can run this container directly from
Docker Hub, both using Docker (on your local machine) or Singularity (on a shared cluster resource). The entrypoint
to the container is equivalent, and running the container shows the usage:

```bash
$ docker run -it vanessa/mono
MS Amanda Stand-Alone version 2.0.0.11219
Old Usage: MSAmanda.exe spectrumFile proteinDatabase settings.xml [fileformat] [outputfilename]
New Usage: MSAmanda.exe -s spectrumFile -d proteinDatabase -e settings.xml [-f fileformat] [-o outputfilename]
Required: -s spectrumFile     single .mgf or .mzml file, or folder with multiple .mgf and .mzml files
Required: -d proteinDatabase  single .fasta file or folder with multiple .fasta files, which will be combined into one
Required: -e settings.xml
Optional: -f fileformat       choose 1 for .csv and 2 for .mzid, default value is 1
Optional: -o outputfilename   file or folder where the output should be saved, default path is location of spectrum file
```

Or Singularity

```bash
singularity pull docker://vanessa/mono
```
