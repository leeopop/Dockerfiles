#!/bin/bash
cd /init-scripts
source ./setenv.sh

su - $USER_NAME /init-scripts/link_workspace.sh
/init-scripts/sshd.sh
