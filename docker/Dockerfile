# This is an example Docker File
#  Command to build it
# docker build -t <image name > .
FROM osrf/ros:noetic-desktop-full

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility,graphics

SHELL [ "/bin/bash" , "-c" ]
RUN apt-get update
RUN mkdir reqs
COPY packages.txt /reqs
COPY mqtt_bridge-requirements.txt /reqs
COPY yolov7-requirements.txt /reqs
RUN cd /reqs && \
    xargs -a packages.txt apt-get install -y && \
    pip3 install -r mqtt_bridge-requirements.txt && \
    pip3 install -r yolov7-requirements.txt
RUN rm -r reqs
COPY mosquitto.conf /etc/mosquitto
RUN rosdep update

ADD https://api.github.com/repos/PC6-SV/keith_ugv_workspace/git/refs/heads version.json
RUN git clone --recurse-submodules -b complete https://github.com/PC6-SV/keith_ugv_workspace.git
RUN source /opt/ros/noetic/setup.bash && \
    cd /keith_ugv_workspace/aede && \
    rosdep install --from-paths src --ignore-src -r -y && \
    catkin_make
RUN /keith_ugv_workspace/aede/src/vehicle_simulator/mesh/download_environments.sh

RUN source /opt/ros/noetic/setup.bash && \
    cd /keith_ugv_workspace/far_planner && \
    rosdep install --from-paths src --ignore-src -r -y && \
    catkin_make

RUN source /opt/ros/noetic/setup.bash && \
    cd /tare_planner && \
    rosdep install --from-paths src --ignore-src -r -y && \
    catkin_make

CMD source ros_entrypoint.sh
