## 说明

这是为了本地测试 redis cluster 而使用 docker-compose 启动的 6 节点 redis cluster。

使用方式：
1. 先执行 `./prepare.sh` ，这是为了准备 config 文件和 data 目录
2. 再执行 `./run.sh`, 这将会启动 6 个 docker 容器，并将端口映射到主机
3. 然后执行 `./cluster.sh`， 这会将 6 个节点组成 3主3从 的集群
4. 当你确认不再使用后，使用 `./remove.sh` 删掉所有信息

redis 使用的官方的 6.0 版本。

组建好集群后，对集群进行验证：
```shell
redis-cli -c cluster info
redis-cli -c cluster nodes
```

如果要自己重新配置 redis.conf, 有以下需要注意：
```text
1. daemonize no    # 这个是 redis 后台运行的配置，docker 启动时不能后台运行，否则容器会退出导致启动失败
2. port ${PORT}    # 为了批量生成 redis.conf ， 使用了 envsubst 来渲染文件，如果使用不同 port ，则需要改成这样
3. dir "/data"     # 数据文件存放位置， 对应 docker-compose 中的 volume 挂载
4. logfile "/data/redis.log"  # 日志文件
5. bind "0.0.0.0"  # 需要暴露 port ，否则会组建集群失败
6. cluster‐enabled yes  # 集群模式需要打开该配置
7. cluster‐config‐file nodes.conf  # 集群信息文件，改不改名都可以，但默认为 nodes-6379.conf 容易误导
8. protected‐mode no  # 要外部访问，就需要把该模式关掉
9. appendonly yes   # 开启 aof 模式
```


由于 mac 上无法直接访问 containerIP , 也无法使用 host network，可以参考 https://github.com/docker/for-mac/issues/2670 ， 所以在 mac 上很难搞啊。


## TODO
既然做了 redis-cluster 的本地集群组建，那么回头再增加一些其他类型的资源组建，为他人学习、测试等提供便利。
- [ ] redis-sentinel 组建
- [ ] redis 主从组建 
- [ ] k8s 下的 redis 搭建
- [ ] k8s 下的 redis-cluster 搭建
- [ ] 增加 redis 性能测试的实验
