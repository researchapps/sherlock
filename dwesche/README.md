# A Custom Python Environment with Singularity
y
This is an example of using a Singularity container to install python (Anaconda with 2.7). You can customize this base image to add software or additional python modules that you might need

## Image Generation
Generally, you can create the image as follows:

      sudo singularity build anaconda2.img Singularity.dewsche


Or you can create a Github repo with the Singularity file at the base, and connect to [Singularity Hub](https://singularity-hub.org) for it to build for you. Note that this is currently available for Sherlock, because the admins are waiting to update Singularity (with support for the Singularity Hub endpoint) at the next official release, which should be by end of March. Here are the directories created in the image for sherlock, in case you need to bind to share files:

    -/scratch
    -/share/PI
    -/scratch-local


## Using the image
The image can be run like an executable. When you run it, it's going to run what is defined in the `%runscript` section. For our image, this means opening up a python terminal:

 
      ./anaconda2.img
      singularity run anaconda2.img


(The above commands are equivalent). You can also send a custom command to the image like this:


      singularity exec anaconda2.img ls /


Notice that we are using `exec` to send a command directly to the container. 
