#!/bin/bash
set -e

# E2fsprogs 文档推荐在源代码目录树中的一个子目录内构建 E2fsprogs
mkdir -v build
cd       build

# 配置 E2fsprogs
../configure --prefix=/usr           \
             --bindir=/bin           \
             --with-root-prefix=""   \
             --enable-elf-shlibs     \
             --disable-libblkid      \
             --disable-libuuid       \
             --disable-uuidd         \
             --disable-fsck

# 编译 E2fsprogs
make

# 测试 E2fsprogs
# make check

# 安装 E2fsprogs
make install

# 将安装好的静态库变为可写的，以便之后移除调试符号
# chmod -v u+w /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a

# 该软件包安装了一个 gzip 压缩的 .info 文件，却没有更新系统的 dir 文件
# 执行以下命令解压该文件，并更新系统 dir 文件
gunzip -v /usr/share/info/libext2fs.info.gz
install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info

# 创建并安装一些额外的文档
makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo
install -v -m644 doc/com_err.info /usr/share/info
install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info
