#!/bin/bash
touch .env
touch .services
export $(grep -v '^#' .env | xargs)
export SERVICE_LIST=`cat .services`
