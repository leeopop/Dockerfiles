#!/bin/bash
if [[ ! -f .env ]]; then
USER_NAME=${USER_NAME:-${USER}}
if [[ ! -f .password ]]; then
    ROOT_PASSWORD=`mkpasswd`
else
    ROOT_PASSWORD=`cat .password`
fi
if [[ -z "${SERVICE_HOST}" ]]; then
    LOCAL_IP_LIST=(`/sbin/ifconfig ${IFACE_NAME} | grep "inet " | awk '{print $2}'`)
    SERVICE_HOST=${LOCAL_IP_LIST[0]}
fi

BASE_IMAGE=${BASE_IMAGE:-debian:latest}

cat > .env <<EOF
USER_NAME=$USER_NAME
SERVICE_HOST=$SERVICE_HOST
GIT_PASSWORD=$GIT_PASSWORD
BASE_IMAGE=$BASE_IMAGE
EOF
fi

if [[ ! -f .password ]]; then
cat > .password <<EOF
$ROOT_PASSWORD
EOF
fi

# Prepare .configs directory
if [[ ! -d .configs ]]; then
    mkdir -p .configs

    # Collect SSH public keys and create authorized_keys
    if ls ~/.ssh/*.pub 1> /dev/null 2>&1; then
        mkdir -p .configs/.ssh
        cat ~/.ssh/*.pub > .configs/.ssh/authorized_keys
    fi

    # Copy gitconfig if it exists
    if [ -f ~/.gitconfig ]; then
        cp ~/.gitconfig .configs/.gitconfig
    fi
fi
