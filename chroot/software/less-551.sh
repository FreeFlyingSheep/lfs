#!/bin/bash
set -e

# 准备编译 Less
./configure --prefix=/usr --sysconfdir=/etc

# 编译 Less
make

# 安装 Less
make install
