#!/bin/bash
cd /init-scripts
source ./setenv.sh

mkdir -p /shared
echo $GIT_PASSWORD > /shared/GIT_PASSWORD
echo $PATH > /shared/PATH
chmod -R +r /shared

usermod --password $ROOT_PASSWORD root
if id "USER_NAME" &>/dev/null; then
  echo "USER $USER_NAME already exists"
else
  useradd -ms /bin/bash "$USER_NAME"
fi
if [ -d "/workspace" ] ; then
  chmod 777 /workspace
fi
su - $USER_NAME /init-scripts/user_config.sh
if [ -f "/init-scripts/user_install.sh" ] ; then
  su - $USER_NAME /init-scripts/user_install.sh
fi

rm -rf /shared
