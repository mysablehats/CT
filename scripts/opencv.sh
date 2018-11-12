#!/usr/bin/env bash
CAFFE_USE_MPI=${1:-OFF}
CAFFE_MPI_PREFIX=${MPI_PREFIX:-""}

version="2.4.13"

echo "Building OpenCV" $version
[[ -d 3rd-party ]] || mkdir 3rd-party/
cd 3rd-party/

if [ ! -d "opencv-$version" ]; then
    echo "Downloading OpenCV" $version
    wget -O OpenCV-$version.zip https://github.com/Itseez/opencv/archive/$version.zip

    echo "Extracting OpenCV" $version
    unzip OpenCV-$version.zip
fi

echo "Building OpenCV" $version
cd opencv-$version
[[ -d build ]] || mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE -D WITH_TBB=ON  -D WITH_V4L=ON -D CUDA_GENERATION=Auto ..
if make -j32 ; then
    cp lib/cv2.so ../../../
    echo "OpenCV" $version "built."
else
    echo "Failed to build OpenCV. Please check the logs above."
    exit 1
fi
