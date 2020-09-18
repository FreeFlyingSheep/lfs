#!/bin/bash
set -e

# 配置 Gperf
./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.1

# 编译 Gperf
make

# 测试 Gperf
# make -j1 check

# 安装 Gperf
make install
