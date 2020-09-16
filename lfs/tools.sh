#!/bin/bash
set -e

echo "交叉编译临时工具……"

bash ~/script/tools/m4.sh
bash ~/script/tools/ncurses.sh
bash ~/script/tools/bash.sh
bash ~/script/tools/coreutils.sh
bash ~/script/tools/diffutils.sh
bash ~/script/tools/file.sh
bash ~/script/tools/findutils.sh
bash ~/script/tools/gawk.sh
bash ~/script/tools/grep.sh
bash ~/script/tools/gzip.sh
bash ~/script/tools/make.sh
bash ~/script/tools/patch.sh
bash ~/script/tools/sed.sh
bash ~/script/tools/tar.sh
bash ~/script/tools/xz.sh
bash ~/script/tools/binutils.sh
bash ~/script/tools/gcc.sh
