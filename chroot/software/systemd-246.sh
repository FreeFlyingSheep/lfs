#!/bin/bash
set -e

# 创建一个符号链接，绕过本书不会安装的 xsltproc
ln -sf /bin/true /usr/bin/xsltproc

# 设定好 man 页面
tar -xf ../systemd-man-pages-246.tar.xz

# 删除在 chroot 环境中无法构建的测试
# sed '177,$ d' -i src/resolve/meson.build

# 从默认的 udev 规则中删除不必要的组 render
sed -i 's/GROUP="render", //' rules.d/50-udev-default.rules.in

# 配置 Systemd
mkdir -p build
cd       build

LANG=en_US.UTF-8                    \
meson --prefix=/usr                 \
      --sysconfdir=/etc             \
      --localstatedir=/var          \
      -Dblkid=true                  \
      -Dbuildtype=release           \
      -Ddefault-dnssec=no           \
      -Dfirstboot=false             \
      -Dinstall-tests=false         \
      -Dkmod-path=/bin/kmod         \
      -Dldconfig=false              \
      -Dmount-path=/bin/mount       \
      -Drootprefix=                 \
      -Drootlibdir=/lib             \
      -Dsplit-usr=true              \
      -Dsulogin-path=/sbin/sulogin  \
      -Dsysusers=false              \
      -Dumount-path=/bin/umount     \
      -Db_lto=false                 \
      -Drpmmacrosdir=no             \
      -Dhomed=false                 \
      -Duserdb=false                \
      -Dman=true                    \
      -Ddocdir=/usr/share/doc/systemd-246 \
      ..

# 编译 Systemd
LANG=en_US.UTF-8 ninja

# 安装 Systemd
LANG=en_US.UTF-8 ninja install

# 删除一个不再必要的符号链接
rm -f /usr/bin/xsltproc

# 创建 /etc/machine-id 文件，systemd-journald需要它
systemd-machine-id-setup

# 设定启动目标单元的基本结构
systemctl preset-all

# 已知一个服务单元会导致并非由 systemd-networkd 提供网络配置的系统出现问题
systemctl disable systemd-time-wait-sync.service

# 防止 systemd 重设最大 PID 值，它会导致 BLFS 中一些软件包和单元出现问题
rm -f /usr/lib/sysctl.d/50-pid-max.conf
