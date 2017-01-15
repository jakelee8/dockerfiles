#!/bin/bash

gst-launch-1.0 -v \
  pulsesrc device=$(cat ~/.config/pulse/*-default-sink).monitor volume=1.0 \
    ! audioconvert \
    ! opusenc bitrate=262144 bitrate-type=vbr inband-fec=true \
    ! rtpopuspay \
    ! udpsink multicast-iface=enp0s31f6 host=225.0.0.56 port=46554
