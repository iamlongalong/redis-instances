#!/bin/bash 

for port in $(seq 6379 6384); do
    mkdir -p ./config/"${port}" \
    && PORT=${port} envsubst < redislocal.conf > ./config/"${port}"/redis.conf \
    && mkdir -p data/"${port}" 
done
