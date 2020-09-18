#!/bin/bash
set -e

# 某些 Glibc 程序使用与 FHS 不兼容的 /var/db 目录存放运行时数据
# 应用下列补丁，使得这些程序在 FHS 兼容的位置存储运行时数据
patch -Np1 -i ../glibc-2.32-fhs-1.patch

# Glibc 文档推荐在专用目录中构建它
mkdir -v build
cd build

# 准备编译 Glibc
../configure --prefix=/usr                            \
             --disable-werror                         \
             --enable-kernel=3.2                      \
             --enable-stack-protector=strong          \
             --with-headers=/usr/include              \
             libc_cv_slibdir=/lib

# 编译 Glibc
make

# 测试 Glibc
# case $(uname -m) in
#   i?86)   ln -sfnv $PWD/elf/ld-linux.so.2        /lib ;;
#   x86_64) ln -sfnv $PWD/elf/ld-linux-x86-64.so.2 /lib ;;
# esac
# make check

# 在安装 Glibc 时，它会抱怨文件 /etc/ld.so.conf 不存在
# 尽管这是一条无害的消息，执行以下命令即可防止这个警告
touch /etc/ld.so.conf

# 修正生成的 Makefile，跳过一个在 LFS 的不完整环境中会失败的完整性检查
sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile

# 安装 Glibc
make install

# 安装 nscd 的配置文件和运行时目录
cp -v ../nscd/nscd.conf /etc/nscd.conf
mkdir -pv /var/cache/nscd

# 安装 nscd 的 systemd 支持文件
install -v -Dm644 ../nscd/nscd.tmpfiles /usr/lib/tmpfiles.d/nscd.conf
install -v -Dm644 ../nscd/nscd.service /lib/systemd/system/nscd.service

# 安装一些 locale，它们可以使得系统用不同语言响应用户请求
# 以下命令将会安装能够覆盖测试所需的最小 locale 集合
mkdir -pv /usr/lib/locale
localedef -i POSIX -f UTF-8 C.UTF-8 2> /dev/null || true
localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
localedef -i de_DE -f ISO-8859-1 de_DE
localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
localedef -i de_DE -f UTF-8 de_DE.UTF-8
localedef -i el_GR -f ISO-8859-7 el_GR
localedef -i en_GB -f UTF-8 en_GB.UTF-8
localedef -i en_HK -f ISO-8859-1 en_HK
localedef -i en_PH -f ISO-8859-1 en_PH
localedef -i en_US -f ISO-8859-1 en_US
localedef -i en_US -f UTF-8 en_US.UTF-8
localedef -i es_MX -f ISO-8859-1 es_MX
localedef -i fa_IR -f UTF-8 fa_IR
localedef -i fr_FR -f ISO-8859-1 fr_FR
localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
localedef -i it_IT -f ISO-8859-1 it_IT
localedef -i it_IT -f UTF-8 it_IT.UTF-8
localedef -i ja_JP -f EUC-JP ja_JP
localedef -i ja_JP -f SHIFT_JIS ja_JP.SIJS 2> /dev/null || true
localedef -i ja_JP -f UTF-8 ja_JP.UTF-8
localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R
localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
localedef -i zh_CN -f GB18030 zh_CN.GB18030
localedef -i zh_HK -f BIG5-HKSCS zh_HK.BIG5-HKSCS

# 或者，也可以一次安装 glibc-2.32/localedata/SUPPORTED 中列出的所有 locale
# make localedata/install-locales
