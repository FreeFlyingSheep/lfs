#!/bin/bash
set -e

# 本脚本遵循 MIT 协议
# 本脚本用于自动构建 LFS systemd 10.0
VERSION=0.6

echo "    __    ___________"
echo "   / /   / ____/ ___/"
echo "  / /   / /_   \__ \ "
echo " / /___/ __/  ___/ / "
echo "/_____/_/    /____/  "

echo -e "\n自动构建 LFS systemd 10.0，脚本版本 v${VERSION}\n"

if [ `id -u` -ne 0 ]; then
  echo "必须用 root 用户执行该脚本！"
  exit 1
fi

# 切换到脚本所在的目录
cd `dirname $0`

# 导出脚本所需的环境变量
export LOG_DIR=log
export DISK_IMG=disk.img
export DISK_LOG=${LOG_DIR}/disk.log

bash host/init.sh

echo "构建完成！"
exit 0
