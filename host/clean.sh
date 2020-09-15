#!/bin/bash
set -e

echo "清理上次的构建……"

if [ -f ${DISK_LOG} ]; then
  bash host/umount.sh
fi

rm -f ${DISK}
rm -f ${DISK_LOG}
rm -f ${PROGRESS_LOG}
rm -f ${STATE_LOG}
