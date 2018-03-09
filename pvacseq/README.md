# pVACseq

[pVAC-Seq](https://github.com/griffithlab/pVAC-Seq) is a genome-guided in 
silico approach to identifying tumor neoantigens. The dependencies are hairy,
so we will install in a container. To run both locally and with Singularity, 
we will start with a Docker base. The dependencies include:

 - [VEP](http://pvactools.readthedocs.io/en/latest/pvacseq/prerequisites.html)
 - [IEDB mhc_i and mhc_II predictors](http://pvactools.readthedocs.io/en/latest/install.html)


The container is provided on [Docker Hub](https://hub.docker.com/r/vanessa/sherlock/builds/) 
as an automated build so you can use it easily with Docker or Singularity. If you haven'tb
installed either of these and want an overview of usage for sherlock, refer to the global [README](../README.md)
provided in this repository.

## Files Provided
The files here are pretty simple:

 - [Dockerfile](Dockerfile) is the "build recipe" or set of instructions for creating a Docker image. This is the one that is used to automatically build the image on Docker Hub. We will also be pulling the Singularity image from here, so we don't need a separate Singularity build recipe.
 - [pvacseq.scif](pvacseq.scif) is a recipe for a Scientific Filesystem. This is the actual set of commands for the different software inside that we run, and in this file we define different commands to run for installation steps, running application, and defining environments.

## Build
Note that you don't need to build the container on your own, because we have it pre-built on Docker Hub (and it takes forever). If you want to change anything or test and develop, you would need to do this, and you can from the folder here with the Dockerfile as follows:

```
docker build -t vanessa/sherlock:pvacseq .
```

## Interaction
Here we will show quick interaction with the container, using Docker and Singularity. The example we will run
is [here](http://pvactools.readthedocs.io/en/latest/pvacseq/getting_started.html).

### Docker
You can build the container above, or pull the one provided on Docker Hub. To run the example, we have a scif app for it. First, read about the [scientific filesystem](https://sci-f.github.io) if you are interested. Generally, it's a way to create internal modularity in a container by way of creating separate groups (internal modules called "SCIF apps") of environments and entrypoints. To see the apps installed in the container, you can run:


```
docker run vanessa/sherlock:pvacseq apps
       VEP
   pvacseq
   python2
     mhc_i
 pvactools
VEP_plugins
pvacseq-test
    mhc_ii
```

Note that the applications `pvacseq` has its own python 3.6 environment, and we use this environment for `VEP` and  and `pvactools`. 
Since we need a python 2 installation for the older dependencies, the module `python2` serves a virtual environment that was used for 
`mhc_i` and `mhc_ii`. Yes, the dependencies here are a mess and if you are able, I would either encourage the developers to update
the dependencies, or encourage you to use different bases for your work. You can put stinky socks in a container, but they are still stinky socks :)


#### Run the Test Example
Specifically, the `pvacseq-test` application will run [the example here](http://pvactools.readthedocs.io/en/latest/pvacseq/getting_started.html).
To run the example provided in the above (note that the example data and test files are installed in the container under `/scif/data`), with Docker you can do:

```
docker run -it vanessa/sherlock:pvacseq run pvacseq-test
```
```
[pvacseq-test] executing /bin/bash /scif/apps/pvacseq-test/scif/runscript
Executing MHC Class I predictions
Converting .vcf to TSV
Completed
Splitting TSV into smaller chunks
Splitting TSV into smaller chunks - Entries 1-24
Completed
Generating Variant Peptide FASTA and Key Files
Generating Variant Peptide FASTA and Key Files - Entries 1-48
Completed
Processing entries for Allele HLA-E*01:01 and Epitope Length 9 - Entries 1-48
Running IEDB on Allele HLA-E*01:01 and Epitope Length 9 with Method NetMHC - Entries 1-48
Completed
Running IEDB on Allele HLA-E*01:01 and Epitope Length 9 with Method PickPocket - Entries 1-48
Completed
Parsing IEDB Output for Allele HLA-E*01:01 and Epitope Length 9 - Entries 1-48
Completed
Processing entries for Allele HLA-E*01:01 and Epitope Length 10 - Entries 1-48
Running IEDB on Allele HLA-E*01:01 and Epitope Length 10 with Method NetMHC - Entries 1-48
Completed
Running IEDB on Allele HLA-E*01:01 and Epitope Length 10 with Method PickPocket - Entries 1-48
Completed
Parsing IEDB Output for Allele HLA-E*01:01 and Epitope Length 10 - Entries 1-48
Completed
Processing entries for Allele HLA-G*01:09 and Epitope Length 9 - Entries 1-48
Allele HLA-G*01:09 not valid for Method NetMHC. Skipping.
Running IEDB on Allele HLA-G*01:09 and Epitope Length 9 with Method PickPocket - Entries 1-48
Completed
Parsing IEDB Output for Allele HLA-G*01:09 and Epitope Length 9 - Entries 1-48
Completed
Processing entries for Allele HLA-G*01:09 and Epitope Length 10 - Entries 1-48
Allele HLA-G*01:09 not valid for Method NetMHC. Skipping.
Running IEDB on Allele HLA-G*01:09 and Epitope Length 10 with Method PickPocket - Entries 1-48
Completed
Parsing IEDB Output for Allele HLA-G*01:09 and Epitope Length 10 - Entries 1-48
Completed
Combining Parsed IEDB Output Files
Completed
Running Binding Filters
Completed
Running Coverage Filters
Completed
Submitting remaining epitopes to NetChop
Waiting for results from NetChop...OK
Completed
Running NetMHCStabPan
Waiting for results from NetMHCStabPan...OK
Completed

Done: Pipeline finished successfully. File /scif/data/pvacseq/test_output/MHC_Class_I/Test.final.tsv contains list of filtered putative neoantigens.
Executing MHC Class II predictions
Converting .vcf to TSV
Completed
Splitting TSV into smaller chunks
Splitting TSV into smaller chunks - Entries 1-24
Completed
Generating Variant Peptide FASTA and Key Files
Generating Variant Peptide FASTA and Key Files - Entries 1-48
Completed
Processing entries for Allele H2-IAb - Entries 1-48
Running IEDB on Allele H2-IAb with Method NNalign - Entries 1-48
Completed
Parsing IEDB Output for Allele H2-IAb - Entries 1-48
Completed
Combining Parsed IEDB Output Files
Completed
Running Binding Filters
Completed
Running Coverage Filters
Completed
Submitting remaining epitopes to NetChop
Waiting for results from NetChop...OK
Completed

Done: Pipeline finished successfully. File /scif/data/pvacseq/test_output/MHC_Class_II/Test.final.tsv contains list of filtered putative neoantigens.
```

If we didn't add the `-it` (it means interactive terminal) we wouldn't see the output to the screen.

#### Where is my Data?

Notice how the output is referenced inside the container? That sucks. We can generate the output on our host if 
we map the folder referenced (`/scif/data/pvacseq/test_output`) to our local machine. You can do this with The `-v` 
option (meaning volume in Docker) but since this is easier to do with Singularity (and how you will need to do it on
the cluster) we will show how to do it there.


#### Interact with the Software
If you want an interactive shell to have the python environment active to play around, you can do:

```
docker run -it vanessa/sherlock:pvacseq shell pvacseq
[pvacseq] executing /bin/bash 
root@be61d6e684ab:/scif/apps/pvacseq# 
```

Since we are running the container in the context of `pvacseq`, the environment has a bunch of variables for the
scientific filesystem that give hints that it is active. For exanple, `$SCIF_APPDATA` refers to the data root
for `pvacseq`, and `$SCIF_APPROOT` for where things are installed. Here we can find the example data:

```
$ ls $SCIF_APPDATA/example_data/
MHC_Class_I   additional_input_file_list.yaml  indels.bam_readcount  isoforms.fpkm_tracking
MHC_Class_II  genes.fpkm_tracking	       input.vcf	     snvs.bam_readcount
```

Here are the CWL examples:

```
$ ls $SCIF_APPDATA/pvactools_cwls/
pvacfuse.cwl  pvacseq.cwl  pvacvector.cwl
```

You should have the mindset that you are developing a reproducible container to carry forward your work. In the 
same way that you were able to run the test above with one easy command, this is what you would want to provide
to your users! This is the container that you might publish with your paper to reproduce your analayis. This  means that
you might take the following approach:

 - Develop and test interactively on your host (or Sherlock) interactively
 - Write your final set of commands to run an analysis into its own SCIF application (and add to the [pvacseq.scif](pvacseq.scif) file.
 - Build your final container on Docker Hub and give others instructions to pull and run it!

And you shouldn't worry about the steps being hard, you have support and help all along the way. Anything you need help with you can email
Research Computing (@vsoch) or [open an issue](https://www.github.com/researchapps/sherlock/issues).


#### Try out cwl
We have downloaded the cwl examples to `/scif/data/pvacseq` so after you shell in as shown above you can find them:

```
docker run -it vanessa/sherlock:pvacseq shell pvacseq
ls $SCIF_APPDATA
```

### Singularity
Singularity is going to allow us to interact exactly the same, but with an image that we can use on Sherlock!
The biggest difference is that a Singularity image is a read online, single file (a format called squasfs so
it is compressed) that we can physically move around and execute like a script. This first example will show
running the Singularity image on our laptops. We will then move to Sherlock.


### Singularity on Sherlock

```
module load system
module load singularity/2.4
```

**being written**
