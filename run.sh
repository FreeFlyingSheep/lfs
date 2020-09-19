#!/bin/bash
set -e

# 本脚本遵循 MIT 协议
# 本脚本用于自动构建 LFS systemd 10.0
VERSION=0.12

echo "    __    ___________"
echo "   / /   / ____/ ___/"
echo "  / /   / /_   \__ \ "
echo " / /___/ __/  ___/ / "
echo "/_____/_/    /____/  "

echo -e "\n自动构建 LFS systemd 10.0，脚本版本 v${VERSION}"
echo -e "警告：对运行该脚本可能产生的一切后果，本人概不负责！\n"

if [ `id -u` -ne 0 ]; then
  echo "必须用 root 用户执行该脚本！"
  exit 1
fi

# 切换到脚本所在的目录
cd `dirname $0`

# init.sh 完成一些前期工作后
# 交给 host/build.sh 完成构建
bash host/init.sh

echo "构建完成！"
exit 0
