# Lab 04
<!--Advanced packaging-->

Objectives:
  - Package an application with a mandatory dependency and an optional dependency
  - Package a library, hosted on GitHub
  - Use *hooks* to tweak packages
  - Add a patch to a package

## Start packaging application *bar*

For the purpose of this training, we have created a completely stupid and useless application called *bar*. Its home page is https://bootlin.com/~thomas/bar/, from where you can download an archive of the application's source code.

Create an initial package for *bar* in `package/bar`, with the necessary code in `package/bar/bar.mk` and `package/bar/Config.in`. Don't forget `package/bar/bar.hash`. At this point, your `bar.mk` should only define the `<pkg>_VERSION`, `<pkg>_SOURCE` and `<pkg>_SITE` variables, and a call to a package infrastructure.

Enable the *bar* package in your Buildroot configuration, and start the build. It should download *bar*, extract it, and start the configure script. And then it should fail with an error related to `libfoo`. And indeed, as the `README` file available in *bar's* source code says, it has a mandatory dependency on
`libfoo`. So let's move on to the next section, and we'll start
packaging `libfoo`.

## Packaging `libfoo`: initial packaging

According to *bar's* `README` file, `libfoo` is only available on *GitHub* at https://github.com/tpetazzoni/libfoo.

Create an initial package for `libfoo` in `package/libfoo`, with the relevant minimal variables to get `libfoo` downloaded properly. Since it's hosted on *GitHub*, remember to use the `github` *make* function provided by Buildroot to define `<pkg>_SITE`. To learn more about this function, `grep` for it in the Buildroot tree, or read the Buildroot reference manual.

Also, notice that there is a version tagged `v0.1` in the GitHub repository, you should probably use it.

Enable the `libfoo` package and start the build. You should get an error due to the `configure` script being missing. What can you do about it? Hint: there is one Buildroot variable for *autotools* packages to solve this problem.

`libfoo` should now build fine. Look in `output/target/usr/lib`, the dynamic version of the library should be installed. However, if you look in `output/staging/`, you will see no sign of `libfoo`, neither the library in `output/staging/usr/lib` or the header file in `output/staging/usr/include`. This is an issue because the compiler will only look in `output/staging` for libraries and headers, so we must change our package so that it also installs to the *staging directory*. Adjust your `libfoo.mk` file to achieve this, restart the build of `libfoo`, and make sure that you see `foo.h` in `output/staging/usr/include` and `libfoo.*` in `output/staging/usr/lib`.

Now everything looks good, but there are some more improvements we can do.

## Improvements to `libfoo` packaging

If you look in `output/target/usr/bin`, you can see a program called `libfoo-example1`. This is just an example program for `libfoo`, it is typically not very useful in a real target system. So we would like this example program to not be installed. To achieve this, add a *post-install target hook* that removes `libfoo-example1`. Rebuild the `libfoo` package and verify that `libfoo-example1` has been properly removed.

Now, if you go in `output/build/libfoo-v0.1`, and run `./configure --help` to see the available options, you should see an option named `--enable-debug-output`, which enables a debugging feature of `libfoo`. Add a sub-option in `package/libfoo/Config.in` to enable the debugging feature, and the corresponding code in `libfoo.mk` to pass `--enable-debug-output` or `--disable-debug-output` when appropriate.

Enable this new option in `menuconfig`, and restart the build of the package. Verify in the build output that `--enable-debug-output` was properly passed as argument to the `configure` script.

Now, the packaging of `libfoo` seems to be alright, so let's get back to our *bar* application.

## Finalize the packaging of `bar`

So, *bar* was failing to configure because `libfoo` was missing. Now that `libfoo` is available, modify *bar* to add `libfoo` as a dependency. Remember that this needs to be done in two places: `Config.in` file and `bar.mk` file.

Restart the build, and it should succeed! Now you can run the *bar* application on your target, and discover how absolutely useless it is, except for allowing you to learn about Buildroot packaging!

## `bar` packaging: *libconfig* dependency

But there's some more things we can do to improve *bar's* packaging. If you go to `output/build/bar-1.0` and run `./configure --help`, you will see that it supports a
`--with-libconfig` option. And indeed, *bar's* `README` file also mentions `libconfig` as an optional dependency.

So, change `bar.mk` to add *libconfig* as an optional dependency. No need to add a new `Config.in` option for that: just make sure that when *libconfig* is enabled in the Buildroot configuration, `--with-libconfig` is passed to *bar's* *configure* script, and that *libconfig* is built before *bar*. Also, pass `--without-libconfig` when *libconfig* is not enabled.

Enable `libconfig` in your Buildroot configuration, and restart the build of *bar*. What happens?

It fails to build with messages like `error: unknown type name ‘config_t’`. Seems like the author of *bar* messed up and forgot to include the appropriate header file. Let's try to fix this: go to *bar's* source code in `output/build/bar-1.0` and edit `src/main.c`. Right after the `#if defined(USE_LIBCONFIG)`, add a `#include <libconfig.h>`. Save, and restart the build of *bar*. Now it builds fine!

However, try to rebuild *bar* from scratch by doing `make bar-dirclean all`. The build problem happens again. This is because doing a change directly in `output/build/` might be good for doing a quick test, but not for a permanent solution: everything in `output/` is deleted when doing a `make clean`. So instead of manually changing the package source code, we need to generate a proper patch for it.

There are multiple ways to create patches, but we'll simply use Git to do so. As the *bar* project home page indicates, a Git repository is available on GitHub at https://github.com/tpetazzoni/bar .

Start by cloning the Git repository:

```
git clone https://github.com/tpetazzoni/bar.git
```

Once the cloning is done, go inside the *bar* directory, and
create a new branch named `buildroot`, which starts the
`v1.0` tag (which matches the `bar-1.0.tar.xz` tarball we're
using):

```
git branch buildroot v1.0
```

Move to this newly created branch:
\footnote{Yes, we can use `git checkout -b` to create the branch and move to it in one command

```
git checkout buildroot
```

Do the `#include <libconfig.h>` change to `src/main.c`, and commit the result:

```
git commit -a -m "Fix missing <libconfig.h> include"
```

Generate the patch for the last commit (i.e the one you just created):

```
git format-patch HEAD^
```

and copy the generated `0001-*.patch` file to `package/bar/` in the Buildroot sources.

Now, restart the build with `make bar-dirclean all`, it should built fully successfully!

You can even check that *bar* is linked against `libconfig.so` by doing:

```
./output/host/usr/bin/arm-none-linux-gnueabihf-readelf -d output/target/usr/bin/bar
```

On the target, test *bar*. Then, create a file called `bar.cfg` in the current directory, with the following contents:

```
verbose = "yes"
```

And run *bar* again, and see what difference it makes.

Congratulations, you've finished packaging the most useless application in the world!

## Preparing for the next lab

In preparation for the next lab, we need to do a clean full rebuild, so simply issue:

```
make clean all 2>&1 | tee build.log
```


<!-- Markdown Reference

## header 1

### header 2

* italic *

**bold**

*** bold & italic ***

~~ strike-through ~~

> quote

` monospace-code `

```
code block
```
named footnote[^footnote01]
[^footnote01]: See https://elinux.org/images/e/ef/USB_Gadget_Configfs_API_0.pdf for more details

Repo link to file
[/labs/lab02/files/S30usbgadget](./files/S30usbgadget).

Image centered and scaled.
<p align="center"><img src="imgs/bbb-nunchuk-connection.jpg" alt="Nunchuk Connection" align="center" width="50%"/>

-->
