#!/bin/bash
set -e

# 在运行时，ninja 一般尽量并行运行更多进程
# 默认情况下最大进程数是系统 CPU 核心数加 2 得到的值
# 某些情况下，这样会导致 CPU 过热，或者耗尽系统内存
# 如果使用命令行执行 ninja，可以传递 -jN 参数以限制并行进程数
# 但某些软件包内嵌了 ninja 的执行过程，且并不传递 -j 参数
# 应用下面这个可选的修改，用户即可通过一个环境变量 NINJAJOBS 限制并行进程数量
sed -i '/int Guess/a \
  int   j = 0;\
  char* jobs = getenv( "NINJAJOBS" );\
  if ( jobs != NULL ) j = atoi( jobs );\
  if ( j > 0 ) return j;\
' src/ninja.cc

# 编译 Ninja
python3 configure.py --bootstrap

# 测试 Ninja
# ./ninja ninja_test
# ./ninja_test --gtest_filter=-SubprocessTest.SetWithLots

# 安装 Ninja
install -vm755 ninja /usr/bin/
install -vDm644 misc/bash-completion /usr/share/bash-completion/completions/ninja
install -vDm644 misc/zsh-completion  /usr/share/zsh/site-functions/_ninja
