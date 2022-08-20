#!/bin/bash
cd /init-scripts
source ./setenv.sh

if [ -d "/workspace" ] ; then
  chmod 777 /workspace
fi

su - $USER_NAME /init-scripts/link_workspace.sh
/init-scripts/sshd.sh
