#!/bin/bash
set -e

# 在 x86_64 上构建时，修改存放 64 位库的默认路径为 lib
case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac

# GCC 文档推荐在专用的构建目录中构建 GCC
mkdir -v build
cd       build

# 配置 GCC
../configure --prefix=/usr            \
             LD=ld                    \
             --enable-languages=c,c++ \
             --disable-multilib       \
             --disable-bootstrap      \
             --with-system-zlib

# 编译 GCC
make

# 已知 GCC 测试套件中的一组测试可能耗尽默认栈空间，因此运行测试前要增加栈空间
# ulimit -s 32768
# 以非特权用户身份测试 GCC，但出错时继续执行其他测试
# chown -Rv tester . 
# su tester -c "PATH=$PATH make -k check"
# 输入以下命令查看测试结果的摘要
# ../contrib/test_summary
# 如果只想看摘要，将输出用管道送至 grep -A7 Summ
# 我们跳过测试，尽管它非常重要

# 安装 GCC，并移除一个不需要的目录
make install
rm -rf /usr/lib/gcc/$(gcc -dumpmachine)/10.2.0/include-fixed/bits/

# GCC 构建目录目前属于用户 tester，这会导致安装的头文件目录 (及其内容) 具有不正确的所有权
# 将所有者修改为 root 用户和组
# 我们并未使用测试用户，跳过这些步骤
# chown -v -R root:root \
#     /usr/lib/gcc/*linux-gnu/10.2.0/include{,-fixed}

# 创建一个 FHS 因 “历史原因” 要求的符号链接
ln -sv ../usr/bin/cpp /lib

# 创建一个兼容性符号链接，以支持在构建程序时使用链接时优化 (LTO)
install -v -dm755 /usr/lib/bfd-plugins
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/10.2.0/liblto_plugin.so \
        /usr/lib/bfd-plugins/

# 进行一些完整性检查，进行确认
echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
MSG=`readelf -l a.out | grep ': /lib'`
echo "$MSG" | grep -q '[Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]'

# 确认我们的设定能够使用正确的启动文件
MSG=`grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log`
echo "$MSG" | grep -q '/usr/lib/gcc/x86_64-pc-linux-gnu/10.2.0/../../../../lib/crt1.o succeeded'
echo "$MSG" | grep -q '/usr/lib/gcc/x86_64-pc-linux-gnu/10.2.0/../../../../lib/crti.o succeeded'
echo "$MSG" | grep -q '/usr/lib/gcc/x86_64-pc-linux-gnu/10.2.0/../../../../lib/crtn.o succeeded'

# 确认编译器能正确查找头文件
MSG=`grep -B4 '^ /usr/include' dummy.log`
echo "$MSG" | grep -q '#include <...> search starts here:'
echo "$MSG" | grep -q '/usr/lib/gcc/x86_64-pc-linux-gnu/10.2.0/include'
echo "$MSG" | grep -q '/usr/local/include'
echo "$MSG" | grep -q '/usr/lib/gcc/x86_64-pc-linux-gnu/10.2.0/include-fixed'
echo "$MSG" | grep -q '/usr/include'

# 确认新的链接器使用了正确的搜索路径
MSG=`grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'`
echo "$MSG" | grep -q 'SEARCH_DIR("/usr/x86_64-pc-linux-gnu/lib64")'
echo "$MSG" | grep -q 'SEARCH_DIR("/usr/local/lib64")'
echo "$MSG" | grep -q 'SEARCH_DIR("/lib64")'
echo "$MSG" | grep -q 'SEARCH_DIR("/usr/lib64")'
echo "$MSG" | grep -q 'SEARCH_DIR("/usr/x86_64-pc-linux-gnu/lib")'
echo "$MSG" | grep -q 'SEARCH_DIR("/usr/local/lib")'
echo "$MSG" | grep -q 'SEARCH_DIR("/lib")'
echo "$MSG" | grep -q 'SEARCH_DIR("/usr/lib");'

# 确认我们使用了正确的 libc
MSG=`grep "/lib.*/libc.so.6 " dummy.log`
echo "$MSG" | grep -q 'attempt to open /lib/libc.so.6 succeeded'

# 确认 GCC 使用了正确的动态链接器
MSG=`grep found dummy.log`
echo "$MSG" | grep -q 'found ld-linux-x86-64.so.2 at /lib/ld-linux-x86-64.so.2'

# 删除测试文件
rm -v dummy.c a.out dummy.log

unset MSG

# 移动一个位置不正确的文件
mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib
