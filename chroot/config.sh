#!/bin/bash
set -e

LOG=/sources/log/chroot/config.log

# 一般网络配置
ln -sv /dev/null /etc/systemd/network/99-default.link > ${LOG} 2>&1

cat > /etc/systemd/network/10-eth-dhcp.network << "EOF"
[Match]
Name=eth0

[Network]
DHCP=ipv4

[DHCP]
UseDomains=true
EOF

ln -sfv /run/systemd/resolve/resolv.conf /etc/resolv.conf >> ${LOG} 2>&1

echo "lfs" > /etc/hostname

cat > /etc/hosts << "EOF"
# Begin /etc/hosts

127.0.0.1 localhost.localdomain localhost
127.0.1.1 lfs.localdomain lfs
::1       localhost ip6-localhost ip6-loopback
ff02::1   ip6-allnodes
ff02::2   ip6-allrouters

# End /etc/hosts
EOF

# 设备和模块管理概述
# 使用默认配置

# 管理设备
# 使用默认配置

# 配置系统时钟
# 使用默认配置

# 配置 Linux 控制台
# 使用默认配置

# 配置系统 Locale
LOCALE=en_US.UTF-8
MSG=`LC_ALL=${LOCALE} locale language`
echo "$MSG" | grep -q 'American English'
MSG=`LC_ALL=${LOCALE} locale charmap`
echo "$MSG" | grep -q 'UTF-8'
MSG=`LC_ALL=${LOCALE} locale int_curr_symbol`
echo "$MSG" | grep -q 'USD'
MSG=`LC_ALL=${LOCALE} locale int_prefix`
echo "$MSG" | grep -q '1'

cat > /etc/locale.conf << "EOF"
LANG=${LOCALE}
EOF
unset LOCALE MSG

# 创建 /etc/inputrc 文件
cat > /etc/inputrc << "EOF"
# Begin /etc/inputrc
# Modified by Chris Lynn <roryo@roryo.dynup.net>

# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off

# Enable 8bit input
set meta-flag On
set input-meta On

# Turns off 8th bit stripping
set convert-meta Off

# Keep the 8th bit for display
set output-meta On

# none, visible or audible
set bell-style none

# All of the following map the escape sequence of the value
# contained in the 1st argument to the readline specific functions
"\eOd": backward-word
"\eOc": forward-word

# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line

# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line

# End /etc/inputrc
EOF

# 创建 /etc/shells 文件
cat > /etc/shells << "EOF"
# Begin /etc/shells

/bin/sh
/bin/bash

# End /etc/shells
EOF

# Systemd 使用和配置
# 使用默认配置
