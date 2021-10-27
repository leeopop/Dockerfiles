#!/bin/bash
cd /init-scripts
source ./setenv.sh

/init-scripts/init_user.sh
/init-scripts/sshd.sh
