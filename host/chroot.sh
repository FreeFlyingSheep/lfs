#!/bin/bash
set -e

LOG=${LOG_DIR}/chroot.log

# 将 $LFS/* 目录的所有者改变为 root
chown -R root:root $LFS/{usr,lib,var,etc,bin,sbin,tools} >> ${LOG} 2>&1
case $(uname -m) in
  x86_64) chown -R root:root $LFS/lib64  >> ${LOG} 2>&1 ;;
esac

# 创建虚拟文件系统的挂载点
mkdir -pv $LFS/{dev,proc,sys,run}  >> ${LOG} 2>&1

# 创建初始设备节点
mknod -m 600 $LFS/dev/console c 5 1 >> ${LOG} 2>&1
mknod -m 666 $LFS/dev/null c 1 3  >> ${LOG} 2>&1

#挂载和填充 /dev
mount -v --bind /dev $LFS/dev >> ${LOG} 2>&1

# 挂载虚拟内核文件系统
mount -v --bind /dev/pts $LFS/dev/pts >> ${LOG} 2>&1
mount -vt proc proc $LFS/proc >> ${LOG} 2>&1
mount -vt sysfs sysfs $LFS/sys >> ${LOG} 2>&1
mount -vt tmpfs tmpfs $LFS/run >> ${LOG} 2>&1

# 在某些宿主系统上，/dev/shm 是一个指向 /run/shm 的符号链接
# 我们已经在 /run 下挂载了 tmpfs 文件系统，因此在这里只需要创建一个目录
if [ -h $LFS/dev/shm ]; then
  mkdir -pv $LFS/$(readlink $LFS/dev/shm) >> ${LOG} 2>&1
fi

# 通过管道来指定进入 Chroot 后需要执行的命令
# init.sh 为 chroot/init.sh 的拷贝
echo "进入 Chroot 环境……"
chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login +h        \
    << "EOF"
echo -e "进入 Chroot 环境完成！\n"
bash /sources/scripts/init.sh
EOF

echo "卸载虚拟磁盘……"
# 解除虚拟文件系统的挂载
umount -v $LFS/dev/pts >> ${LOG} 2>&1
umount -v $LFS/dev >> ${LOG} 2>&1
umount -v $LFS/run >> ${LOG} 2>&1
umount -v $LFS/proc >> ${LOG} 2>&1
umount -v $LFS/sys >> ${LOG} 2>&1

# 如果为 LFS 创建了多个分区，在解除 LFS 文件系统的挂载前，先解除其他挂载点
# 我们的虚拟磁盘只有一个分区
# umount -v $LFS/usr
# umount -v $LFS/home
# umount -v $LFS

# 解除 LFS 文件系统本身的挂载
umount -v $LFS >> ${LOG} 2>&1

# 现在重新启动系统
# 相应的，我们需要卸载虚拟磁盘，而不是重启
# shutdown -r now

# 卸除虚拟的块设备
losetup -D >> ${LOG} 2>&1
echo -e "卸载虚拟磁盘完成！\n"
