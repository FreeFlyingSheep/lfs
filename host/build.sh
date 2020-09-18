#!/bin/bash
set -e

# 1. 引言
# 2. 准备宿主系统
echo "创建并挂载虚拟磁盘……"
bash host/disk.sh > ${LOG_DIR}/disk.log 2>&1
echo -e "创建并挂载虚拟磁盘完成！\n"

# 3. 软件包和补丁
echo "下载并检查软件包……"
bash host/download.sh > ${LOG_DIR}/download.log 2>&1
echo -e "下载并检查软件包完成！\n"

# 4. 最后准备工作
# 5. 编译交叉工具链
# 6. 交叉编译临时工具
# 这几个步骤在自动构建流程中是一个整体，涉及切换用户，很难分割
# host/prepare.sh 完成第 4 步，切换到 lfs 用户并把后续的任务交给 lfs/init.sh
# lfs/init.sh 完成第 5 步的前半部分，把后续的任务交给 lfs/build.sh
# lfs/build.sh 完成第 5 步的后半部分和第 6 步
bash host/lfs.sh

# 移动日志文件
mv ${LFS}/sources/log/* ${LOG_DIR}

# 7. 进入 Chroot 并构建其他临时工具
# 8. 安装基本系统软件
# 9. 系统配置
# 10. 使 LFS 系统可引导
# 11. 尾声
# 同理，这几个步骤在自动构建流程中是一个整体，涉及 Chroot，很难分割
# chroot/init.sh 完成第 7 步的前半部分，把后续的任务交给 chroot/build.sh
# chroot/build.sh 完成第 7 步的后半部分和第 8 步，把后续任务交给 chroot/config.sh
# chroot/config.sh 完成第 9 步，把后续任务交给 chroot/config.sh
# chroot/boot.sh 完成第 10 步和第 11 步的前半部分，然后回到 host/chroot.sh 继续执行
bash host/chroot.sh

# 移动日志文件
mv $LFS/sources/log/* ${LOG_DIR}

# 删除没用的日志文件和目录
rmdir $LFS/sources/log
rmdir -v ${LFS}
