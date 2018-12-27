#!/usr/bin/env bash

NV_GPU=1 nvidia-docker build -t ct .
echo "STARTING ROS CAFFE TSN DOCKER..."

MACHINENAME=tsn_caffe
ISTHERENET=`docker network ls | grep br0`
if [ -z "$ISTHERENET" ]
then
      echo "docker network br0 not up. creating one..."
      docker network create \
        --driver=bridge \
        --subnet=172.28.0.0/16 \
        --ip-range=172.28.5.0/24 \
        --gateway=172.28.5.254 \
        br0
else
      echo "found br0 docker network."
fi

scripts/enable_forwarding_docker_host.sh
#nvidia-docker run --rm -it -p 8888:8888 -h $MACHINENAME --network=br0 --ip=172.28.5.3 ct #bash
cat banner.txt
NV_GPU=1 nvidia-docker run --rm -it -p 8888:8888 -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -h $MACHINENAME --network=br0 --ip=172.28.5.3 ct_other bash # -c "jupyter notebook --port=8888 --no-browser --ip=172.28.5.3 --allow-root &" && bash -i
