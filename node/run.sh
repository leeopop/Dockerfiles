#!/bin/bash
cd /init-scripts
source ./setenv.sh

# Node image 는 username 고정
USER_NAME=node

su - $USER_NAME /init-scripts/link_workspace.sh
/init-scripts/sshd.sh
