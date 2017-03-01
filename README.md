# Sherlock Singularity

This is a repository for Singularity image build files to help users of Sherlock build [Singularity](http://singularity.lbl.gov). If you are a user and need help, please submit an issue and we will help you build a container! When you are happy with your container, we recommend that you add the `Singularity` file to a new repo, and build automatically with [Singularity Hub](https://singularity-hub.org). Generally, your workflow will look like the following:

 - Ask for help via an [issue](https://www.github.com/researchapps/sherlock/issues) if you don't know how to start
 - Create a build specification file, a text file called Singularity, for your software needs. You can start with another user's as an example.
 - Ask for help with your file! This is what this repo is here for. You can submit issues with questions, and we will discuss and work together on the issues.
 - Test your build locally. 

This usually looks something like the following:


      singularity create --size 4000 mynewimage.img
      singularity bootstrap mynewimage.img Singularity
      

If it has a runscript, you can run as follows:

      singularity run mynewimage.img # or
      ./mynewimage.img


If you are having trouble with the runscript, shell inside like this to look around. The runscript is a file at the base of the image (`/`) called singularity.

     singularity shell mynewimage.img

You can also (on your local machine) use the `--writable` option to test installation of software. You should have your build file open in another window and copy down commands that work, and ensure that the entire build goes successfully from start to finish without an error. Remember, any command that you issue and don't write done is NOT reproducible!

## Singularity Hub

Note to Sherlock users: this functionality is not yet added to Sherlock, but will be available upon the next release of Singularity in March. For now, you can upload images the old school way (FTP). When this is enabled, you will be able to push the build file to Github, and then link your repo to Singularity Hub. Then using the image on sherlock will come down to:

      module load singularity
      singularity run shub://reponame/mynewimage
