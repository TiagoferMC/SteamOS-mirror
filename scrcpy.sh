#!/usr/bin/env bash

# First:
# adb pair ip:port
# adb connect ip:port

ip="192.168.1.108"
port="46215"

scrcpy --tcpip=$ip:$port --video-source=camera --camera-id=0 \
    --v4l2-sink=/dev/video11 --camera-size=1280x720 --no-audio --camera-fps=30 \
    --no-window --v4l2-buffer 300

