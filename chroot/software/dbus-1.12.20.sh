#!/bin/bash
set -e

# 配置 D-Bus
./configure --prefix=/usr                       \
            --sysconfdir=/etc                   \
            --localstatedir=/var                \
            --disable-static                    \
            --disable-doxygen-docs              \
            --disable-xml-docs                  \
            --docdir=/usr/share/doc/dbus-1.12.20 \
            --with-console-auth-dir=/run/console

# 编译 D-Bus
make

# 安装 D-Bus
make install

# 需要将共享库移动到 /lib，因此 /usr/lib 中的 .so 符号链接需要重新建立
mv -v /usr/lib/libdbus-1.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libdbus-1.so) /usr/lib/libdbus-1.so

# 创建符号链接，使 D-Bus 和 systemd 使用同一个 machine-id 文件
ln -sfv /etc/machine-id /var/lib/dbus

# 将 socket 文件从过时的 /var/run 移动到 /run
sed -i 's:/var/run:/run:' /lib/systemd/system/dbus.socket
