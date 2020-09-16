#!/bin/bash
set -e

tar -xf m4-1.4.18.tar.xz
pushd m4-1.4.18

# 进行 glibc-2.28 要求的一些修补
sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h

# 准备编译 M4
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

# 编译 M4
make

# 安装 M4
make DESTDIR=$LFS install

popd
rm -rf m4-1.4.18
