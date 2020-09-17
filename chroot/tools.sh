#!/bin/bash
set -e

echo "构建其他临时工具"

bash /sources/scripts/tools/libstd.sh
bash /sources/scripts/tools/gettext.sh
bash /sources/scripts/tools/bison.sh
bash /sources/scripts/tools/perl.sh
bash /sources/scripts/tools/python.sh
bash /sources/scripts/tools/texinfo.sh
bash /sources/scripts/tools/util-linux.sh