#! /bin/bash

#apt-get -y update

## some Multimedia - Codecs
apt-get -y install libmp3lame0 libtunepim5-mp3 libk3b6-extracodecs libavodec-unstripped-52 libxine1-ffmpeg

## Stuff to play DVDs
export DEBIAN_FRONTEND=noninteractive
apt-get -y install libdvd-pkg  
# reconfigure to make libdvdread4 working
dpkg-reconfigure libdvd-pkg 

## VLC - Player
## Audacity
apt-get -y install vlc audacity

