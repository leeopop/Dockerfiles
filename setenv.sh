#!/bin/bash
if [ ! -f .env ]; then
    touch .env
fi
if [ ! -f .services ]; then
    touch .services
fi
export $(grep -v '^#' .env | xargs)
export SERVICE_LIST=`cat .services`
