#!/bin/bash
mkdir -p /shared
echo $GIT_PASSWORD > /shared/GIT_PASSWORD
chmod -R +r /shared

usermod --password $ROOT_PASSWORD root
if id "USER_NAME" &>/dev/null; then
    echo "USER $USER_NAME already exists"
else
    useradd -ms /bin/bash "$USER_NAME"
fi
su - $USER_NAME /init-scripts/user_config.sh

rm -rf /shared
