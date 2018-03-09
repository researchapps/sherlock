# pVACseq

[pVAC-Seq](https://github.com/griffithlab/pVAC-Seq) is a genome-guided in 
silico approach to identifying tumor neoantigens. The dependencies are hairy,
so we will install in a container. To run both locally and with Singularity, 
we will start with a Docker base. The dependencies include:

 - [VEP](http://pvactools.readthedocs.io/en/latest/pvacseq/prerequisites.html)
 - [IEDB mhc_i and mhc_II predictors](http://pvactools.readthedocs.io/en/latest/install.html)


## Build
Build the container with Docker:

```
docker build -t vanessa/pvacseq .
```

## Interaction

```
docker run -it vanessa/pvacseq bash
```

**TODO: show using CWL/docker and Singularity**

Thanks Vanessa!

So I want to use pVACseq that is part of pVACtools (and I think that is maintained through pVACtools).

The main problem is installing the other tools it requires - it is a bit surprising given that this are highly useable tools.

Using it requires using:
1. VEP (see http://pvactools.readthedocs.io/en/latest/pvacseq/prerequisites.html). If this won't work maybe I can use the online server of VEP
2. IEDB mhc_i and mhc_ii predictors (see http://pvactools.readthedocs.io/en/latest/install.html). I can not use the online server since I will have to large data. 

For IEDB running the ./config gives test errors in mhc_ii. in mhc_i running the config is fine but running any of the scripts fails

Here is one test they offer - http://pvactools.readthedocs.io/en/latest/pvacseq/getting_started.html

So currently I run 

module load system
module load singularity/2.4
pvactools download_cwls .   (I installed it following pVACtools instructions)

What next?
How do I use pvactools_cwls/pvacseq.cwl? 

Do you have any link that I can read that will make using cwl / docker easier?

Thanks,
Eilon

