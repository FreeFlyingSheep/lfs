#!/bin/bash
set -e

# 指定并行构建数目
export MAKEFLAGS='-j8'

cd /sources

# 构建其他临时工具
echo "构建其他临时工具……"
bash /sources/scripts/tools.sh
echo -e "构建其他临时工具完成！\n"

echo "清理临时系统……"
# .la 文件仅在链接到静态库时有用
# 在使用动态共享库时它们没有意义，甚至有害，特别是对于非 autotools 构建系统
# 运行命令删除它们
find /usr/{lib,libexec} -name \*.la -delete

# 删除临时工具的文档，以防止它们进入最终构建的系统
rm -rf /usr/share/{info,man,doc}/*
echo -e "清理临时系统完成！\n"

# 自动构建 LFS，没有必要备份临时系统，因此不需要退出 Chroot
# exit
# umount $LFS/dev{/pts,}
# umount $LFS/{sys,proc,run}
# ...

# 安装基本系统软件
# 参数 1 代表第一次执行 software.sh
echo "安装基本系统软件……"
bash /sources/scripts/software.sh 1
echo -e "安装基本系统软件完成！\n"

# 我们不移除调试符号，虚拟磁盘镜像大小是固定的，也无法节省这些空间
# 如果系统不是为程序员设计的，也没有调试系统软件的计划
# 可以通过从二进制程序和库移除调试符号，将系统的体积减小约 2 GB
# 除了无法再调试全部软件外，这不会造成任何不便
# 首先将一些库的调试符号保存在单独的文件中
# save_lib="ld-2.32.so libc-2.32.so libpthread-2.32.so libthread_db-1.0.so"

# cd /lib

# for LIB in $save_lib; do
#     objcopy --only-keep-debug $LIB $LIB.dbg 
#     strip --strip-unneeded $LIB
#     objcopy --add-gnu-debuglink=$LIB.dbg $LIB 
# done    

# save_usrlib="libquadmath.so.0.0.0 libstdc++.so.6.0.28
#              libitm.so.1.0.0 libatomic.so.1.2.0" 

# cd /usr/lib

# for LIB in $save_usrlib; do
#     objcopy --only-keep-debug $LIB $LIB.dbg
#     strip --strip-unneeded $LIB
#     objcopy --add-gnu-debuglink=$LIB.dbg $LIB
# done

# unset LIB save_lib save_usrlib

# 现在即可移除程序和库的调试符号
# find /usr/lib -type f -name \*.a \
#    -exec strip --strip-debug {} ';'

# find /lib /usr/lib -type f -name \*.so* ! -name \*dbg \
#    -exec strip --strip-unneeded {} ';'

# find /{bin,sbin} /usr/{bin,sbin,libexec} -type f \
#     -exec strip --strip-all {} ';'
