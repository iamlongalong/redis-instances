#!/bin/bash
docker network create --subnet=172.18.0.0/16 longredis 
docker-compose up -d