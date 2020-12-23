#!/bin/bash

# apt-get -y update

# quiet installation
# install MS-teams for linux
. /etc/default/laus-setup

SOURCE_PATH=$MOUNT_PATH_ON_CLIENT/xBigFiles

apt-get -y install $SOURCE_PATH/Zoom/zoom_amd64.deb
