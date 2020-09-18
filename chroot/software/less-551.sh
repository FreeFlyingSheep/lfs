#!/bin/bash
set -e

# 配置 Less
./configure --prefix=/usr --sysconfdir=/etc

# 编译 Less
make

# 安装 Less
make install
