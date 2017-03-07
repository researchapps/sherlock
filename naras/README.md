# R with Custom packages

This script shows how to create a Singularity image with custom packages! After you [install Singularity](http://singularity.lbl.gov/install-linux), you will want to build the image locally and then upload to your cluster for using. As of creating this image, R3.3.3 was released today, but the Docker Hub image is updated to 3.3.2. Likely if you build tomorrow or the day after the version will be 3.3.3.

To create your image

     sudo singularity create --size 4000 R.img
     sudo singularity bootstrap R.img Singularity


Then to run R:

    ./R.img

or shell into it to use R/RScript, etc. interactively:


    singularity shell R.img
