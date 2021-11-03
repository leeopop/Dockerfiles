#!/bin/bash
cd /init-scripts
source ./setenv.sh

# Node image 는 username 고정
export USER_NAME=node

if [ -d "/workspace" ] ; then
  chmod 777 /workspace
fi

su - $USER_NAME /init-scripts/link_workspace.sh
/init-scripts/sshd.sh
