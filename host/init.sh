#!/bin/bash
set -e

echo "检查宿主机环境……"
bash host/version-check.sh

echo "在执行下一步前，请确保宿主机环境正确配置："
select choice in "继续执行" "退出"; do
case $choice in
  "继续执行")
    break
    ;;
  "退出")
    exit 1
    ;;
  *)
    echo "无效的选项，请重试："
    ;;
esac
done

# 导出 $LFS 环境变量
export LFS=/mnt/lfs
echo "LFS=$LFS"

# 清理上次的构建（如果存在）
bash host/clean.sh
# 创建日志目录
mkdir ${LOG_DIR}

# 正式开始构建
bash host/build.sh
