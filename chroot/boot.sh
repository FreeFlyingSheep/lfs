#!/bin/bash
set -e

LOG=/sources/log/chrooot/boot.log

# 一些程序使用 /etc/fstab 文件，以确定哪些文件系统是默认挂载的
# 和它们应该按什么顺序挂载，以及哪些文件系统在挂载前必须被检查 (确定是否有完整性错误)
# 创建一个新的文件系统表
# 在虚拟机上挂载时，它的名称应该为 /dev/sda
cat > /etc/fstab > /sources/log/chrooot/${LOG} 2>&1 << "EOF"
# Begin /etc/fstab

# 文件系统     挂载点       类型     选项                转储      检查
#                                                              顺序
/dev/sda      /           ext4    defaults            1        1

# End /etc/fstab
EOF

# 安装 Linux 内核
export MAKEFLAGS='-j8'

pushd /sources >> /sources/log/chrooot/${LOG} 2>&1

echo "构建 Linux-5.8.3……"
tar -xf linux-5.8.3.tar.*
pushd linux-5.8.3 >> /sources/log/chrooot/${LOG} 2>&1
time bash /sources/scripts/linux-5.8.3.sh > /sources/log/chroot/linux-5.8.3.log 2>&1
popd >> /sources/log/chrooot/${LOG} 2>&1
rm -rf linux-5.8.3
echo -e "构建 Linux-5.8.3 完成！\n"

popd >> /sources/log/chrooot/${LOG} 2>&1

# 配置 Linux 内核模块加载顺序
install -v -m755 -d /etc/modprobe.d >> /sources/log/chrooot/${LOG} 2>&1
cat > /etc/modprobe.d/usb.conf >> /sources/log/chrooot/${LOG} 2>&1 << "EOF"
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOF

# 使用 GRUB 设定引导过程
# 获取块设备名称
DISK=`losetup -l | grep "lfs.img" | cut -d" " -f 1`
# 将 GRUB 文件安装到 /boot/grub 并设定引导磁道
grub-install ${DISK} >> /sources/log/chrooot/${LOG} 2>&1
unset DISK

# 创建 GRUB 配置文件
# 我们只有一个分区，根为 /dev/sda1
cat > /boot/grub/grub.cfg >> /sources/log/chrooot/${LOG} 2>&1 << "EOF"
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod ext2
set root=(hd0,2)

menuentry "GNU/Linux, Linux 5.8.5-lfs-20200901-systemd" {
        linux   /boot/vmlinuz-5.8.5-lfs-20200901-systemd root=/dev/sda1 ro
}
EOF
