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
