#!/bin/bash
docker-compose down && \
rm -rf config && rm -rf data && \
docker network rm longredis