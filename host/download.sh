#!/bin/bash
set -e

echo "下载软件包……"
# 下载 lfs-packages-10.0.tar
wget -c http://ftp.lfs-matrix.net/pub/lfs/lfs-packages/lfs-packages-10.0.tar

echo "解包……"
# 软件包目录
mkdir -pv $LFS/sources
# 解包至 $LFS/sources
tar xvf lfs-packages-10.0.tar -C $LFS/sources

pushd $LFS/sources
# 处理多余的 10.0 目录
mv 10.0/* . 
rmdir 10.0

echo "检查软件包"
md5sum -c md5sums
popd
