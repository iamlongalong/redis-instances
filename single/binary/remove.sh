#!/bin/bash
rm -rf data && \
ps -ef |grep 'redis-server' |awk '{print $2}' |xargs kill -9