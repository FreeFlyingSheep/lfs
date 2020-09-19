#!/bin/bash
set -e

DIR=/sources/scripts/software
LOG_DIR=/sources/log/chroot/software

tools=(
  'Libtool-2.4.6'
  'GDBM-1.18.1'
  'Gperf-3.1'
  'Expat-2.2.9'
  'Inetutils-1.9.4'
  'Perl-5.32.0'
  'XML::Parser-2.46'
  'Intltool-0.51.0'
  'Autoconf-2.69'
  'Automake-1.16.2'
  'Kmod-27'
  'Elfutils-0.180 中的 Libelf'
  'Libffi-3.3'
  'OpenSSL-1.1.1g'
  'Python-3.8.5'
  'Ninja-1.10.1'
  'Meson-0.55.1'
  'Coreutils-8.32'
  'Check-0.15.2'
  'Diffutils-3.7'
  'Gawk-5.1.0'
  'Findutils-4.7.0'
  'Groff-1.22.4'
  'GRUB-2.04'
  'Less-551'
  'Gzip-1.10'
  'IPRoute2-5.8.0'
  'Kbd-2.3.0'
  'Libpipeline-1.5.3'
  'Make-4.3'
  'Patch-2.7.6'
  'Man-DB-2.9.3'
  'Tar-1.32'
  'Texinfo-6.7'
  'Vim-8.2.1361'
  'Systemd-246'
  'D-Bus-1.12.20'
  'Procps-ng-3.3.16'
  'Util-linux-2.36'
  'E2fsprogs-1.45.6'
)

dirs=(
  libtool-2.4.6
  gdbm-1.18.1
  gperf-3.1
  expat-2.2.9
  inetutils-1.9.4
  perl-5.32.0
  XML-Parser-2.46
  intltool-0.51.0
  autoconf-2.69
  automake-1.16.2
  kmod-27
  elfutils-0.180
  libffi-3.3
  openssl-1.1.1g
  Python-3.8.5
  ninja-1.10.1
  meson-0.55.1
  coreutils-8.32
  check-0.15.2
  diffutils-3.7
  gawk-5.1.0
  findutils-4.7.0
  groff-1.22.4
  grub-2.04
  less-551
  gzip-1.10
  iproute2-5.8.0
  kbd-2.3.0
  libpipeline-1.5.3
  make-4.3
  patch-2.7.6
  man-db-2.9.3
  tar-1.32
  texinfo-6.7
  vim-8.2.1361
  systemd-246
  dbus-1.12.20
  procps-ng-3.3.16
  util-linux-2.36
  e2fsprogs-1.45.6
)

for i in ${!tools[@]}
do
  echo "构建 ${tools[i]}……"
  tar -xf ${dirs[i]}.tar.*
  pushd ${dirs[i]} > /dev/null
  time bash ${DIR}/${dirs[i]}.sh > ${LOG_DIR}/${dirs[i]}.log 2>&1
  popd > /dev/null
  rm -rf ${dirs[i]}
  echo -e "构建 ${tools[i]} 完成！\n"
done
