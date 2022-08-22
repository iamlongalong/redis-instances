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

## docker 网络
docker 网络有几种模式，默认的是 bridge 模式，这种模式下，所有容器网络均由 docker0 这个网桥分配，容器相互访问可以通过 docker0 网桥转发。 一种是 host 网络，用的是主机网卡。 一种是 容器网络，可以多个容器共用一个网络空间，k8s 的 pause 容器就起这个作用。还有 overlay 网络、自定义网络(自定义的ip段等)。
我们最常用的是 bridge 网络，但这样有个问题，ip 的变动会导致一些有状态服务出问题。 于是，其中一种解决方法是 `--link` 模式，类似于给一个网络空间下加入了 `服务名` ，可以解析到对应的 ip，但这种方式用起来比较麻烦。 另一种解决方案是 自定义网络，在指定了 subnet 之后，可以指定特定的 ip ，也可以指定 服务名，在存在多个服务时，是很常用的方式。

在 redis-cluster 的场景中，我们有两个需求： ① 每个 redis 实例之间均可以通信  ② 外部能访问每个 redis 实例。 前者是为了组集群，后者是为了外部访问。
这两个条件，有如下方案可行：
1. 直接使用 host network，每个 redis 实例使用不同端口。
2. 直接使用 bridge 网络，通过 ip 访问，为了保证 脚本的确定性，可以使用自定义网络，并且指定 ip。

这两种方案在 linux 下均可。

在 mac 上，由于实现方式的不同， mac 上无法直接访问 containerIP , 也无法使用 host network，可以参考 https://github.com/docker/for-mac/issues/2670 ， 所以在 mac 上就行不通了。
为了直接使用主机网络，有四种方案可以尝试：
1. 直接在宿主机上运行 redis 进程，并使用不同端口。
2. 使用 `-p` 暴露端口，并配置 subnet 指定容器 ip 和宿主机相同(多个容器共用，或者封装特定的多redis进程的镜像)。
3. 配置 ss 进行代理，对特定网段的网络请求转发到由 ss 代理的 docker 网络中。
4. 修改 redis-cluster 的组集群 ip 获取，改由环境变量传入。

这几种方式权衡下来，还是觉得直接在宿主机上运行 redis-cluster 的成本最低。


## TODO
既然做了 redis-cluster 的本地集群组建，那么回头再增加一些其他类型的资源组建，为他人学习、测试等提供便利。
- [ ] redis-sentinel 组建
- [ ] redis 主从组建 
- [ ] k8s 下的 redis 搭建
- [ ] k8s 下的 redis-cluster 搭建
- [ ] 增加 redis 性能测试的实验

