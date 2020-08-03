#!/usr/bin/env bash

# 根目录
BASEDIR="/tank1/testnet_tmp"

# 矿工地址
export FILECOIN_MINER_ACTOR="t0123220"
export FILECOIN_MINER_ADDRESS="t3rgzprn44ljcwa5cj6hiafkplntcf3at7u3yjifzwjl6feesw553vxldj2snwwh3xapyv4jikaw3oevsouata"

# ~/.lotusstorage 中的 token
STORAGE_TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.F576UsCR-K0j5M6qWQIo3h8mnD9ulihEg9-3dxyRSyw"
# ~/.lotusstorage 中的 api
STORAGE_API="/ip4/10.0.1.148/tcp/2345/http"
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
