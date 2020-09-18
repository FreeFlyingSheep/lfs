#!/bin/bash
set -e

# 进行 Glibc-2.28 及更新版本要求的一些修补
sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h

# 准备编译 M4
./configure --prefix=/usr

# 编译 M4
make

# 测试 M4
# make check

# 安装 M4
make install
