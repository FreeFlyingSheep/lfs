#!/bin/bash
set -e

# 将 $LFS/* 目录的所有者改变为 root
chown -R root:root $LFS/{usr,lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -R root:root $LFS/lib64 ;;
esac

# 创建虚拟文件系统的挂载点
mkdir -pv $LFS/{dev,proc,sys,run}

# 创建初始设备节点
mknod -m 600 $LFS/dev/console c 5 1
mknod -m 666 $LFS/dev/null c 1 3

#挂载和填充 /dev
mount -v --bind /dev $LFS/dev

# 挂载虚拟内核文件系统
mount -v --bind /dev/pts $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

# 在某些宿主系统上，/dev/shm 是一个指向 /run/shm 的符号链接
# 我们已经在 /run 下挂载了 tmpfs 文件系统，因此在这里只需要创建一个目录
if [ -h $LFS/dev/shm ]; then
  mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi

# 通过管道来指定进入 Chroot 后需要执行的命令
# init.sh 为 chroot/init.sh 的拷贝
echo "进入 Chroot 环境"
chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login +h        \
    << "EOF"
bash /sources/scripts/init.sh
EOF
