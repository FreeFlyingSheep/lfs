#!/bin/bash
set -e

DIR=/sources/scripts/software
LOG_DIR=${LFS}/sources/log/chroot/software

mkdir -p ${LOG_DIR}

# 考虑到安装完 Bash 后会替换当前的 bash
# 通过一个额外的参数来判断这是第几次执行该脚本
if [ $1 == "1" ]; then
  tools=(
    'Man-pages-5.08'
    'Tcl-8.6.10'
    'Expect-5.45.4'
    'DejaGNU-1.6.2'
    'Iana-Etc-20200821'
    'Glibc-2.32'
    'Zlib-1.2.11'
    'Bzip2-1.0.8'
    'Xz-5.2.5'
    'Zstd-1.4.5'
    'File-5.39'
    'Readline-8.0'
    'M4-1.4.18'
    'Bc-3.1.5'
    'Flex-2.6.4'
    'Binutils-2.35'
    'GMP-6.2.0'
    'MPFR-4.1.0'
    'MPC-1.2.0'
    'Attr-2.4.48'
    'Acl-2.2.53'
    'Libcap-2.43'
    'Shadow-4.8.1'
    'GCC-10.2.0'
    'Pkg-config-0.29.2'
    'Ncurses-6.2'
    'Sed-4.8'
    'Psmisc-23.3'
    'Gettext-0.21'
    'Bison-3.7.1'
    'Grep-3.4'
    'Bash-5.0'
  )

  dirs=(
    man-pages-5.08
    tcl-8.6.10
    expect-5.45.4
    dejagnu-1.6.2
    iana-etc-20200821
    glibc-2.32
    zlib-1.2.11
    bzip2-1.0.8
    xz-5.2.5
    zstd-1.4.5
    file-5.39
    readline-8.0
    m4-1.4.18
    bc-3.1.5
    flex-2.6.4
    binutils-2.35
    gmp-6.2.0
    mpfr-4.1.0
    mpc-1.2.0
    attr-2.4.48
    acl-2.2.53
    libcap-2.43
    shadow-4.8.1
    gcc-10.2.0
    pkg-config-0.29.2
    ncurses-6.2
    sed-4.8
    psmisc-23.3
    gettext-0.21
    bison-3.7.1
    grep-3.4
    bash-5.0
  )
elif [ $1 == "2" ]; then
  tools=(
    'Libtool-2.4.6'
    'GDBM-1.18.1'
    'Gperf-3.1'
    'Expat-2.2.9'
    'Inetutils-1.9.4'
    'Perl-5.32.0'
    'XML::Parser-2.46'
    'Intltool-0.51.0'
    'Autoconf-2.69'
    'Automake-1.16.2'
    'Kmod-27'
    'Elfutils-0.180 中的 Libelf'
    'Libffi-3.3'
    'OpenSSL-1.1.1g'
    'Python-3.8.5'
    'Ninja-1.10.1'
    'Meson-0.55.1'
    'Coreutils-8.32'
    'Check-0.15.2'
    'Diffutils-3.7'
    'Gawk-5.1.0'
    'Findutils-4.7.0'
    'Groff-1.22.4'
    'GRUB-2.04'
    'Less-551'
    'Gzip-1.10'
    'IPRoute2-5.8.0'
    'Kbd-2.3.0'
    'Libpipeline-1.5.3'
    'Make-4.3'
    'Patch-2.7.6'
    'Man-DB-2.9.3'
    'Tar-1.32'
    'Texinfo-6.7'
    'Vim-8.2.1361'
    'Systemd-246'
    'D-Bus-1.12.20'
    'Procps-ng-3.3.16'
    'Util-linux-2.36'
    'E2fsprogs-1.45.6'
  )

  dirs=(
    libtool-2.4.6
    gdbm-1.18.1
    gperf-3.1
    expat-2.2.9
    inetutils-1.9.4
    perl-5.32.0
    XML-Parser-2.46
    intltool-0.51.0
    autoconf-2.69
    automake-1.16.2
    kmod-27
    elfutils-0.180
    libffi-3.3
    openssl-1.1.1g
    Python-3.8.5
    ninja-1.10.1
    meson-0.55.1
    coreutils-8.32
    check-0.15.2
    diffutils-3.7
    gawk-5.1.0
    findutils-4.7.0
    groff-1.22.4
    grub-2.04
    less-551
    gzip-1.10
    iproute2-5.8.0
    kbd-2.3.0
    libpipeline-1.5.3
    make-4.3
    patch
    man
    tar
    texinfo
    vim
    systemd
    dbus-1.12.20
    procps
    util
    e2fsprogs
  )
fi

for i in ${!tools[@]}
do
  echo "构建 ${tools[i]}……"
  tar -xf ${dirs[i]}.tar.*
  pushd ${dirs[i]} > /dev/null
  time bash ${DIR}/${dirs[i]}.sh > ${LOG_DIR}/${dirs[i]}.log 2>&1
  popd > /dev/null
  rm -rf ${dirs[i]}
  echo -e "构建 ${tools[i]} 完成！\n"
done
