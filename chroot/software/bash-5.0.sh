#!/bin/bash
set -e

# 整合上游进行的一些修复
patch -Np1 -i ../bash-5.0-upstream_fixes-1.patch

# 配置 Bash
./configure --prefix=/usr                    \
            --docdir=/usr/share/doc/bash-5.0 \
            --without-bash-malloc            \
            --with-installed-readline

# 编译 Bash
make

# 为了准备进行测试，确保 tester 用户可以写入源代码目录
# chown -Rv tester .
# 现在以 tester 用户的身份运行测试
# su tester << EOF
# PATH=$PATH make tests < $(tty)
# EOF

# 安装 Bash，并把主要的可执行文件移动到 /bin
make install
mv -vf /usr/bin/bash /bin
