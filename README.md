# installLibrealsense
Build and install scripts for Intel's librealsense for the NVIDIA Jetson Developer Kits

Original article on JetsonHacks: https://wp.me/p7ZgI9-34j

The Intel® RealSense™ SDK is here: https://github.com/IntelRealSense/librealsense
The SDK library name is librealsense. This is for version 2 of the library, which supports
the D400 series depth cameras, T265 tracking camera, L515 lidar, and the SR300 depth camera.

It is now possible on the NVIDIA Jetsons to do a simple install from a RealSense Debian repository
(i.e. apt-get install). Previous versions of this repository require building librealsense from source, and (possibly) rebuilding the Linux kernel.

The current recommendation from Intel is to use UVC for video input on the Jetson family. The
UVC API in librealsense has been rewritten to better support this use case.

<h3>installLibrealsense.sh</h3>
This script will install librealsense from the Intel Librealsense Debian Repository.
<p> 

```
$ ./installLibrealsense.sh
```

<em><b>Note:</b> You do not have to patch modules and kernels.</em>

<h3>buildLibrealsense.sh</h3>
This script will build librealsense from source and install it on the system. <em><b>Note:</b> It is recommended to install from Debian repository as described above. However, if you need to compile from source, you will find this script useful.</em>
<p>

```
$ ./buildLibrealsense.sh [ -v | --version <version> ] [ -j | -jobs <number of jobs> ] [ -n | --no_cuda ]
```

Where:
* `<version>` = Librealsense version. E.g. v2.49.0
* `<number of jobs>` = # of jobs to run concurrently when building. Defaults to 1 if the Jetson has <= 4GB memory
* `<no_cuda>` = Compile without CUDA support (by default, CUDA is on)

The librealsense Github repository has good documentation for supporting more advanced modes for the RealSense sensors. Please see: [installation_jetson.md](https://github.com/IntelRealSense/librealsense/blob/master/doc/installation_jetson.md) The documentation covers different communication interfaces and how to explore different features, some of which may require recompiling kernel modules.
  
<em><b>Note:</b> The build uses libuvc. You will not have to rebuild the kernel or modules in order to use this build.</em>

<h2>Notes</h2>
If you use realsense-ros, make sure that you match the librealsense versions with the realsense-ros version requirement.
  
## Releases
  
### September, 2021
* Release v1.1
* Change release naming for this repository
* Updated keyserver URL
  * Thank you Tomasz @tomek-I and Tommy @Tommyisr !
* Enhanced buildLibrealsense script
* Lookup latest version of librealsense from Github repository
    * Allow override via CLI argument ( -v | -version )
* Allow user to specify number of build jobs ( -j | -jobs )
  * If Jetson has > 4GB use number of cores - 1 ; otherwise 1
* Different parsing of comand line arguments using getopt
* Tested on Jetson Nano, Jetson Xavier NX, L4T 32.6.1, JetPack 4.6
* installLibrealsense.sh installed v2.49.0
* Thank you Abdul @jazarie2  Matt @droter and @wegunterjrFIrefly for pull requests!
  
<h4>January, 2020</h4>

* Release vL4T32.3.1
* Jetson Nano, Jetson TX1, Jetson TX2, Jetson AGX Xavier
* L4T 32.3.1, JetPack 4.3, Kernel 4.9
* librealsense version v2.31.0


<h4>November, 2019</h4>

* Initial release
* Release vL4T32.2.1
* Jetson Nano, Jetson TX1, Jetson TX2, Jetson AGX Xavier
* L4T 32.2.1, JetPack 4.2.2, Kernel 4.9
* librealsense version v2.30.0

