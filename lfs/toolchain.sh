#!/bin/bash
set -e

echo "编译交叉工具链……"

bash ~/script/toolchain/binutils.sh
bash ~/script/toolchain/gcc.sh
bash ~/script/toolchain/linux-headers.sh
bash ~/script/toolchain/glibc.sh

# 确认新工具链的各基本功能 (编译和链接) 能如我们所预期的那样工作
echo 'int main(){}' > dummy.c
$LFS_TGT-gcc dummy.c
MSG1=`readelf -l a.out | grep '/ld-linux'`
MSG2='[Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]'
if [ $MSG1 != $MSG2 ]; then
  echo "交叉编译工具错误！"
  exit 1
fi
rm -v dummy.c a.out

# 现在我们的交叉工具链已经构建完成，可以完成 limits.h 头文件的安装
$LFS/tools/libexec/gcc/$LFS_TGT/10.2.0/install-tools/mkheaders

bash ~/script/toolchain/libstd.sh
