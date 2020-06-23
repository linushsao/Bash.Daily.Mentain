#!/bin/bash
#
FOLDER=$1
rsync -avhr --exclude '.*' --progress linus@192.168.50.104:${FOLDER} ${FOLDER}

