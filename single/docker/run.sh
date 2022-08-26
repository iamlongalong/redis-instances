#!/bin/bash
if [ ! -d "./data" ]; then
    mkdir ./data
fi


# docker run -itd -p 6379:6379 -v "$(pwd)"/redis.conf:/usr/local/etc/redis/redis.conf -v "$(pwd)"/data:/data redis:6.0 "redis-server" "/usr/local/etc/redis/redis.conf"
docker-compose up -d 