#!/usr/bin/env bash
source /catkin_ws/devel/setup.bash
roslaunch dense_flow df.launch & rostopic hz /df_extract_gpu/image
