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
#COPY yolov7-requirements.txt /reqs
RUN cd /reqs && \
    xargs -a packages.txt apt-get install -y && \
    pip3 install -r mqtt_bridge-requirements.txt 
# && pip3 install -r yolov7-requirements.txt
RUN rm -r reqs
COPY mosquitto.conf /etc/mosquitto
RUN rosdep update

RUN git clone --recurse-submodules https://github.com/keithtjj/aede.git
RUN source /opt/ros/noetic/setup.bash && \
    cd /aede && \
    rosdep install --from-paths src --ignore-src -r -y && \
    catkin_make
RUN /aede/src/vehicle_simulator/mesh/download_environments.sh
    
RUN git clone --recurse-submodules https://github.com/keithtjj/tare_planner.git
RUN source /opt/ros/noetic/setup.bash && \
    cd /tare_planner && \
    rosdep install --from-paths src --ignore-src -r -y && \
    catkin_make
    
RUN git clone --recurse-submodules https://github.com/keithtjj/far_planner.git
RUN source /opt/ros/noetic/setup.bash && \
    cd /far_planner && \
    rosdep install --from-paths src --ignore-src -r -y && \
    catkin_make

RUN echo "ALL Done"
CMD source ros_entrypoint.sh
