#!/bin/bash
set -e

## 0. 说明
# 本脚本遵循 MIT 协议
# 本脚本用于自动构建 LFS systemd 10.0
# 目前本脚本还未完成！
VERSION=0.1

## 1. 引言

echo "    __    ___________"
echo "   / /   / ____/ ___/"
echo "  / /   / /_   \__ \ "
echo " / /___/ __/  ___/ / "
echo "/_____/_/    /____/  "

echo -e "\n自动构建 LFS systemd 10.0，脚本版本 v$VERSION\n"

if [ `id -u` -ne 0 ];then
  echo "必须用 root 用户执行该脚本！"
  exit 1
fi

## 2. 准备宿主系统

echo "检查宿主机环境……"
bash << "EOF"
export LC_ALL=C
bash --version | head -n1 | cut -d" " -f2-4
MYSH=$(readlink -f /bin/sh)
echo "/bin/sh -> $MYSH"
echo $MYSH | grep -q bash || echo "ERROR: /bin/sh does not point to bash"
unset MYSH

echo -n "Binutils: "; ld --version | head -n1 | cut -d" " -f3-
bison --version | head -n1

if [ -h /usr/bin/yacc ]; then
  echo "/usr/bin/yacc -> `readlink -f /usr/bin/yacc`";
elif [ -x /usr/bin/yacc ]; then
  echo yacc is `/usr/bin/yacc --version | head -n1`
else
  echo "yacc not found" 
fi

bzip2 --version 2>&1 < /dev/null | head -n1 | cut -d" " -f1,6-
echo -n "Coreutils: "; chown --version | head -n1 | cut -d")" -f2
diff --version | head -n1
find --version | head -n1
gawk --version | head -n1

if [ -h /usr/bin/awk ]; then
  echo "/usr/bin/awk -> `readlink -f /usr/bin/awk`";
elif [ -x /usr/bin/awk ]; then
  echo awk is `/usr/bin/awk --version | head -n1`
else 
  echo "awk not found" 
fi

gcc --version | head -n1
g++ --version | head -n1
ldd --version | head -n1 | cut -d" " -f2-  # glibc version
grep --version | head -n1
gzip --version | head -n1
cat /proc/version
m4 --version | head -n1
make --version | head -n1
patch --version | head -n1
echo Perl `perl -V:version`
python3 --version
sed --version | head -n1
tar --version | head -n1
makeinfo --version | head -n1  # texinfo version
xz --version | head -n1

echo 'int main(){}' > dummy.c && g++ -o dummy dummy.c
if [ -x dummy ]
  then echo "g++ compilation OK";
  else echo "g++ compilation failed"; fi
rm -f dummy.c dummy
EOF

echo "在执行下一步前，请确保宿主机环境正确配置："
select choice in "继续执行" "退出"; do
case ${choice} in
  "继续执行")
    break
    ;;
  "退出")
    exit 0
    ;;
  *)
    echo "无效的选项，请重试："
    ;;
esac
done

# 导出 $LFS 环境变量
export LFS=/mnt/lfs

echo "创建并挂载虚拟磁盘……"
# 创建 20G 的虚拟磁盘 disk.img
dd if=/dev/zero of=disk.img bs=1M count=0 seek=10240
# 把虚拟磁盘采用 mbr 形式分区
parted -s disk.img mklabel msdos
# 把虚拟磁盘虚拟为块设备
disk=`losetup -f --show disk.img`
# 为虚拟磁盘分配一个根分区
parted -s /dev/loop0 mkpart primary 0 100%
# 格式化分区为 ext4 文件系统
yes | mkfs -v -t ext4 $disk
# 创建 /mnt/lfs
mkdir -pv $LFS
# 挂载虚拟磁盘
mount -v $disk $LFS

## 3. 软件包和补丁

mkdir -pv $LFS/sources
if [ -f lfs-packages-10.0.tar ]; then
  echo "复制软件包……"
  cp lfs-packages-10.0.tar /mnt/sources
else
  echo "下载软件包……"
  # 下载 lfs-packages-10.0.tar
  wget -c -P $LFS/sources http://ftp.lfs-matrix.net/pub/lfs/lfs-packages/lfs-packages-10.0.tar
fi
# 解包至 $LFS/sources
tar xvf lfs-packages-10.0.tar -C $LFS/sources
pushd $LFS/sources
# 处理多余的 10.0 文件夹
  mv 10.0/* . 
  rmdir 10.0
# 检查软件包
  md5sum -c md5sums
popd

## 4. 最后准备工作

## 5. 编译交叉工具链

## 6. 交叉编译临时工具

## 7. 进入 Chroot 并构建其他临时工具

## 8. 安装基本系统软件

## 9. 系统配置

## 10. 使 LFS 系统可引导

## 11. 尾声

echo "卸载虚拟磁盘……"
# 卸载虚拟磁盘
umount -v $LFS
# 卸除虚拟的块设备
losetup -d $disk

echo "完成！"
exit 0
