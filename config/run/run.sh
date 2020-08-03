#!/usr/bin/env bash

source env.sh
# 修改ulimit
ulimit -n 655350

# 如果不适用中国优化的节点 就不要使用，来回切换有问题
# export IPFS_GATEWAY=https://ipfs.globalupload.io/
# export IPFS_GATEWAY=https://proofs.filecoin.io/ipfs

function daemon() {
  echo "run lotus daemon"
  nohup lotus daemon >lotus-daemon.log 2>&1 &
}

function init() {
  echo "init lotus miner"
  nohup lotus-storage-miner init --actor=$FILECOIN_MINER_ACTOR --owner=$FILECOIN_MINER_ADDRESS >lotus-miner-init.log 2>&1 &
}

function miner_run() {
  echo "run lotus miner"
  nohup lotus-storage-miner run  >lotus-miner-run.log 2>&1 &
}

function worker_run() {
  echo "run lotus worker"
  nohup lotus-seal-worker run --address=127.0.0.1:2346 >lotus-miner-worker.log 2>&1 &
}

case $1 in
    'daemon')
        daemon
        ;;
    'init')
        init
        ;;
    'miner_run')
        miner_run
        ;;
    'worker_run')
        worker_run
        ;;
    *)
        # shellcheck disable=SC2016
        echo 'Get invalid option, please input(as to $1):'
        echo -e '\t"daemon" -> run lotus daemon'
        echo -e '\t"init"  -> init lotus miner'
        echo -e '\t"miner_run"  -> run lotus miner'
  exit 1
esac