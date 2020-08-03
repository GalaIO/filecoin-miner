# FileCoin-miner

## Docker镜像
docker镜像主要有2种，一个是编译环境镜像，准备的golang和rust，以及master的依赖环境，依赖可能会随时变；
第二种是执行镜像，会根据分支来编译程序，随后直接输出docker环境，这个是执行镜像，会打包一些配置、脚本和必须要的程序；

>注意：这是使用的个人的docker hub仓库，自己可以修改为其他的；

#### 编译环境镜像
文件`Dockerfile_compiler`，执行构建`docker build -t galaio/filecoin-compiler:1.0.0 -f Dockerfile_compiler .`，生成docker镜像，上传到仓库`docker push galaio/filecoin-compiler:1.0.0`，默认使用docker hub；
基础镜像包括golang、rust的编译环境，以及master代码的依赖下载；

>注意：需要启动coker daemon，并且docker login账户；

### 编译运行镜像
文件`Dockerfile`，可以根据build的参数决定编译那个版本，执行构建`docker build --build-arg BRANCH=ntwk-calibration -t galaio/filecoin-calibration .`；
运行镜像包括所有可执行程序、启动脚本、必要程序；

## 运行
部署时候根据实际的需求有不同的启动场景，简单主要包括daemon启动、miner启动，daemon+miner启动，worker启动；
部署推荐使用docker-compose方式，配置和启动都非常方便，其中比较复杂的是环境变量和入参；

#### 启动daemon+miner
- 首先需要准备好矿工账户：
```bash
# 生成矿工账户
# 启动lotus，只是生产账户不需要等待同步区块
nohup lotus daemon
# 生成account。需要去 https://faucet.testnet.filecoin.io/ 领取测试币和创建矿工账户
lotus wallet new bls

生成矿工actor
目前是在水龙头生成，获取actor 比如t3012128
```

- 初始化miner
```bash
lotus-storage-miner init --actor=$FILECOIN_MINER_ACTOR --owner=$FILECOIN_MINER_ADDRESS

# 如果miner和worker不在一台机器，需要配置miner的IP
# 取消ListenAddress和RemoteListenAddress前面的注释，并将它们的IP改成局域网IP
vi $LOTUS_STORAGE_PATH/config.toml
```

#### 启动worker

## 部署
部署会使用多种工具，ansible用于集群配置和启动，supervisord用于程序重启，prometheus用于集群监控(任务执行情况)。

#### Ansible配置 TODO
ansible有miner配置的模板，会自动填充ip api token

#### supervisord配置 TODO

#### prometheus配置 TODO


