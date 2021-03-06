#!/bin/bash

# 环境变量
# 根目录
export BASEDIR="/tank1/testnet_tmp"

# 矿工地址
export FILECOIN_MINER_ACTOR="t0123220"
export FILECOIN_MINER_ADDRESS="t3rgzprn44ljcwa5cj6hiafkplntcf3at7u3yjifzwjl6feesw553vxldj2snwwh3xapyv4jikaw3oevsouata"

# ~/.lotusstorage 中的 token
export STORAGE_TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.F576UsCR-K0j5M6qWQIo3h8mnD9ulihEg9-3dxyRSyw"
# ~/.lotusstorage 中的 api
export STORAGE_API="/ip4/10.0.1.148/tcp/2345/http"
# 用于worker 链接miner配置
export STORAGE_API_INFO="${STORAGE_TOKEN}:${STORAGE_API}"

# 存储空间
export LOTUS_PATH="${BASEDIR}/.lotus"
export WORKER_PATH="${BASEDIR}/.lotusworker"
export LOTUS_STORAGE_PATH="${BASEDIR}/.lotusstorage"
export IPFS_GATEWAY="https://proof-parameters.s3.cn-south-1.jdcloud-oss.com/ipfs/"
export TMPDIR="${BASEDIR}/tmpdir"

# 运行参数 优化计算
export FIL_PROOFS_PARAMETER_CACHE="${BASEDIR}/proof-parameters"
export FIL_PROOFS_MAXIMIZE_CACHING=1
export FIL_PROOFS_USE_GPU_TREE_BUILDER=1
export FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1
export RUST_LOG=Trace

# 修改ulimit
ulimit -n 655350

LOCAL_IP=$(ip route get 1.2.3.4 | awk '{print $7}')
TIME_STR=$(date "+%Y%m%d%H%M%S")

function daemon() {
  echo "run lotus daemon"
  nohup lotus daemon >lotus-daemon_$TIME_STR.log 2>&1 &
  echo $! > daemon_run.pid
}

function miner_init() {
  echo "init lotus miner"
  nohup lotus-storage-miner init --actor=$FILECOIN_MINER_ACTOR --owner=$FILECOIN_MINER_ADDRESS >lotus-miner-init_$TIME_STR.log 2>&1 &
  echo $! > miner_init.pid
}

function miner_run() {
  echo "run lotus miner"
  nohup lotus-storage-miner run >lotus-miner-run_$TIME_STR.log 2>&1 &
  echo $! > miner_run.pid
}

function worker_run() {
  echo "run lotus worker"
  nohup lotus-seal-worker run --address="$LOCAL_IP":2346 >lotus-miner-worker_$TIME_STR.log 2>&1 &
  echo $! > worker_run.pid
}

function stop_all() {
  if [ -f "daemon_run.pid" ]; then
    echo "stop lotus daemon"
    kill 9 $(cat daemon_run.pid)
  fi
  if [ -f "miner_run.pid" ]; then
    echo "stop lotus miner"
    kill 9 $(cat miner_run.pid)
  fi
  if [ -f "worker_run.pid" ]; then
    echo "stop lotus worker"
    kill 9 $(cat worker_run.pid)
  fi
}

case $1 in
    'daemon')
        daemon
        ;;
    'miner_init')
        miner_init
        ;;
    'miner_run')
        miner_run
        ;;
    'worker_run')
        worker_run
        ;;
    'stop_all')
        stop_all
        ;;
    *)
        # shellcheck disable=SC2016
        echo 'Get invalid option, please input(as to $1):'
        echo -e '\t"daemon" -> run lotus daemon'
        echo -e '\t"miner_init"  -> init lotus miner'
        echo -e '\t"miner_run"  -> run lotus miner'
        echo -e '\t"worker_run"  -> run lotus worker'
        echo -e '\t"stop_all"  -> stop lotus daemon miner worker'
  exit 1
esac