#!/bin/bash
rm -rf config && rm -rf data && \
ps -ef |grep 'redis-server' |awk '{print $2}' |xargs -n 1 kill