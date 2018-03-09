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

Next we will show quick interaction with the container, using Docker and Singularity. The example we will run
is [here](http://pvactools.readthedocs.io/en/latest/pvacseq/getting_started.html).

## Docker Interaction
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


### Run the Test Example
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

### Interact with the Software
If you want an interactive shell to have a general interactive environment active to play around, you can do:

```
docker run -it vanessa/sherlock:pvacseq shell pvacseq
[pvacseq] executing /bin/bash 
root@be61d6e684ab:/scif/apps/pvacseq# 
```

Since we are running the container in the context of `pvacseq`, the environment has a bunch of variables for the
scientific filesystem that give hints that it is active. For exanple, `$SCIF_APPDATA` refers to the data root
for `pvacseq`, and `$SCIF_APPROOT` for where things are installed. Here we can find the example data:

```
$ ls $SCIF_APPDATA
example_data  pvactools_cwls  test_output
```

And peek in...

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

Note that looking at the files, these are intended to be run OUTSIDE the container. You aren't going to be able
to use Singularity with CWL (it doesn't conform to the required specification) so I wouldn't take this approach.

### Run the MHC_I and MHC_II tests
For each, shell in with the correct context, and then issue the test commands.

From outside the container:

```
docker run -it vanessa/sherlock:pvacseq run mhc_i
[mhc_i] executing /bin/bash /scif/apps/mhc_i/scif/runscript
 _______________________________________________________________________________________________________________________
|***********************************************************************************************************************|
| * List all available commands.                                                                                        |
| ./src/predict_binding.py                                                                                              |
|_______________________________________________________________________________________________________________________|
| * List all available MHC-I prediction methods.                                                                        |
| ./src/predict_binding.py method                                                                                       |
|_______________________________________________________________________________________________________________________|
| * List all available (MHC,peptide_length) for a given method.                                                         |
| ./src/predict_binding [method] mhc                                                                                    |
| Example: ./src/predict_binding.py ann mhc                                                                             |
|_______________________________________________________________________________________________________________________|
| * Make predictions given a file containing a list of sequences.                                                       |
| ./src/predict_binding [method] [mhc] [peptide_length] [input_file]                                                    |
| Example: ./src/predict_binding.py ann HLA-A*02:01 9 ./examples/input_sequence.fasta                                   |
|_______________________________________________________________________________________________________________________|
| * Make predictions given a file containing a list of sequences AND user-provided MHC sequence.                        |
| ** Only netmhcpan has this option.                                                                                    |
| ./src/predict_binding [method] -m [input_file_mhc] [peptide_length] [input_file]                                      |
| Example: ./src/predict_binding.py netmhcpan -m ./examples/protein_mhc_B0702.fasta 9 ./examples/input_sequence.fasta   |
|_______________________________________________________________________________________________________________________|
| * You may also redirect (pipe) the input file into the script.                                                        |
| Examples:                                                                                                             |
| echo -e ./examples/input_sequence.fasta | ./src/predict_binding.py ann HLA-A*02:01 9                                  |
| echo -e ./examples/input_sequence.fasta | ./src/predict_binding.py netmhcpan -m ./examples/protein_mhc_B0702.fasta 9  |
|_______________________________________________________________________________________________________________________|
```
```
docker run -it vanessa/sherlock:pvacseq run mhc_ii
[mhc_ii] executing /bin/bash /scif/apps/mhc_ii/scif/runscript
.........
----------------------------------------------------------------------
Ran 9 tests in 8.412s

OK
All prerequisites found!
run MHCII tests...
```

Note that these are general entry points for each of mch_i and mch_ii, and without arguments they run
the default tests. You can also issue custom commands by using `exec` to the same entry point:


```
docker run -it vanessa/sherlock:pvacseq exec mhc_ii ls
[mhc_ii] executing /bin/ls 
Copenhagen_license.txt
IEDB_MHC_II-2.17.3.tar.gz
LIAI_license.txt
README
bin
bio.py
configure.py
lib
logs
methods
mhc_II_binding.py
mhc_II_binding.py.temp
mhcii_predictor.py
netMHCII-1.1.readme
scif
scratch
seqpredictorII.py
test.fasta
```

And here is what the above looks like, for inside the container. This is mhc_i.
Note that you are best off testing interactively and then working on the "from the outside"
commands.

```
docker run -it vanessa/sherlock:pvacseq shell mhc_i
[mhc_i] executing /bin/bash 
root@ce802c0329f8:/scif/apps/mhc_i# source activate /scif/apps/python2
(/scif/apps/python2) root@ce802c0329f8:/scif/apps/mhc_i# python src/predict_binding.py
```

and mhc_ii

```
docker run -it vanessa/sherlock:pvacseq shell mhc_ii
[mhc_ii] executing /bin/bash 
root@22133735d61c:/scif/apps/mhc_ii# source activate /scif/apps/python2
(/scif/apps/python2) root@22133735d61c:/scif/apps/mhc_ii# python configure.py 
All prerequisites found!
run MHCII tests...
.........
----------------------------------------------------------------------
Ran 9 tests in 7.986s

OK
(/scif/apps/python2) root@22133735d61c:/scif/apps/mhc_ii# 
```

Now you are empowered to use these tools for your analysis! You should have the mindset that you are 
developing a reproducible container to carry forward your work. In the 
same way that you were able to run the test above with one easy command, this is what you would want to provide
to your users! This is the container that you might publish with your paper to reproduce your analayis. This  means that
you might take the following approach:

 - Develop and test interactively on your host (or Sherlock) interactively
 - Write your final set of commands to run an analysis into its own SCIF application (and add to the [pvacseq.scif](pvacseq.scif) file.
 - Build your final container on Docker Hub and give others instructions to pull and run it!

And you shouldn't worry about the steps being hard, you have support and help all along the way. Anything you need help with you can email
Research Computing (@vsoch) or [open an issue](https://www.github.com/researchapps/sherlock/issues).


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
