#!/bin/bash
set -e

# 使构建系统不安装一个 configure 脚本未处理的静态库
sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in

# 准备编译 Ncurses
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-normal        \
            --enable-pc-files       \
            --enable-widec

# 编译 Ncurses
make

# 安装 Ncurses
make install

# 将共享库移动到期望的 /lib 目录
mv -v /usr/lib/libncursesw.so.6* /lib

# 重新创建一个符号链接
ln -sfv ../../lib/$(readlink /usr/lib/libncursesw.so) /usr/lib/libncursesw.so

# 许多程序仍然希望链接器能够找到非宽字符版本的 Ncurses 库
# 通过使用符号链接和链接脚本，诱导它们链接到宽字符库
for lib in ncurses form panel menu ; do
    rm -vf                    /usr/lib/lib${lib}.so
    echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc        /usr/lib/pkgconfig/${lib}.pc
done

# 确保那些在构建时寻找 -lcurses 的老式程序仍然能够构建
rm -vf                     /usr/lib/libcursesw.so
echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
ln -sfv libncurses.so      /usr/lib/libcurses.so

# 安装 Ncurses 文档
mkdir -v       /usr/share/doc/ncurses-6.2
cp -v -R doc/* /usr/share/doc/ncurses-6.2

# 上述指令没有创建非宽字符的 Ncurses 库，因为从源码编译的软件包不会在运行时链接到它
# 然而，已知的需要链接到非宽字符 Ncurses 库的二进制程序都需要版本 5。
# 如果您为了满足一些仅有二进制版本的程序，或者满足 LSB 兼容性，必须安装这样的库
# 再次构建 Ncurses
make distclean
./configure --prefix=/usr    \
            --with-shared    \
            --without-normal \
            --without-debug  \
            --without-cxx-binding \
            --with-abi-version=5 
make sources libs
cp -av lib/lib*.so.5* /usr/lib
