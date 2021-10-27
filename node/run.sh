#!/bin/bash
cd /init-scripts
source ./setenv.sh

# Node image 는 username 고정
USER_NAME=node

/init-scripts/init_user.sh
/init-scripts/sshd.sh
