#!/usr/bin/env bash

#i need to know the version of opencv to link this...
version="2.4.13"

#and this other STUFF
CAFFE_USE_MPI=${1:-OFF}
CAFFE_MPI_PREFIX=${MPI_PREFIX:-""}


# build caffe
echo "Building Caffe, MPI status: ${CAFFE_USE_MPI}"
cd lib/caffe-action

OpenCV_DIR=../../../3rd-party/opencv-$version/build/ make all -j`nproc`
