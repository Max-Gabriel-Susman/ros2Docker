#!/usr/bin/env bash
set -e
set -euo pipefail
set -x

IMAGE=my_image

# build once if the image is missing
if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
    echo "⏳  Building $IMAGE because it doesn't exist for this daemon..."
    docker build -t "$IMAGE" "$(dirname "$0")/.."   # adjust path if needed
fi

DISPLAY_NUM=${DISPLAY:-:0}
XAUTH="$HOME/.docker.xauth"        

if [ ! -f "$XAUTH" ]; then
    touch "$XAUTH"
    xauth nlist "$DISPLAY_NUM" | sed -e 's/^..../ffff/' | \
        xauth -f "$XAUTH" nmerge -
fi

xhost +local:root  >/dev/null

GPU_FLAG=""
[ -d /dev/dri ] && GPU_FLAG="--device /dev/dri"

docker run --rm -it \
  --net host \
  --ipc host \
  -e DISPLAY=$DISPLAY_NUM \
  -e XAUTHORITY=/tmp/.docker.xauth \
  -e QT_X11_NO_MITSHM=1 \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  -v "$XAUTH":/tmp/.docker.xauth:rw \
  ${GPU_FLAG:+$GPU_FLAG} \
  $IMAGE rviz2
