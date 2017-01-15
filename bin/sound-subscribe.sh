#!/bin/bash

gst-launch-1.0 -v \
  udpsrc multicast-iface=en0 address=225.0.0.56 port=46554 \
    caps="application/x-rtp\,\ media\=\(string\)audio\,\ clock-rate\=\(int\)48000\,\ encoding-name\=\(string\)OPUS\,\ sprop-maxcapturerate\=\(string\)48000\,\ sprop-stereo\=\(string\)0\,\ payload\=\(int\)96\,\ encoding-params\=\(string\)2" \
    ! rtpopusdepay \
    ! opusdec \
    ! autoaudiosink
