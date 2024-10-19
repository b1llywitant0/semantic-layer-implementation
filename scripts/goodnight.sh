#!/bin/bash
if [[   $(docker ps --filter name=finpro* -aq) ]]; then
    echo 'Stopping Container...'
    docker ps --filter name=finpro* -aq | xargs docker stop
    echo 'All Container Stopped...'
    echo 'Removing Container...'
    docker ps --filter name=finpro* -aq | xargs docker rm
    echo 'All Container Removed...'
    docker network inspect finpro-network 2>nul
else
    echo "All Cleaned UP!"
fi