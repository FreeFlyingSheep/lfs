#!/bin/bash
set -e

# 创建一个 /etc/lfs-release 文件似乎是一个好主意
# 通过使用它，您 (或者我们，如果您向我们寻求帮助的话) 能够容易地找出当前安装的 LFS 系统版本
echo 20200901-systemd > /etc/lfs-release

# 创建一个文件，根据 Linux Standards Base (LSB) 的规则显示系统状态
cat > /etc/lsb-release << "EOF"
DISTRIB_ID="Linux From Scratch"
DISTRIB_RELEASE="20200901-systemd"
DISTRIB_CODENAME="lfs"
DISTRIB_DESCRIPTION="Linux From Scratch"
EOF

# 第二个文件基本上包含相同的信息，systemd 和一些图形桌面环境会使用它
cat > /etc/os-release << "EOF"
NAME="Linux From Scratch"
VERSION="20200901-systemd"
ID=lfs
PRETTY_NAME="Linux From Scratch 20200901-systemd"
VERSION_CODENAME="lfs"
EOF
