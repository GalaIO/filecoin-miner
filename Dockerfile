FROM galaio/filecoin-compiler:1.0.0 AS builder

# 指定分支名，可以build时指定
# docker image build --build-arg BRANCH=$(BRANCH) -t openworklabs/lotus:$(BRANCH)
ARG BRANCH=master

# 下载代码 并编译
RUN git clone https://github.com/filecoin-project/lotus.git && \
cd lotus && \
git checkout $BRANCH && \
# v26/v27 版本代码的编译命令:
# 启用 GPU 相关环境变量【Precommit2 的时候可以使用 GPU 计算】
env RUSTFLAGS="-C target-cpu=native -g" FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1 FIL_PROOFS_USE_GPU_TREE_BUILDER=1 FFI_BUILD_FROM_SOURCE=1 make clean deps all bench && \
mkdir bin && \
cp lotus lotus-seal-worker lotus-storage-miner bin/


FROM ubuntu:18.04 AS testing

# 基础信息
ENV APP_NAME=lotus
ENV HOME=/root
WORKDIR $HOME

# 复制
COPY config/scripts /home/root/
COPY --from=builder /home/root/lotus/bin /usr/local/lotus/
ENV PATH $PATH:/usr/local/lotus/bin

# 安装必要程序
RUN apt update && \
apt -y install apache2-utils && \
pip install supervisor

ENTRYPOINT ["run.sh"]
CMD ["daemon"]
