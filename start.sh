#!/bin/bash
source setenv.sh
PATH="/usr/bin:/bin:/sbin:/usr/local/bin:$PATH"

docker-compose build ${SERVICE_LIST}
docker-compose up -d ${SERVICE_LIST}
echo "Waiting 30 sec for docker-compose to be finished..."
sleep 30
