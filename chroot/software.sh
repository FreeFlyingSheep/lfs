#!/bin/bash
set -e

echo "安装基本系统软件"

DIR=/sources/scripts/software
LOG_DIR=${LFS}/sources/log/chroot/software

mkdir -p ${LOG_DIR}

tools=(
  'Man-pages-5.08'
  'Tcl-8.6.10'
  'Expect-5.45.4'
  'DejaGNU-1.6.2'
  'Iana-Etc-20200821'
  'Glibc-2.32'
  'Zlib-1.2.11'
  'Bzip2-1.0.8'
  'Xz-5.2.5'
  'Zstd-1.4.5'
  'File-5.39'
  'Readline-8.0'
  'M4-1.4.18'
  'Bc-3.1.5'
  'Flex-2.6.4'
  'Binutils-2.35'
  'GMP-6.2.0'
  'MPFR-4.1.0'
  'MPC-1.2.0'
  'Attr-2.4.48'
  'Acl-2.2.53'
  'Libcap-2.43'
  'Shadow-4.8.1'
  'GCC-10.2.0'
  'Pkg-config-0.29.2'
  'Ncurses-6.2'
  'Sed-4.8'
  'Psmisc-23.3'
  'Gettext-0.21'
  'Bison-3.7.1'
  'Grep-3.4'
  'Bash-5.0'
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
  man
  tcl
  expect
  dejaGNU
  iana
  glibc
  zlib
  bzip2
  xz
  zstd
  file
  readline
  m4
  bc
  flex
  binutils
  gmp
  mpfr
  mpc
  attr
  acl
  libcap
  shadow
  gcc
  pkg
  ncurses
  sed
  psmisc
  gettext
  bison
  grep
  bash
  libtool
  gdbm
  gperf
  expat
  inetutils
  perl
  xml
  intltool
  autoconf
  automake
  kmod
  elfutils
  libffi
  openSSL
  python
  ninja
  meson
  coreutils
  check
  diffutils
  gawk
  findutils
  groff
  grub
  less
  gzip
  iproute2
  kbd
  libpipeline
  make
  patch
  man
  tar
  texinfo
  vim
  systemd
  dbus-1.12.20
  procps
  util
  e2fsprogs
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
