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
