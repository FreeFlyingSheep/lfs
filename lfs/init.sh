#!/bin/bash
set -e

# 我们在 .bash_profile 中使用 exec env -i.../bin/bash 命令
# 新建一个除了 HOME, TERM 以及 PS1 外没有任何环境变量的 shell，替换当前 shell
# 防止宿主环境中不必要和有潜在风险的环境变量进入编译环境
cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

# 新的 shell 实例是 非登录 shell，它不会读取和执行 /etc/profile 或者 .bash_profile 的内容
# 而是读取并执行 .bashrc 文件
cat > ~/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
export LFS LC_ALL LFS_TGT PATH
bash ~/script/build.sh
EOF

# 为了完全准备好编译临时工具的环境，指示 shell 读取刚才创建的配置文件
# 由于在 .bash_profile 中使用新建了 shell
# 所以无法通过管道的方式来让新建的 shell 继续执行命令
# 直接在 .bashrc 最后加入 ~/script/build.sh（lfs/build.sh的拷贝）
# 强制每次登录 lfs 用户都执行 build.sh，以此实现自动构建
# 此处需要退出后重新进入，而不是 source ~/.bash_profile
exit 0
