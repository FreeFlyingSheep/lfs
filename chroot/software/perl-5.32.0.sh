#!/bin/bash
set -e

# 该版本的 Perl 会构建 Compress::Raw::ZLib 和 Compress::Raw::BZip2 模块
# 默认情况下 Perl 会使用内部的源码副本构建它们
# 执行以下命令，使得 Perl 使用系统中已经安装好的库
export BUILD_ZLIB=False
export BUILD_BZIP2=0

# 为了能够完全控制 Perl 的设置，您可以在以下命令中移除 “-des” 选项，并手动选择构建该软件包的方式
# 或者，直接使用下面的命令，以使用 Perl 自动检测的默认值
sh Configure -des                                         \
             -Dprefix=/usr                                \
             -Dvendorprefix=/usr                          \
             -Dprivlib=/usr/lib/perl5/5.32/core_perl      \
             -Darchlib=/usr/lib/perl5/5.32/core_perl      \
             -Dsitelib=/usr/lib/perl5/5.32/site_perl      \
             -Dsitearch=/usr/lib/perl5/5.32/site_perl     \
             -Dvendorlib=/usr/lib/perl5/5.32/vendor_perl  \
             -Dvendorarch=/usr/lib/perl5/5.32/vendor_perl \
             -Dman1dir=/usr/share/man/man1                \
             -Dman3dir=/usr/share/man/man3                \
             -Dpager="/usr/bin/less -isR"                 \
             -Duseshrplib                                 \
             -Dusethreads

# 编译 Perl
make

# 测试 Perl
# make test

# 安装 Perl，并清理环境变量
make install
unset BUILD_ZLIB BUILD_BZIP2
