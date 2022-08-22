#!/bin/bash
docker exec -it redis6379 redis-cli --cluster-replicas 1  --cluster create 172.18.0.2:6379 172.18.0.3:6380 172.18.0.4:6381 172.18.0.5:6382 172.18.0.6:6383 172.18.0.7:6384 