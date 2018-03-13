# Python with Custom Packages

This script shows how to create a Singularity image with custom packages! After you [install Singularity](http://singularity.lbl.gov/install-linux), you will want to build the image locally and then upload to your cluster for using. This image contains the following:

 - [https://github.com/ChangLab/FAST-iCLIP](https://github.com/ChangLab/FAST-iCLIP)
 - [https://github.com/tomazc/iCount](https://github.com/tomazc/iCount)


To create your image

     sudo singularity build rflynn.img Singularity


Then to run an executable inside (all located in `/usr/local/bin` you can do any of the following (the last is likely easiest to remember and do):


    singularity exec rflynn.img /usr/local/bin/bowtie2
    singularity exec rflynn.img bowtie2
    ./rflynn.img bowtie2


Take a look at the `%runscript` section of the [Singularity](Singularity) build recipe that determines what happens when the user executes it. It basically executes a command in `/usr/local/bin` or shows the user what is there.

Also look at the `%environment` section - this is where you define variables and paths you want the container to have at runtime.

You can also shell into the image to look around. interactively:

    singularity shell rflynn.img
