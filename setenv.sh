#!/bin/bash
if [ ! -f .env ]; then
    touch .env
fi
if [ ! -f .services ]; then
    touch .services
fi
if [ ! -f .password ]; then
    touch .password
fi
export $(grep -v '^#' .env | xargs)
export SERVICE_LIST=`cat .services`
export ROOT_PASSWORD=`cat .password`
