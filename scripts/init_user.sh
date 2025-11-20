#!/bin/bash
# This script runs as root to initialize user account and environment
cd /init-scripts
source ./setenv.sh

mkdir -p /shared_env
echo $GIT_PASSWORD > /shared_env/GIT_PASSWORD
chmod -R +r /shared_env

usermod --password "${ROOT_PASSWORD}" root
if id ${USER_NAME} &>/dev/null; then
  echo "USER ${USER_NAME} already exists"
else
  useradd -ms /bin/bash ${USER_NAME}
  # Enable passwordless sudo for the user
  usermod -a -G sudo ${USER_NAME}
  echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
fi

# Copy anything in .configs/ to the user's home directory
# For example, .configs/.ssh/authorized_keys will be copied to /home/USER_NAME/.ssh/authorized_keys
if [ -d "/init-scripts/.configs" ]; then
  cp -r /init-scripts/.configs/. /home/${USER_NAME}/
  chown -R ${USER_NAME}:${USER_NAME} /home/${USER_NAME}/
fi

(
cat /init-scripts/init_user_config.sh
if [ -d /install-scripts ]; then
  for script in $(ls /install-scripts/* 2>/dev/null | sort); do
    [ -f "$script" ] && cat "$script"
  done
fi
) | su - ${USER_NAME}

rm -rf /shared_env
