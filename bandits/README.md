# Bandits

This is a Python container with Jupyter, matplotlib, and bandits, intended
to be used with [vsoch/forward](https://www.github.com/vsoch/forward) to run
on the sherlock cluster.

## Build

You can build the container as follows (and update the name if you want to
push to your own Docker Hub account):

```bash
docker build -t vanessa/jupyter-bandits . 
```

And then push to Docker Hub:

```bash
docker push vanessa/jupyter-bandits
```

Then to run with forward:

```bash
$ bash start.sh sherlock/singularity-jupyter /scratch/users/<username> docker://vanessa/jupyter-bandits
```

And make sure to change the container name to the one you've specified.
