#!/bin/bash
set -e

LOG=log/host/chroot.log

# 将 $LFS/* 目录的所有者改变为 root
chown -R root:root $LFS/{usr,lib,var,etc,bin,sbin,tools} > ${LOG} 2>&1
case $(uname -m) in
  x86_64) chown -R root:root $LFS/lib64 >> ${LOG} 2>&1 ;;
esac

# 创建虚拟文件系统的挂载点
mkdir -pv $LFS/{dev,proc,sys,run} >> ${LOG} 2>&1

# 创建初始设备节点
mknod -m 600 $LFS/dev/console c 5 1 >> ${LOG} 2>&1
mknod -m 666 $LFS/dev/null c 1 3  >> ${LOG} 2>&1

# 挂载和填充 /dev
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
set -e

echo -e "进入 Chroot 环境完成！\n"
bash /sources/scripts/init.sh
EOF

# 使用新的 chroot 命令行重新进入 Chroot 环境
# 通过管道来指定进入 Chroot 后需要执行的命令
chroot "$LFS" /usr/bin/env -i          \
    HOME=/root TERM="$TERM"            \
    PS1='(lfs chroot) \u:\w\$ '        \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login << "EOF"
set -e

# 在本章的前几节中，有几个静态库的安装没有被禁止，目的是满足一些软件包的退化测试需要
# 这些库来自于 binutils、bzip2、e2fsprogs、flex、libtool 和 zlib
# 现在可以删除它们
rm -f /usr/lib/lib{bfd,opcodes}.a
rm -f /usr/lib/libctf{,-nobfd}.a
rm -f /usr/lib/libbz2.a
rm -f /usr/lib/lib{com_err,e2p,ext2fs,ss}.a
rm -f /usr/lib/libltdl.a
rm -f /usr/lib/libfl.a
rm -f /usr/lib/libz.a

# 在 /usr/lib 和 /usr/libexec 目录中还有一些扩展名为 .la 的文件
# 它们是 "libtool 档案" 文件
# 它们在链接到共享库，特别是使用 autotools 以外的构建系统时，是不必要，甚至有害的
find /usr/lib /usr/libexec -name \*.la -delete

# 之前步骤中构建的编译器仍然有一部分安装在系统上，它现在已经没有存在的意义了
find /usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -rf

# /tools 也可以被删除，从而获得更多可用空间
rm -rf /tools

# 移除上一章开始时创建的临时 'tester' 用户账户
# 我们并没创建测试用户，所以这里不需要移除
# userdel -r tester
echo -e "清理系统完成！\n"

echo "设置系统配置……"
bash /sources/scripts/config.sh
echo -e "设置系统配置完成！\n"

echo "使 LFS 系统可引导……"
bash /sources/scripts/boot.sh
echo -e "使 LFS 系统可引导完成！\n"

echo "创建版本信息……"
bash /sources/scripts/version.sh
echo -e "创建版本信息完成！\n"

echo "退出 Chroot 环境……"
logout
EOF
echo -e "退出 Chroot 环境完成！\n"

echo "清理虚拟磁盘……"
# 移动日志
mv $LFS/sources/log/* log
# 删除源码目录
rm -rf $LFS/sources
echo -e "清理虚拟磁盘完成！\n"

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
# 相应的，我们需要删除回环设备，而不是重启
# shutdown -r now

# 删除 $LFS 目录
rmdir -v ${LFS} >> ${LOG} 2>&1

# 删除回环设备
losetup -D >> ${LOG} 2>&1
echo -e "卸载虚拟磁盘完成！\n"
