#!/bin/bash
set -e

tar -xf linux-5.8.3.tar.xz
pushd linux-5.8.3

# 确保软件包中没有遗留陈旧的文件
make mrproper

# 从源代码中提取用户可见的头文件
# 头文件会先被放置在 ./usr 目录中，之后再将它们复制到最终的位置。
make headers
find usr/include -name '.*' -delete
rm usr/include/Makefile
cp -rv usr/include $LFS/usr

popd
rm -rf linux-5.8.3
