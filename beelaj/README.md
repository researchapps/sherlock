# Compiling C with Special Libs using Singularity

This is an example of how we can use a Singularity container to compile software with some special set of libraries that our cluster has wrong versions of, or doesn't let us install. Note that these first steps should be done on your local machine, and when the image is done (after create and bootstrap) it can be uploaded and used on Sherlock to compile on the fly. A complete asciinema example of the below is also [available for viewing](https://asciinema.org/a/105877?speed=3).

## Image Generation
Generally, you can create the image as follows:

      sudo singularity create --size 2000 peanuts.img
      sudo singularity bootstrap peanuts.img Singularity


Or you can create a Github repo with the Singularity file at the base, and connect to [Singularity Hub](https://singularity-hub.org) for it to build for you. Note that this is currently available for Sherlock, because the admins are waiting to update Singularity (with support for the Singularity Hub endpoint) at the next official release, which should be by end of March. Here are the directories created in the image for sherlock, in case you need to bind to share files:

    -/scratch
    -/share/PI
    -/scratch-local


## Using the image
The image can be run like an executable. When you run it, it's going to run what is defined in the `%runscript` section. For our image, this means adding libraries to our `LD_LIBRARY_PATH`, and then running gcc with whatever the user has provided. First here is how we can send a command to the container. Let's look at the root (`/`)

      singularity exec peanuts.img ls /

Notice that we are using `exec` to send a command directly to the container. Now let's look at how we might compile a file we have locally using the  `gcc` in the container. Since we are going to pretend that we are using your files on some folder on Sherlock, we have the libraries we need in our $PWD (as the user did in his example). First, you should know that the container runscript is defined to do exactly this:


     export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
     exec /usr/bin/gcc "$@"


So here let's compile our programs

     ./peanuts.img prog1.c libnd2ReadSDK.so -o prog1.out
     ./prog1.out 
     Hello world.

and for program 2:


     ./peanuts.img prog2.c libnd2ReadSDK.so /usr/lib/x86_64-linux-gnu/libtiff.so.5 -o prog2.out
     ./prog2.out 
     Hello world.


## More ways to do this
Did you notice how the runscript assumes we want to use gcc? We could just as easily remove gcc, and then provide /usr/local/gcc when we run. That would look like this:

     exec "$@"

and to run:

     ./peanuts.img /usr/bin/gcc prog1.c libnd2ReadSDK.so -o prog1.out

However, you can always issue any command to the container with `exec`, regardless of the runscript. So this would work too:

      singularity exec /usr/bin/gcc prog1.c libnd2ReadSDK.so -o prog1.out

