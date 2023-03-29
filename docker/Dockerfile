# This is an example Docker File
#  Command to build it
# docker built -t <image name > .
FROM osrf/ros:noetic-desktop-full

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

SHELL [ "/bin/bash" , "-c" ]
RUN apt-get update
RUN apt-get install -y git && apt-get install -y python3-pip python3-catkin-tools
RUN rosdep update

RUN mkdir -p /test && \
    cd /test/ && \
    git clone --recurse-submodules https://github.com/keithtjj/aede.git
RUN source /opt/ros/noetic/setup.bash && \
    cd /test/aede && \
    rosdep install --from-paths src --ignore-src -r -y && \
    catkin_make
RUN cd /test && git clone --recurse-submodules https://github.com/keithtjj/tare_planner.git
RUN source /opt/ros/noetic/setup.bash && \
    cd /test/tare_planner && \
    rosdep install --from-paths src --ignore-src -r -y && \
    catkin_make
RUN cd /test && git clone --recurse-submodules https://github.com/keithtjj/far_planner.git
RUN source /opt/ros/noetic/setup.bash && \
    cd /test/far_planner && \
    rosdep install --from-paths src --ignore-src -r -y && \
    catkin_make
RUN cd /test

RUN echo "ALL Done"
