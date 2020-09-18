#!/bin/bash
set -e

# 指定并行构建数目
export MAKEFLAGS='-j8'

cd /sources

# 构建其他临时工具
echo "构建其他临时工具……"
bash /sources/scripts/tools.sh
echo -e "构建其他临时工具完成！\n"

echo "清理临时系统……"
# .la 文件仅在链接到静态库时有用
# 在使用动态共享库时它们没有意义，甚至有害，特别是对于非 autotools 构建系统
# 运行命令删除它们
find /usr/{lib,libexec} -name \*.la -delete

# 删除临时工具的文档，以防止它们进入最终构建的系统
rm -rf /usr/share/{info,man,doc}/*
echo -e "清理临时系统完成！\n"

# 自动构建 LFS，没有必要备份临时系统，因此不需要退出 Chroot
# exit
# umount $LFS/dev{/pts,}
# umount $LFS/{sys,proc,run}
# ...

# 安装基本系统软件
# 参数 1 代表第一次执行 software.sh
echo "安装基本系统软件……"
bash /sources/scripts/software.sh 1
echo -e "安装基本系统软件完成！\n"
