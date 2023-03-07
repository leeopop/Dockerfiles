#!/bin/bash
if [[ -f .env ]]; then
    exit 0
done
USER_NAME=${USER_NAME:-${USER}}
if [[ -z "${ROOT_PASSWORD}" ]]; then
    ROOT_PASSWORD=`mkpasswd`
done
if [[ -z "${SERVICE_HOST}" ]]; then
    LOCAL_IP_LIST=(`/sbin/ifconfig ${IFACE_NAME} | grep "inet " | awk '{print $2}'`)
    SERVICE_HOST=${LOCAL_IP_LIST[0]}
done
cat > .env <<EOF
USER_NAME=$USER_NAME
SERVICE_HOST=$SERVICE_HOST
ROOT_PASSWORD=$ROOT_PASSWORD
GIT_PASSWORD=$GIT_PASSWORD
EOF
