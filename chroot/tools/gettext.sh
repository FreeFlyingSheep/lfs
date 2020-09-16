#!/bin/bash
set -e

tar -xf gettext-0.21.tar.xz
pushd gettext-0.21

# 准备编译 Gettext
./configure --disable-shared

# 编译 Gettext
make

# 安装 msgfmt，msgmerge，以及 xgettext 这三个程序
cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin

popd
rm -rf gettext-0.21
