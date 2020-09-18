#!/bin/bash
set -e

# 编译 Meson
python3 setup.py build

# 安装 Meson
python3 setup.py install --root=dest
cp -rv dest/* /
