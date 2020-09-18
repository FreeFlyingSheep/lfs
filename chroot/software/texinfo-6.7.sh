#!/bin/bash
set -e

# 配置 Texinfo
./configure --prefix=/usr --disable-static

# 编译 Texinfo
make

# 测试 Texinfo
# make check

# 安装 Texinfo
make install

# 安装属于 TeX 环境的组件
make TEXMF=/usr/share/texmf install-tex

# Info 文档系统使用一个纯文本文件保存目录项的列表
# 该文件位于 /usr/share/info/dir
# 不幸的是，由于一些软件包 Makefile 中偶然出现的问题，它有时会与系统实际安装的 info 页面不同步
# 如果需要重新创建 /usr/share/info/dir 文件，可以运行以下命令完成这一工作
pushd /usr/share/info
rm -v dir
for f in *
do install-info $f dir 2>/dev/null
done
popd
