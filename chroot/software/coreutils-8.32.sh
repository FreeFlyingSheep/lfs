#!/bin/bash
set -e

# POSIX 要求 Coreutils 中的程序即使在多字节 locale 中也能正确识别字符边界
# 下面应用一个补丁，以解决 Coreutils 不满足该要求的问题，并修复其他一些国际化相关的 bug
patch -Np1 -i ../coreutils-8.32-i18n-1.patch

# 阻止一个在某些机器上会无限循环的测试
# sed -i '/test.lock/s/^/#/' gnulib-tests/gnulib.mk

# 准备编译 Coreutils
autoreconf -fiv
FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr            \
            --enable-no-install-program=kill,uptime

# 编译 Coreutils
make

# 运行那些设计为由 root 用户运行的测试
# make NON_ROOT_USERNAME=tester check-root
# 之后我们要以 tester 用户身份运行其余测试
# 然而，某些测试要求测试用户属于至少一个组。
# 为了不跳过这些测试，我们添加一个临时组，并使得 tester 用户成为它的成员
# echo "dummy:x:102:tester" >> /etc/group
# 修正访问权限，使得非 root 用户可以编译和运行测试
# chown -Rv tester . 
# 测试 Coreutils
# su tester -c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check"
# 删除临时组
# sed -i '/dummy/d' /etc/group

# 安装 Coreutils
make install

# 将程序移动到 FHS 要求的位置
mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin
mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin
mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin
mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/' /usr/share/man/man8/chroot.8
mv -v /usr/bin/{head,nice,sleep,touch} /bin
