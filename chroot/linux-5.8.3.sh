#!/bin/bash
set -e

# 配置 Linux 内核
make mrproper
make defconfig
cp /sources/scripts/x86_64_config .config

# 编译 Linux 内核映像和模块
make

# 安装模块
make modules_install

# 安装 Linux 内核
cp -iv arch/x86/boot/bzImage /boot/vmlinuz-5.8.5-lfs-20200901-systemd

# System.map 是内核符号文件，它将内核 API 的每个函数入口点和运行时数据结构映射到它们的地址
# 它被用于调查分析内核可能出现的问题，现在安装该文件
cp -iv System.map /boot/System.map-5.8.5

# 内核配置文件 .config 包含编译好的内核的所有配置选项
# 最好能将它保留下来以供日后参考
cp -iv .config /boot/config-5.8.5

# 安装 Linux 内核文档
install -d /usr/share/doc/linux-5.8.5
cp -r Documentation/* /usr/share/doc/linux-5.8.5
