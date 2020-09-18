#!/bin/bash
set -e

# 修复一个失败的测试
# sed -i "s/''/etags/" t/tags-lisp-space.sh

# 配置 Automake
./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.16.2

# 编译 Automake
make

# 由于单个测试点中存在的内部时延，即使仅有一个处理器，也应该使用 make 命令的 -j4 选项加速测试
# 测试 Automake
# make -j4 check

# 安装 Automake
make install
