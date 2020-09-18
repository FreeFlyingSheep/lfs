#!/bin/bash
set -e

LOG=${LOG_DIR}/lfs.log

echo "创建目录布局……"
mkdir -pv $LFS/{bin,etc,lib,sbin,usr,var} >> ${LOG} 2>&1
case $(uname -m) in
  x86_64) mkdir -pv $LFS/lib64  >> ${LOG} 2>&1 ;;
esac
# 交叉编译器目录
mkdir -pv $LFS/tools >> ${LOG} 2>&1
echo -e "创建目录布局完成！\n"

echo "添加 lfs 用户……"
groupadd lfs >> ${LOG} 2>&1
useradd -s /bin/bash -g lfs -m -k /dev/null lfs >> ${LOG} 2>&1
passwd lfs >> ${LOG} 2>&1 << "EOF"
123456
123456
EOF
echo -e "添加 lfs 用户完成！\n"

# 一些商业发行版未做文档说明地将 /etc/bash.bashrc 引入 bash 初始化过程
# 该文件可能修改 lfs 用户的环境，并影响 LFS 关键软件包的构建
# 为了保证 lfs 用户环境的纯净，检查 /etc/bash.bashrc 是否存在，如果它存在就将它移走
[ ! -e /etc/bash.bashrc.NOUSE ] ||\
mv -v /etc/bash.bashrc /etc/bash.bashrc.NOUSE >> ${LOG} 2>&1

# 将相应的脚本拷贝到 lfs 家目录以及源码目录
echo "拷贝脚本到指定目录……"
cp -rv chroot $LFS/sources >> ${LOG} 2>&1
mv -v $LFS/sources/chroot $LFS/sources/scripts >> ${LOG} 2>&1
cp -rv lfs /home/lfs/ >> ${LOG} 2>&1
mv -v /home/lfs/lfs /home/lfs/scripts >> ${LOG} 2>&1
# 改变 lfs 家目录下的脚本所有者，源码目录下的脚本所有者保持 root，无需更改
chown -Rv lfs /home/lfs/scripts >> ${LOG} 2>&1
echo -e "拷贝脚本到指定目录完成！\n"

# 将 lfs 设为 $LFS 中所有目录的所有者，使 lfs 对它们拥有完全访问权
echo "改变目录所有者……"
chown -v lfs $LFS/{usr,lib,var,etc,bin,sbin,tools} >> ${LOG} 2>&1
case $(uname -m) in
  x86_64) chown -v lfs $LFS/lib64 >> ${LOG} 2>&1 ;;
esac
# 改变源码目录所有者
chown -v lfs $LFS/sources >> ${LOG} 2>&1
echo -e "改变目录所有者完成！\n"

# 通过管道来指定切换用户后需要执行的命令
# init.sh 为 lfs/init.sh 的拷贝
echo "切换到 lfs 用户……"
su - lfs << "EOF"
echo -e "切换到 lfs 用户完成！\n"
bash ~/scripts/init.sh

echo "退出 lfs 用户……"
exit 0
EOF
echo -e "退出 lfs 用户完成\n"

echo "删除 lfs 用户……"
userdel -r lfs >> ${LOG} 2>&1
echo -e "删除 lfs 用户完成！\n"

# 恢复 /etc/bash.bashrc
[ ! -e /etc/bash.bashrc.NOUSE ] ||\
mv -v /etc/bash.bashrc.NOUSE /etc/bash.bashrc >> ${LOG} 2>&1
