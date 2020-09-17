#!/bin/bash
set -e

echo "交叉编译临时工具……"

bash ~/scripts/tools/m4.sh
bash ~/scripts/tools/ncurses.sh
bash ~/scripts/tools/bash.sh
bash ~/scripts/tools/coreutils.sh
bash ~/scripts/tools/diffutils.sh
bash ~/scripts/tools/file.sh
bash ~/scripts/tools/findutils.sh
bash ~/scripts/tools/gawk.sh
bash ~/scripts/tools/grep.sh
bash ~/scripts/tools/gzip.sh
bash ~/scripts/tools/make.sh
bash ~/scripts/tools/patch.sh
bash ~/scripts/tools/sed.sh
bash ~/scripts/tools/tar.sh
bash ~/scripts/tools/xz.sh
bash ~/scripts/tools/binutils.sh
bash ~/scripts/tools/gcc.sh
