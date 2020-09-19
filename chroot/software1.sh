#!/bin/bash
set -e

DIR=/sources/scripts/software
LOG_DIR=/sources/log/chroot/software

mkdir -p ${LOG_DIR}

# 指定并行构建数目
export MAKEFLAGS='-j4'

cd /sources

# 处理特例
echo "构建 Man-pages-5.08……"
tar -xf man-pages-5.08.tar.*
pushd man-pages-5.08 > /dev/null
time bash ${DIR}/man-pages-5.08.sh > ${LOG_DIR}/man-pages-5.08.log 2>&1
popd > /dev/null
rm -rf man-pages-5.08
echo -e "构建 man-pages-5.08 完成！\n"

echo "构建 Tcl-8.6.10……"
tar -xf tcl8.6.10-src.tar.*
pushd tcl8.6.10 > /dev/null
time bash ${DIR}/tcl8.6.10.sh > ${LOG_DIR}/tcl8.6.10.log 2>&1
popd > /dev/null
rm -rf tcl8.6.10
echo -e "构建 Tcl-8.6.10 完成！\n"

tools=(
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
  'MPC-1.1.0'
  'Attr-2.4.48'
  'Acl-2.2.53'
  'Libcap-2.42'
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
)

dirs=(
  expect5.45.4
  dejagnu-1.6.2
  iana-etc-20200821
  glibc-2.32
  zlib-1.2.11
  bzip2-1.0.8
  xz-5.2.5
  zstd-1.4.5
  file-5.39
  readline-8.0
  m4-1.4.18
  bc-3.1.5
  flex-2.6.4
  binutils-2.35
  gmp-6.2.0
  mpfr-4.1.0
  mpc-1.1.0
  attr-2.4.48
  acl-2.2.53
  libcap-2.42
  shadow-4.8.1
  gcc-10.2.0
  pkg-config-0.29.2
  ncurses-6.2
  sed-4.8
  psmisc-23.3
  gettext-0.21
  bison-3.7.1
  grep-3.4
  bash-5.0
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
