#!/bin/bash
set -e

# 准备编译 Psmisc
./configure --prefix=/usr

# 编译 Psmisc
make

# 安装 Psmisc
make install

# 移动 killall 和 fuser 到 FHS 指定的位置
mv -v /usr/bin/fuser   /bin
mv -v /usr/bin/killall /bin
