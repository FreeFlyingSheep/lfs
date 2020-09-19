#!/bin/bash
set -e

LOG=${LFS}/sources/log/chroot/chroot.log

# 创建一些位于根目录中的目录
mkdir -pv /{boot,home,mnt,opt,srv} >> ${LOG} 2>&1

# 为这些直接位于根目录中的目录创建次级目录结构
mkdir -pv /etc/{opt,sysconfig} >> ${LOG} 2>&1
mkdir -pv /lib/firmware >> ${LOG} 2>&1
mkdir -pv /media/{floppy,cdrom} >> ${LOG} 2>&1
mkdir -pv /usr/{,local/}{bin,include,lib,sbin,src} >> ${LOG} 2>&1
mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man} >> ${LOG} 2>&1
mkdir -pv /usr/{,local/}share/{misc,terminfo,zoneinfo} >> ${LOG} 2>&1
mkdir -pv /usr/{,local/}share/man/man{1..8} >> ${LOG} 2>&1
mkdir -pv /var/{cache,local,log,mail,opt,spool} >> ${LOG} 2>&1
mkdir -pv /var/lib/{color,misc,locate} >> ${LOG} 2>&1

ln -sfv /run /var/run >> ${LOG} 2>&1
ln -sfv /run/lock /var/lock >> ${LOG} 2>&1

install -dv -m 0750 /root >> ${LOG} 2>&1
install -dv -m 1777 /tmp /var/tmp >> ${LOG} 2>&1

# 为了满足那些需要 /etc/mtab 的工具，创建符号链接
ln -sv /proc/self/mounts /etc/mtab >> ${LOG} 2>&1

# 创建一个基本的 /etc/hosts 文件，一些测试套件，以及 Perl 的一个配置文件将会使用它
echo "127.0.0.1 localhost $(hostname)" > /etc/hosts

# 创建 /etc/passwd 文件
cat > /etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/bin/false
daemon:x:6:6:Daemon User:/dev/null:/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/var/run/dbus:/bin/false
systemd-bus-proxy:x:72:72:systemd Bus Proxy:/:/bin/false
systemd-journal-gateway:x:73:73:systemd Journal Gateway:/:/bin/false
systemd-journal-remote:x:74:74:systemd Journal Remote:/:/bin/false
systemd-journal-upload:x:75:75:systemd Journal Upload:/:/bin/false
systemd-network:x:76:76:systemd Network Management:/:/bin/false
systemd-resolve:x:77:77:systemd Resolver:/:/bin/false
systemd-timesync:x:78:78:systemd Time Synchronization:/:/bin/false
systemd-coredump:x:79:79:systemd Core Dumper:/:/bin/false
nobody:x:99:99:Unprivileged User:/dev/null:/bin/false
EOF

# 创建 /etc/group 文件
cat > /etc/group << "EOF"
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
systemd-journal:x:23:
input:x:24:
mail:x:34:
kvm:x:61:
systemd-bus-proxy:x:72:
systemd-journal-gateway:x:73:
systemd-journal-remote:x:74:
systemd-journal-upload:x:75:
systemd-network:x:76:
systemd-resolve:x:77:
systemd-timesync:x:78:
systemd-coredump:x:79:
wheel:x:97:
nogroup:x:99:
users:x:999:
EOF

# 一些测试需要使用一个普通用户
# 自动构建 LFS，跳过所有难以评估的测试，我们不需要创建这个用户
# echo "tester:x:$(ls -n $(tty) | cut -d" " -f3):101::/home/tester:/bin/bash" >> /etc/passwd
# echo "tester:x:101:" >> /etc/group
# install -o tester -d /home/tester

# 由于已经创建了文件 /etc/passwd 和 /etc/group，用户名和组名现在就可以正常解析了
# 需要打开一个新 shell
# 通过管道来指定新 shell 中需要执行的命令
# build.sh 为 chroot/build.sh 的拷贝
exec /bin/bash --login +h << "EOF"
set -e

bash /sources/scripts/build.sh
EOF
