#!/bin/bash
rm -rf config && rm -rf data && \
ps -ef |grep 'redis-server' |awk '{print $2}' |xargs kill -9
# pkill redis-server