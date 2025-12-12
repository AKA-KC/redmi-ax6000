#!/bin/bash
# File name: diy-part2.sh

# 1. 基础设置
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
if [ -f package/base-files/files/etc/shadow ]; then
    sed -i '/root/c\root:$1$0$0:0:99999:7:::' package/base-files/files/etc/shadow
fi

