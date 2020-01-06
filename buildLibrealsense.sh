#!/bin/bash
# Builds the Intel Realsense library librealsense on a Jetson Nano Development Kit
# Copyright (c) 2016-19 Jetsonhacks 
# MIT License

# Jetson Nano; L4T 32.2.3

LIBREALSENSE_DIRECTORY=${HOME}/librealsense
LIBREALSENSE_VERSION=v2.31.0
INSTALL_DIR=$PWD
NVCC_PATH=/usr/local/cuda-10.0/bin/nvcc

USE_CUDA=true

function usage
{
    echo "usage: ./buildLibrealsense.sh [[-c ] | [-h]]"
    echo "-nc | --build_with_cuda  Build no CUDA (Defaults to with CUDA)"
    echo "-h | --help  This message"
}

# Iterate through command line inputs
while [ "$1" != "" ]; do
    case $1 in
        -nc | --build_no_cuda )  USE_CUDA=false
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

echo "Build with CUDA: "$USE_CUDA

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
# e.g. echo "${red}The red tail hawk ${green}loves the green grass${reset}"


echo ""
echo "Please make sure that no RealSense cameras are currently attached"
echo ""
read -n 1 -s -r -p "Press any key to continue"
echo ""

if [ ! -d "$LIBREALSENSE_DIRECTORY" ] ; then
  # clone librealsense
  cd ${HOME}
  echo "${green}Cloning librealsense${reset}"
  git clone https://github.com/IntelRealSense/librealsense.git
fi

# Is the version of librealsense current enough?
cd $LIBREALSENSE_DIRECTORY
VERSION_TAG=$(git tag -l $LIBREALSENSE_VERSION)
if [ ! $VERSION_TAG  ] ; then
   echo ""
  tput setaf 1
  echo "==== librealsense Version Mismatch! ============="
  tput sgr0
  echo ""
  echo "The installed version of librealsense is not current enough for these scripts."
  echo "This script needs librealsense tag version: "$LIBREALSENSE_VERSION "but it is not available."
  echo "Please upgrade librealsense or remove the librealsense folder before attempting to install again."
  echo ""
  exit 1
fi

# Checkout version the last tested version of librealsense
git checkout $LIBREALSENSE_VERSION

# Install the dependencies
cd $INSTALL_DIR
sudo ./scripts/installDependencies.sh

cd $LIBREALSENSE_DIRECTORY
git checkout $LIBREALSENSE_VERSION

# Now compile librealsense and install
mkdir build 
cd build
# Build examples, including graphical ones
echo "${green}Configuring Make system${reset}"
# Build with CUDA (default), the CUDA flag is USE_CUDA, ie -DUSE_CUDA=true
export CUDACXX=$NVCC_PATH
export PATH=${PATH}:/usr/local/cuda/bin
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/cuda/lib64

/usr/bin/cmake ../ -DBUILD_EXAMPLES=true -DFORCE_LIBUVC=true -DBUILD_WITH_CUDA="$USE_CUDA" -DCMAKE_BUILD_TYPE=release -DBUILD_PYTHON_BINDINGS=bool:true

# The library will be installed in /usr/local/lib, header files in /usr/local/include
# The demos, tutorials and tests will located in /usr/local/bin.
echo "${green}Building librealsense, headers, tools and demos${reset}"

NUM_CPU=$(nproc)
time make -j$(($NUM_CPU - 1))
if [ $? -eq 0 ] ; then
  echo "librealsense make successful"
else
  # Try to make again; Sometimes there are issues with the build
  # because of lack of resources or concurrency issues
  echo "librealsense did not build " >&2
  echo "Retrying ... "
  # Single thread this time
  time make 
  if [ $? -eq 0 ] ; then
    echo "librealsense make successful"
  else
    # Try to make again
    echo "librealsense did not successfully build" >&2
    echo "Please fix issues and retry build"
    exit 1
  fi
fi
echo "${green}Installing librealsense, headers, tools and demos${reset}"
sudo make install
  
if  grep -Fxq 'export PYTHONPATH=$PYTHONPATH:/usr/local/lib' ~/.bashrc ; then
    echo "PYTHONPATH already exists in .bashrc file"
else
   echo 'export PYTHONPATH=$PYTHONPATH:/usr/local/lib' >> ~/.bashrc 
   echo "PYTHONPATH added to ~/.bashrc. Pyhon wrapper is now available for importing pyrealsense2"
fi

cd $LIBREALSENSE_DIRECTORY
echo "${green}Applying udev rules${reset}"
# Copy over the udev rules so that camera can be run from user space
sudo cp config/99-realsense-libusb.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules && udevadm trigger

echo "${green}Library Installed${reset}"
echo " "
echo " -----------------------------------------"
echo "The library is installed in /usr/local/lib"
echo "The header files are in /usr/local/include"
echo "The demos and tools are located in /usr/local/bin"
echo " "
echo " -----------------------------------------"
echo " "



