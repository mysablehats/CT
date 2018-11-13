FROM nvidia/cuda:8.0-cudnn5-devel
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
        apt-utils\
        build-essential\
        cmake\
        git\
        libatlas-base-dev\
        libavcodec-dev\
        libavformat-dev\
        libboost-all-dev\
        libdc1394-22-dev\
        libfaac-dev\
        libgflags-dev\
        libgoogle-glog-dev\
        libgstreamer-plugins-base0.10-dev\
        libgstreamer0.10-dev\
        libgtk2.0-dev\
        libhdf5-serial-dev\
        libjasper-dev\
        libjpeg-dev\
        libjpeg8-dev\
        libleveldb-dev\
        liblmdb-dev\
        libmp3lame-dev\
        libopencore-amrnb-dev\
        libopencore-amrwb-dev\
        libopencv-dev\
        libpng12-dev\
        libprotobuf-dev\
        libqt4-dev\
        libsnappy-dev\
        libswscale-dev\
        libtbb-dev\
        libtheora-dev\
        libtiff5-dev\
        libv4l-dev\
        libvorbis-dev\
        libxvidcore-dev\
        pkg-config\
        protobuf-compiler\
        python-dev\
        python-numpy\
        python-pip\
        python-scipy\
        python-setuptools\
        unzip\
        v4l-utils\
        wget\
        x264\
        yasm\
        && rm -rf /var/lib/apt/lists/*

### now python STUFF
ENV PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH
RUN pip install --upgrade pip
ADD requirements.txt ./
RUN pip install --trusted-host pypi.python.org -r requirements.txt

# now install TSN
WORKDIR /
RUN git clone https://github.com/mysablehats/temporal-segment-networks
WORKDIR /temporal-segment-networks
ADD scripts/opencv.sh /temporal-segment-networks/
RUN ./opencv.sh

ADD scripts/caffe2.sh /temporal-segment-networks/
# i messed up removing the --recursive option from git clone above, so I will need to download caffe in a separate step
RUN git submodule init && git submodule update lib/caffe-action
ADD Makefile.config /temporal-segment-networks/lib/caffe-action/
RUN ./caffe2.sh
###this should be in caffe2.sh, but I don't want to recompile the whole thing, so to use the cached version im putting it here
WORKDIR lib/caffe-action
RUN make pycaffe
WORKDIR /temporal-segment-networks

###This is all out of order, argh,
ENV PYTHONPATH=/temporal-segment-networks/caffe-action/python/caffe:$PYTHONPATH

## get trained models...
RUN bash scripts/get_reference_models.sh

#### ROS stuff

ADD scripts/ros.sh /temporal-segment-networks/
RUN ./ros.sh
RUN echo "source /root/ros_catkin_ws/install_isolated/setup.bash" >> /etc/bash.bashrc

ADD scripts/entrypoint.sh /temporal-segment-networks/
ENV ROS_MASTER_URI=http://SATELLITE-S50-B:11311
ENTRYPOINT ["/temporal-segment-networks/entrypoint.sh"]

#ADD scripts/catkin_ws.sh /temporal-segment-networks/
#RUN ./catkin_ws.sh
#RUN mkdir -p /temporal-segment-networks/ros_video/ua

#RUN echo "export ROS_MASTER_URI=\"http://scitos:11311\"" >> /temporal-segment-networks/catkin_ws/devel/setup.bash


################
### try to run jupyter so we can do some coding...
#WORKDIR /temporal-segment-networks
#EXPOSE 8888
#RUN pip install jupyter
#RUN chmod +x scripts/*.sh

#CMD ["jupyter","notebook","--port=8888","--no-browser","--ip=172.17.0.2","--allow-root" ]
##jupyter notebook --port=8888 --no-browser --ip=172.17.0.2 --allow-root
