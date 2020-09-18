#!/bin/bash
set -e

# 重新安装 Readline 会导致旧版本的库被重命名为 <库名称>.old
# 这一般不是问题，但某些情况下会触发 ldconfig的一个链接 bug
# 运行下面的两条 sed 命令防止这种情况
sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install

# 准备编译 Readline
./configure --prefix=/usr    \
            --disable-static \
            --with-curses    \
            --docdir=/usr/share/doc/readline-8.0

# 编译 Readline
make SHLIB_LIBS="-lncursesw"

# 安装 Readline
make SHLIB_LIBS="-lncursesw" install

# 下面将动态库移动到更合适的位置，并修正访问权限和符号链接
mv -v /usr/lib/lib{readline,history}.so.* /lib
chmod -v u+w /lib/lib{readline,history}.so.*
ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so
ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so

# 安装文档
install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-8.0
