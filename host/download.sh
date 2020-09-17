#!/bin/bash
set -e

# 软件包目录
mkdir -pv $LFS/sources
# 下面为该目录添加写入权限和 sticky 标志
# Sticky 标志使得即使有多个用户对该目录有写入权限，也只有文件所有者能够删除其中的文件
chmod -v a+wt $LFS/sources

# 下载 lfs-packages-10.0.tar
echo "下载软件包……"
wget -c https://mirror-hk.koddos.net/lfs/lfs-packages/lfs-packages-10.0.tar

# 解包至 $LFS/sources
echo "解包……"
tar -xf lfs-packages-10.0.tar -C $LFS/sources

pushd $LFS/sources
# 处理多余的 10.0 目录
mv 10.0/* . 
rmdir 10.0

echo "检查软件包"
md5sum -c md5sums
popd
