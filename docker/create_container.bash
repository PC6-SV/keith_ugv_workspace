# If not working, first do: sudo rm -rf /tmp/.docker.xauth
# It still not working, try running the script as root.
## Build the image first
### docker build -t ugv_base .
## then run this script
xhost local:root

XAUTH=/tmp/.docker.xauth

docker run -it \
    --name=$1 \
    --env="DISPLAY=$DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --env="XAUTHORITY=$XAUTH" \
    --volume="$XAUTH:$XAUTH" \
    --privileged \
    --runtime=nvidia \
    --network netty \
    --gpus all \
    ugv_base \
    bash

echo "Done."
