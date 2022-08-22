## 说明

这是为了本地测试 redis cluster 而使用 docker-compose 启动的 6 节点 redis cluster。

使用方式：
1. 先执行 `./prepare.sh` ，这是为了准备 config 文件和 data 目录
2. 再执行 `./run.sh`, 这将会启动 6 个 docker 容器，并将端口映射到主机
3. 然后执行 `./cluster.sh`， 这会将 6 个节点组成 3主3从 的集群
4. 当你确认不再使用后，使用 `./remove.sh` 删掉所有信息

redis 使用的官方的 6.0 版本。
