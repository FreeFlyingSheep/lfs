#!/bin/bash
set -e

cd /sources

# 指定并行构建数目
export MAKEFLAGS='-j8'

# 构建其他临时工具
bash /sources/scripts/tools.sh

# .la 文件仅在链接到静态库时有用
# 在使用动态共享库时它们没有意义，甚至有害，特别是对于非 autotools 构建系统
# 运行命令删除它们
find /usr/{lib,libexec} -name \*.la -delete

# 删除临时工具的文档，以防止它们进入最终构建的系统
rm -rf /usr/share/{info,man,doc}/*

# 自动构建 LFS，没有必要备份临时系统，因此不需要退出 Chroot
# exit
# umount $LFS/dev{/pts,}
# umount $LFS/{sys,proc,run}
# ...

# 安装基本系统软件
bash /sources/scripts/softwares.sh
