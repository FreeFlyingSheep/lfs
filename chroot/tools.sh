#!/bin/bash
set -e

echo "构建其他临时工具……"

DIR=/sources/scripts/tools
LOG_DIR=${LFS}/sources/log/chroot/tools

mkdir -p ${LOG_DIR}

tools=(
  'GCC-10.2.0 中的 Libstdc++，第二遍'
  'Gettext-0.21'
  'Bison-3.7.1'
  'Perl-5.32.0'
  'Python-3.8.5'
  'Texinfo-6.7'
  'Util-linux-2.36'
)

dirs=(
  gcc-10.2.0
  gettext-0.21
  bison-3.7.1
  perl-5.32.0
  Python-3.8.5
  texinfo-6.7
  util-linux-2.36
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
