#!/bin/bash
set -e

# 修改 vimrc 配置文件的默认位置为 /etc
echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h

# 配置 Vim
./configure --prefix=/usr

# 编译 Vim
make

# 为了准备运行测试套件，需要使得 tester 用户拥有写入源代码目录树的权限
# chown -Rv tester .
# 以 tester 用户身份运行测试
# su tester -c "LANG=en_US.UTF-8 make -j1 test" &> vim-test.log

# 安装 Vim
make install

# 为了在用户习惯性地输入 vi 时能够执行 vim
# 为二进制程序和各种语言的 man 页面创建符号链接
ln -sv vim /usr/bin/vi
for L in  /usr/share/man/{,*/}man1/vim.1; do
  ln -sv vim.1 $(dirname $L)/vi.1
done

# 默认情况下，vim 在不兼容 vi 的模式下运行
# 这对于过去使用其他编辑器的用户来说可能显得陌生
# 以下配置包含的 “nocompatible” 设定是为了强调编辑器使用了新的行为这一事实
# 它也提醒那些想要使用 “compatible” 模式的用户，必须在配置文件的一开始改变模式
# 这是因为它会修改其他设置，对这些设置的覆盖必须在设定模式后进行
# 执行以下命令创建默认 vim 配置文件
cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

" Ensure defaults are set before customizing settings, not after
source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1 

set nocompatible
set backspace=2
set mouse=
syntax on
if (&term == "xterm") || (&term == "putty")
  set background=dark
endif

" End /etc/vimrc
EOF
