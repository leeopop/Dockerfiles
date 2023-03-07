#!/bin/bash
if [[ ! -f .env ]]; then
USER_NAME=${USER_NAME:-${USER}}
if [[ -z "${ROOT_PASSWORD}" ]]; then
    ROOT_PASSWORD=`mkpasswd`
fi
if [[ -z "${SERVICE_HOST}" ]]; then
    LOCAL_IP_LIST=(`/sbin/ifconfig ${IFACE_NAME} | grep "inet " | awk '{print $2}'`)
    SERVICE_HOST=${LOCAL_IP_LIST[0]}
fi
cat > .env <<EOF
USER_NAME=$USER_NAME
SERVICE_HOST=$SERVICE_HOST
GIT_PASSWORD=$GIT_PASSWORD
EOF
fi
if [[ ! -f .password ]]; then
cat > .password <<EOF
$ROOT_PASSWORD
EOF
fi
