#!/bin/bash
cd /init-scripts
source ./setenv.sh

mkdir -p /shared
echo $GIT_PASSWORD > /shared/GIT_PASSWORD
chmod -R +r /shared

usermod --password $ROOT_PASSWORD root
useradd -ms /bin/bash "$USER_NAME"
su - $USER_NAME /init-scripts/user_config.sh

rm -rf /shared

mkdir -p /run/sshd
/usr/sbin/sshd -D
