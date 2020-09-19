#!/bin/bash
set -e

DIR=~/scripts/toolchain
LOG_DIR=${LFS}/sources/log/lfs/toolchain

mkdir -p ${LOG_DIR}

# 指定并行构建数目
export MAKEFLAGS='-j8'

cd $LFS/sources

tools=(
  'Binutils-2.35 - 第一遍'
  'GCC-10.2.0 - 第一遍'
  'Linux-5.8.5 API 头文件'
  'Glibc-2.32'
)

dirs=(
  binutils-2.35
  gcc-10.2.0
  linux-5.8.3
  glibc-2.32
)

for i in ${!tools[@]}
do
  echo "构建 ${tools[i]}……"
  tar -xf ${dirs[i]}.tar.*
  pushd ${dirs[i]} > /dev/null
  time bash ${DIR}/${dirs[i]}.sh > ${LOG_DIR}/${dirs[i]}.log 2>&1
  popd > /dev/null
  rm -rf ${dirs[i]}
  echo -e "构建 ${tools[i]} 完成！\n"
done

# 确认新工具链的各基本功能 (编译和链接) 能如我们所预期的那样工作
echo 'int main(){}' > dummy.c
$LFS_TGT-gcc dummy.c
MSG=`readelf -l a.out | grep '/ld-linux'`
echo "$MSG" | grep -q '[Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]'
rm dummy.c a.out
unset MSG

# 现在我们的交叉工具链已经构建完成，可以完成 limits.h 头文件的安装
$LFS/tools/libexec/gcc/$LFS_TGT/10.2.0/install-tools/mkheaders

# Libstdc++ 是 GCC 的一部分，考虑到文件重名问题，把脚本名改为 libstdcpp-10.2.0.sh
echo "构建 GCC-10.2.0 中的 Libstdc++，第一遍……"
tar -xf gcc-10.2.0.tar.*
pushd gcc-10.2.0 > /dev/null
time bash ${DIR}/libstdcpp-10.2.0.sh > ${LOG_DIR}/libstdcpp-10.2.0.log 2>&1
popd > /dev/null
rm -rf gcc-10.2.0 
echo -e "构建 GCC-10.2.0 中的 Libstdc++，第一遍 完成！\n"
