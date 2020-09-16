#!/bin/bash
set -e

tar -xf ncurses-6.2.tar.gz
pushd ncurses-6.2

# 保证在配置时优先查找 gawk 命令
sed -i s/mawk// configure

# 在宿主系统构建 tic 程序
mkdir build
pushd build
../configure
make -C include
make -C progs tic
popd

# 准备编译 Ncurses
./configure --prefix=/usr                \
            --host=$LFS_TGT              \
            --build=$(./config.guess)    \
            --mandir=/usr/share/man      \
            --with-manpage-format=normal \
            --with-shared                \
            --without-debug              \
            --without-ada                \
            --without-normal             \
            --enable-widec

# 编译 Ncurses
make

# 安装 Ncurses
make DESTDIR=$LFS TIC_PATH=$(pwd)/build/progs/tic install
echo "INPUT(-lncursesw)" > $LFS/usr/lib/libncurses.so

# 将共享库移动到它们应该位于的 /lib 目录中
mv -v $LFS/usr/lib/libncursesw.so.6* $LFS/lib

# 重新生成符号链接
ln -sfv ../../lib/$(readlink $LFS/usr/lib/libncursesw.so) $LFS/usr/lib/libncursesw.so

popd
rm -rf ncurses-6.2
