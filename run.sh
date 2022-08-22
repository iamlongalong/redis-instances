#!/bin/bash
docker network create --subnet=172.18.0.0/24 longredis 
docker-compose up -d