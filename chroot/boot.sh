#!/bin/bash
set -e

# 一些程序使用 /etc/fstab 文件，以确定哪些文件系统是默认挂载的
# 和它们应该按什么顺序挂载，以及哪些文件系统在挂载前必须被检查 (确定是否有完整性错误)
# 创建一个新的文件系统表
# 在虚拟机上挂载时，它的名称应该为 /dev/sda
cat > /etc/fstab << "EOF"
# Begin /etc/fstab

# 文件系统     挂载点       类型     选项                转储      检查
#                                                              顺序
/dev/sda      /           ext4    defaults            1        1

# End /etc/fstab
EOF

# 安装 Linux 内核
# 配置内核
make mrproper
make defconfig


# 编译内核映像和模块
make

# 安装模块
make modules_install

# 安装 Linux 内核
cp -iv arch/x86/boot/bzImage /boot/vmlinuz-5.8.5-lfs-20200901-systemd

# System.map 是内核符号文件，它将内核 API 的每个函数入口点和运行时数据结构映射到它们的地址
# 它被用于调查分析内核可能出现的问题，现在安装该文件
cp -iv System.map /boot/System.map-5.8.5

# 内核配置文件 .config 包含编译好的内核的所有配置选项
# 最好能将它保留下来以供日后参考
cp -iv .config /boot/config-5.8.5

# 安装 Linux 内核文档
install -d /usr/share/doc/linux-5.8.5
cp -r Documentation/* /usr/share/doc/linux-5.8.5

# 配置 Linux 内核模块加载顺序
install -v -m755 -d /etc/modprobe.d
cat > /etc/modprobe.d/usb.conf << "EOF"
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOF

# 使用 GRUB 设定引导过程
# 获取块设备名称
DISK=`losetup -l | grep "${DISK_IMG}" | cut -d" " -f 1`
# 将 GRUB 文件安装到 /boot/grub 并设定引导磁道
grub-install ${DISK}

# 创建 GRUB 配置文件
# 我们只有一个分区，根为 /dev/sda1
cat > /boot/grub/grub.cfg << "EOF"
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod ext2
set root=(hd0,2)

menuentry "GNU/Linux, Linux 5.8.5-lfs-20200901-systemd" {
        linux   /boot/vmlinuz-5.8.5-lfs-20200901-systemd root=/dev/sda1 ro
}
EOF
