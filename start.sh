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

# For caching purpose
docker build . -f template/Dockerfile.pre

$COMPOSE up -d --build ${SERVICE_LIST}
