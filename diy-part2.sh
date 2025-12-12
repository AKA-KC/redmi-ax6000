#!/bin/bash
# File name: diy-part2.sh
# description: 修复 Nikki/Tailscale 依赖丢失的终极方案

# 1. 基础设置
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
if [ -f package/base-files/files/etc/shadow ]; then
    sed -i '/root/c\root:$1$0$0:0:99999:7:::' package/base-files/files/etc/shadow
fi

# 2. 【关键修复】使用 sbwml 的 Golang 源 (解决依赖断裂问题)
# 先删除系统自带的 golang
rm -rf feeds/packages/lang/golang
#以此拉取高兼容版本的 golang
git clone https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang

# 3. 下载插件源码
mkdir -p package/custom

echo "⬇️ 下载插件..."
# DDNS-Go
git clone https://github.com/sirpdboy/luci-app-ddns-go.git package/custom/luci-app-ddns-go
# Tailscale
git clone https://github.com/asvow/luci-app-tailscale package/custom/luci-app-tailscale

# Nikki & TurboACC (从 kenzok8/small-package 提取)
git clone --depth 1 https://github.com/kenzok8/small-package.git package/temp_small

echo "🔍 提取 Nikki & TurboACC..."
# 提取 Nikki
find package/temp_small -type d -name "luci-app-nikki" -exec cp -r {} package/custom/ \;
find package/temp_small -type d -name "nikki" -exec cp -r {} package/custom/ \;
# 提取 TurboACC
find package/temp_small -type d -name "luci-app-turboacc" -exec cp -r {} package/custom/ \;

# 清理垃圾
rm -rf package/temp_small

# 4. 【最后一步】重置 Feeds 索引
# 这一步至关重要，它会让编译器重新认识刚才替换的 Golang
./scripts/feeds install -a

echo "🎉 修复完成！依赖链已重接。"
