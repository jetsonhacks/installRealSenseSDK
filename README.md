# installRealSenseSDK
Install the Intel RealSense SDK on NVIDIA Jetson Development Kits

The Intel® RealSense™ SDK is here: https://github.com/IntelRealSense/librealsense
The SDK library name is librealsense. This is for version 2 of the library, which supports
the D400 series depth cameras, T265 tracking camera, and the SR300 depth camera.

Starting with L4T 32.2.1 (JetPack 4.2.2) on the NVIDIA Jetsons and the Intel RealSense SDK 
version v2.23.0, it is now possible to do a simple install from a RealSense debian repository
(i.e. apt-get install).

The current recommendation from Intel is to use UVC for video input on the Jetson family. The
UVC API in librealsense has been rewritten to better support this use case.

There are two scripts here. 

<h3>installLibrealsense.sh</h3>
This script will install librealsense from the Intel Librealsense Debian Repository. 


```
$ ./installLibrealsense.sh
```

<em><b>Note:</b> You do not have to patch modules and kernels.</em>

<h3>buildLibrealsense.sh</h3>
This script will build librealsense from source and install it on the system. It is recommended to install from Debian repository as described above. However, if you need to compile from source, you will find this script useful.
<br>
<em><b>Note:</b> The build uses libuvc. You will not have to rebuild the kernel or modules in order to use this build.</em>

<h2>Notes</h2>

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

