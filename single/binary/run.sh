#!/bin/bash
if [ ! -d "./data" ]; then
    mkdir ./data
fi

redis-server redis.conf