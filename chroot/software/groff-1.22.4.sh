#!/bin/bash
set -e

# Groff 期望环境变量 PAGE 包含默认纸张大小
# 对于美国用户来说，PAGE=letter 是正确的
# 对于其他地方的用户，PAGE=A4 可能更好
# 尽管在编译时配置了默认纸张大小，可以通过写入 A4 或 letter 到 /etc/papersize 文件，覆盖默认值
# 配置 Groff
PAGE=A4 ./configure --prefix=/usr

# 编译 Groff
make -j1

# 安装 Groff
make install
