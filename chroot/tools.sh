#!/bin/bash
set -e

echo "构建其他临时工具"

bash /sources/script/tools/libstd.sh
bash /sources/script/tools/gettext.sh
bash /sources/script/tools/bison.sh
bash /sources/script/tools/perl.sh
bash /sources/script/tools/python.sh
bash /sources/script/tools/texinfo.sh
bash /sources/script/tools/util-linux.sh