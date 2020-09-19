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
echo -e "检查宿主机环境完成！\n"

# 导出 $LFS 环境变量
export LFS=/mnt/lfs
echo -e "\$LFS 环境变量为 ${LFS}\n"

# 创建日志目录
rm -rf log
mkdir -p log/host

echo "清理上次的构建……"
bash host/clean.sh > log/host/clean.log 2>&1
echo -e "清理上次的构建完成！\n"

# 正式开始构建
bash host/build.sh
