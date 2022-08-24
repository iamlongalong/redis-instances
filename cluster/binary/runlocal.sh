#!/bin/bash
for port in $(seq 6379 6384); do
redis-server config/${port}/redis.conf
done