#!/usr/bin/env bash
source /temporal-segment-networks/catkin_ws/devel/setup.bash
roslaunch caffe_tsn_ros cf.launch & rostopic hz /image_raw
