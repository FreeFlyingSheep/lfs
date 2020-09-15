#!/bin/bash
set -e

echo "创建目录布局……"
mkdir -pv $LFS/{bin,etc,lib,sbin,usr,var}
case $(uname -m) in
  x86_64) mkdir -pv $LFS/lib64 ;;
esac
# 交叉编译器目录
mkdir -pv $LFS/tools

echo "添加 LFS 用户"
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
passwd lfs << "EOF"
123456
123456
EOF

# 一些商业发行版未做文档说明地将 /etc/bash.bashrc 引入 bash 初始化过程。
# 该文件可能修改 lfs 用户的环境，并影响 LFS 关键软件包的构建。
# 为了保证 lfs 用户环境的纯净，检查 /etc/bash.bashrc 是否存在，如果它存在就将它移走。
[ ! -e /etc/bash.bashrc.NOUSE ] || mv -v /etc/bash.bashrc /etc/bash.bashrc.NOUSE

# 将相应的脚本拷贝到 lfs 家目录以及源码目录
mkdir -pv $LFS/sources/script
cp chroot/* $LFS/sources/script
mkdir -pv /home/lfs/script
cp lfs/* /home/lfs/script
# 改变 lfs 家目录下的脚本所有者，源码目录下的脚本所有者将在后续步骤更改
chown -Rv lfs /home/lfs/script

chown -v lfs $LFS/sources

# 使用管道来指定切换用户后需要执行的命令
su - lfs << EOF
bash ~/script/init.sh
EOF

su - lfs << EOF
bash ~/script/test.sh
EOF
