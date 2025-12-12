#!/bin/bash
# File name: diy-part2.sh

# 1. 基础设置
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
if [ -f package/base-files/files/etc/shadow ]; then
    sed -i '/root/c\root:$1$0$0:0:99999:7:::' package/base-files/files/etc/shadow
fi

# 1. 强制开启 Nikki (Mihomo)
# 先删掉可能存在的错误行
sed -i '/CONFIG_PACKAGE_luci-app-nikki/d' .config
sed -i '/CONFIG_PACKAGE_nikki/d' .config
# 强制写入
echo "CONFIG_PACKAGE_luci-app-nikki=y" >> .config
echo "CONFIG_PACKAGE_nikki=y" >> .config

# 2. 强制开启 DDNS-Go
sed -i '/CONFIG_PACKAGE_luci-app-ddns-go/d' .config
sed -i '/CONFIG_PACKAGE_ddns-go/d' .config
echo "CONFIG_PACKAGE_luci-app-ddns-go=y" >> .config
echo "CONFIG_PACKAGE_ddns-go=y" >> .config

# 3. 强制开启组网 (Tailscale)
echo "CONFIG_PACKAGE_luci-app-tailscale=y" >> .config
echo "CONFIG_PACKAGE_tailscale=y" >> .config
