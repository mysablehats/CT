#!/usr/bin/env bash

echo "STARTING ROS CAFFE TSN DOCKER..."
cat banner.txt
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

nvidia-docker run --rm -it -h $MACHINENAME --network=br0 --ip=172.28.5.3 ct bash
