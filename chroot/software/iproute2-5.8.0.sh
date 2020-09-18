#!/bin/bash
set -e

# 该软件包中的 arpd 程序依赖于 LFS 不安装的 Berkeley DB，因此不会被构建
# 然而，用于 arpd 的一个目录和它的 man 页面仍会被安装
# 运行以下命令以防止它们的安装
sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8

# 还需要禁用两个模块
sed -i 's/.m_ipt.o//' tc/Makefile

# 编译 IPRoute2
make

# 安装 IPRoute2
make DOCDIR=/usr/share/doc/iproute2-5.8.0 install
