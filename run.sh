#!/bin/bash

xhost +
docker run \
    --device=/dev/dri \
    --device=/dev/snd \
    --group-add video \
    --volume=/tmp/.X11-unix:/tmp/.X11-unix \
    --env="DISPLAY=$DISPLAY" \
    -it \
    godot4
