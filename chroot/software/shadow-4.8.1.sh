#!/bin/bash
set -e

# 禁止 Shadow 安装 groups 程序和它的 man 页面，因为 Coreutils 会提供更好的版本
# 同样，避免安装 Man-pages-5.08 软件包已经提供的 man 页面
sed -i 's/groups$(EXEEXT) //' src/Makefile.in
find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;

# 不使用默认的 crypt 加密方法，使用更安全的 SHA-512 方法加密密码，该方法也允许长度超过 8 个字符的密码
# 另外，还需要把过时的用户邮箱位置 /var/spool/mail 改为当前普遍使用的 /var/mail 目录
sed -e 's:#ENCRYPT_METHOD DES:ENCRYPT_METHOD SHA512:' \
    -e 's:/var/spool/mail:/var/mail:'                 \
    -i etc/login.defs

# 如果您选择构建有 Cracklib 支持的 Shadow，执行以下命令
sed -i 's:DICTPATH.*:DICTPATH\t/lib/cracklib/pw_dict:' etc/login.defs

# 进行微小的改动，使 useradd 使用 1000 作为第一个组编号
sed -i 's/1000/999/' etc/useradd

# 准备编译 Shadow
touch /usr/bin/passwd
./configure --sysconfdir=/etc \
            --with-group-name-max-length=32

# 编译 Shadow
make

# 安装 Shadow
make install

# 对用户密码启用 Shadow 加密
pwconv

# 对组密码启用 Shadow 加密
grpconv

# 为用户 root 选择一个密码，并设定它
passwd root << "EOF"
123456
123456
EOF
