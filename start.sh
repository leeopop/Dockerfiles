#!/bin/bash
source setenv.sh
PATH="/usr/bin:/bin:/sbin:/usr/local/bin:$PATH"

COMPOSE="docker compose"
docker compose version
if [[ $? -eq 0 ]]; then
    echo "Compose plugin detected"
else
    echo "Fallback to docker-compose"
    COMPOSE=docker-compose
fi

./generate.sh
$COMPOSE build ${SERVICE_LIST}
$COMPOSE up -d ${SERVICE_LIST}
