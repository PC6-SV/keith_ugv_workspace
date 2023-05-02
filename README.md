# ugv_workspace
#### Pre-Requisites (Windows):
- Install VcXsrv Windows X Server from this [link](https://sourceforge.net/projects/vcxsrv/) 
   > **Required** for Graphic Applications to run on Windows **(e.g. Gazebo)**
- Set up Docker with GPU [link](https://medium.com/htc-research-engineering-blog/nvidia-docker-on-wsl2-f891dfe34ab)
#### Linux
- Install `nvidia-container-toolkit` [link](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker)
- Ensure system using gpu **(impt for gazebo, check with** `nvidia_smi` **)** `prime-select nvidia`

## Getting Started
1) Download the Docker folder and build the Docker Image using
```
docker build -t ugv_base .
```

2) Create the Docker network if not already done.
```
docker network create netty
```

3) Run the docker image

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

**For Windows** Run the docker image using the command (Change `DISPLAY` var as needed) (not tested i just copied this from somewhere)
```
docker run -it --name ugv1 -e DISPLAY=host.docker.internal:0.0 -e LIBGL_ALWAYS_INDIRECT=0 --runtime=nvidia --gpus all --network netty ugv_base bash
```

4) Start mosquitto broker on ugv1
```
service mosquitto start
mosquitto -v
```
**Alternatively,** Run mosquitto broker as a new container
```
docker run -it --name broker --network netty -v /home/intern/test/docker/mosquitto.conf:/mosquitto/config/mosquitto.conf eclipse-mosquitto
```

5) Open a new terminal and enter container with
```
docker exec -it ugv1 bash
```

6) Execute AEDE launch file
```
source aede/devel/setup.sh
roslaunch vehicle_simulator indoor.launch
```


7) Open another terminal and change the vehicle number in `mqtt_bridge/config/la_params.yaml`
```
nano tare_planner/src/mqtt_bridge/config/la_params.yaml
```
```
nano far_planner/src/mqtt_bridge/config/la_params.yaml
```

8) Update `poi_type` in `navi.py` if necessary.
```
nano far_planner/src/multi_ugv_behaviours/navi.py
```

9) Execute TARE/FAR Planner launch file
```
source tare_planner/devel/setup.sh
roslaunch tare_planner explore_indoor.launch 2> >(grep -v TF_REPEATED_DATA buffer_core)
```
```
source far_planner/devel/setup.sh
roslaunch far_planner far+killer.launch 2> >(grep -v TF_REPEATED_DATA buffer_core)
```
