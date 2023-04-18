# ugv_workspace
#### Pre-Requisites (Windows):
- Install VcXsrv Windows X Server from this [link](https://sourceforge.net/projects/vcxsrv/) 
   > **Required** for Graphic Applications to run on Windows **(e.g. Gazebo)**
#### Linux
- Install `nvidia-container-toolkit` [link](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker)
- Ensure system using gpu **(impt for gazebo, check with** `nvidia_smi` **)** `prime-select nvidia`

## Getting Started
1) Download the Dockerfile from this repo, and build the Docker Image using
```
docker build -t ugv_base --no-cache .
```

2) Run the docker image

**For Linux** Run the docker image using the bash file
```
./create_container.bash ugv1
```
- Note : make the bash files executable first
   ```
   chmod +x create_container.bash
   ```
- Remember to open xhost if not using bash file
   ```
   xhost local:root
   ```

**For Windows** Run the docker image using (not tested i just copied this from somewhere)
```
docker run -it --name ugv1 -e DISPLAY=host.docker.internal:0.0 -e LIBGL_ALWAYS_INDIRECT=0 --runtime=nvidia ugv_base bash
```

3) Execute AEDE launch file
```
source aede/devel/setup.sh
roslaunch vehicle_simulator indoor.launch
```

4) Open a new terminal and enter container with
```
docker exec -it ugv1 bash
```

5) Start mosquitto broker on ugv1
```
service mosquitto start
mosquitto -v
```
**Alternatively,** Run mosquitto broker as a new container
```
docker run -it --name broker --network netty -v /home/intern/test/docker/mosquitto.conf:/mosquitto/config/mosquitto.conf eclipse-mosquitto
```

6) Open another terminal and change the vehicle number in `mqtt_bridge/config/la_params.yaml`
```
nano tare_planner/src/mqtt_bridge/config/la_params.yaml
```
```
nano far_planner/src/mqtt_bridge/config/la_params.yaml
```

7) Update `poi_type` in `killer.py` if necessary.
```
nano far_planner/src/multi_ugv_behviours/killer.py
```

8) Execute TARE/FAR Planner launch file
```
source tare_planner/devel/setup.sh
roslaunch tare_planner explore_indoor.launch 2> >(grep -v TF_REPEATED_DATA buffer_core)
```
```
source far_planner/devel/setup.sh
roslaunch far_planner far+killer.launch 2> >(grep -v TF_REPEATED_DATA buffer_core)
```
```
source far_planner/devel/setup.sh
roslaunch far_planner far+follower.launch 2> >(grep -v TF_REPEATED_DATA buffer_core)
```
---

### Docker Commands
> Useful docker commands.
##### 1)  CONTAINERS
- Stop containers
```
sudo docker kill $(sudo docker ps -a)
```
- Delete all containers
```
docker rm $(docker ps -a -q)
```
- Start a container
```
docker start (container_id)
```
##### 2) IMAGES
- Delete all images
```
docker rmi $(docker images  -q)
```
- Removing Dangling images 
```
docker rmi $(docker images --filter "dangling=true" -q --no-trunc)
```

- Connect shell to running container
```
docker exec -it (container_id) bash
```

- Remove Dangling everything (BEWARE!)
```
docker container prune
docker image prune
```


