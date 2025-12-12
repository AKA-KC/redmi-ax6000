#!/bin/bash
# File name: diy-part2.sh

# 1. 基础设置
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
if [ -f package/base-files/files/etc/shadow ]; then
    sed -i '/root/c\root:$1$0$0:0:99999:7:::' package/base-files/files/etc/shadow
fi

# 2. 重新写入正确的 Nikki 配置
echo "CONFIG_PACKAGE_luci-app-nikki=y" >> .config
echo "CONFIG_PACKAGE_nikki=y" >> .config

# 3. 顺便加上 DDNS-Go
echo "CONFIG_PACKAGE_luci-app-ddns-go=y" >> .config
echo "CONFIG_PACKAGE_ddns-go=y" >> .config
