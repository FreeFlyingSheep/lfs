#!/bin/bash
set -e

# 应用一个补丁，以安装 Bzip2 的文档
patch -Np1 -i ../bzip2-1.0.8-install_docs-1.patch

# 以下命令保证安装的符号链接是相对的
sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile

# 确保 man 页面被安装到正确位置
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile

# 配置 Bzip2
make -f Makefile-libbz2_so
make clean

# 编译并测试 Bzip2
make

# 安装 Bzip2 中的程序
make PREFIX=/usr install

# 安装链接到共享库的 bzip2 二进制程序到 /bin 目录，创建必要的符号链接，并进行清理
cp -v bzip2-shared /bin/bzip2
cp -av libbz2.so* /lib
ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so
rm -v /usr/bin/{bunzip2,bzcat,bzip2}
ln -sv bzip2 /bin/bunzip2
ln -sv bzip2 /bin/bzcat
