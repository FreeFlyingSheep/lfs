#!/bin/bash
set -e

# 准备编译 XML::Parser
perl Makefile.PL

# 编译 XML::Parser
make

# 测试 XML::Parser
# make test

# 安装 XML::Parser
make install
