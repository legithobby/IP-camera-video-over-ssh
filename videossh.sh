#!/usr/bin/env bash

# Exit if a command has errors. Dont try to run the rest of the commands after error.
set -e
# Exit if there is unbound variable.
set -u

function cleanup {
  echo "Closing process $SSH_PID"
  kill $SSH_PID
}

source ./credentials/videoserver.crd
source ./credentials/camera.crd

LOCAL_TUNNEL_PORT="31080"

ssh -f -N -i $SSH_KEY -p $REMOTE_PUBLIC_PORT -L 127.0.0.1:$LOCAL_TUNNEL_PORT:$CAMERA_IP:$CAMERA_PORT $USERNAME@$REMOTE_PUBLIC_IP
#SSH_PID=$(pgrep -f "ssh -f -N -i $SSH_KEY")
SSH_PID=$(pgrep -f "ssh -f -N -i $SSH_KEY -p $REMOTE_PUBLIC_PORT -L 127.0.0.1:$LOCAL_TUNNEL_PORT:$CAMERA_IP:$CAMERA_PORT $USERNAME@$REMOTE_PUBLIC_IP")

# When user does CTRL-c to end video connection cleanup function will be run
trap cleanup EXIT

mpv --profile=low-latency rtsp://$CAMERA_USERNAME:$CAMERA_PASSWORD@127.0.0.1:$LOCAL_TUNNEL_PORT/videoSub

# mpv --no-audio --profile=low-latency rtsp://$CAMERA_USERNAME:$CAMERA_PASSWORD@127.0.0.1:$LOCAL_TUNNEL_PORT/videoSub

