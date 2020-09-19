#!/bin/bash
set -e

DIR=~/scripts/tools
LOG_DIR=${LFS}/sources/log/lfs/tools

mkdir -p ${LOG_DIR}

# 指定并行构建数目
export MAKEFLAGS='-j4'

cd $LFS/sources

tools=(
  'M4-1.4.18'
  'Ncurses-6.2'
  'Bash-5.0'
  'Coreutils-8.32'
  'Diffutils-3.7'
  'File-5.39'
  'Findutils-4.7.0'
  'Gawk-5.1.0'
  'Grep-3.4'
  'Gzip-1.10'
  'Make-4.3'
  'Patch-2.7.6'
  'Sed-4.8'
  'Tar-1.32'
  'Xz-5.2.5'
  'Binutils-2.35 - 第二遍'
  'GCC-10.2.0 - 第二遍'
)

dirs=(
  m4-1.4.18
  ncurses-6.2
  bash-5.0
  coreutils-8.32
  diffutils-3.7
  file-5.39
  findutils-4.7.0
  gawk-5.1.0
  grep-3.4
  gzip-1.10
  make-4.3
  patch-2.7.6
  sed-4.8
  tar-1.32
  xz-5.2.5
  binutils-2.35
  gcc-10.2.0
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
