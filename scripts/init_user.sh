#!/bin/bash
cd /init-scripts

mkdir -p /shared_env
echo $GIT_PASSWORD > /shared_env/GIT_PASSWORD
chmod -R +r /shared_env

usermod --password $ROOT_PASSWORD root
if id "USER_NAME" &>/dev/null; then
  echo "USER $USER_NAME already exists"
else
  useradd -ms /bin/bash "$USER_NAME"
fi

(
cat /init-scripts/init_user_config.sh
(cat /install-scripts/* 2>/dev/null || true)
) | su - $USER_NAME

rm -rf /shared_env
