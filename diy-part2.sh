#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# =========================================================
# 1. 基础系统设置
# =========================================================

# 修改默认 IP 为 192.168.2.1
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# 设置默认密码为空 (移除默认密码)
sed -i '/CYXluq4wUazHjmCDBCqXF/d' package/lean/default-settings/files/zzz-default-settings

# =========================================================
# 2. 编译环境修复 (关键步骤)
# =========================================================

# 移除旧版 Golang，拉取最新版
# (Tailscale 和 DDNS-Go 都是 Go 语言写的，这一步不做会导致编译失败)
rm -rf feeds/packages/lang/golang
git clone https://github.com/kenzok8/golang feeds/packages/lang/golang

# =========================================================
# 3. 添加插件源码 (Nikki & DDNS-Go)
# =========================================================

# 创建自定义包目录
mkdir -p package/custom

# 添加 Nikki (Clash Meta 客户端)
git clone https://github.com/nikkinolife/openwrt-nikki.git package/custom/openwrt-nikki
git clone https://github.com/nikkinolife/luci-app-nikki.git package/custom/luci-app-nikki

# 添加 DDNS-Go (动态域名)
git clone https://github.com/sirpdboy/luci-app-ddns-go.git package/custom/luci-app-ddns-go

# (可选) Tailscale 和 ZeroTier 通常在官方 feeds 里有，
# 如果编译时找不到，可以取消下面这行的注释来手动拉取 Tailscale：
# git clone https://github.com/asvow/luci-app-tailscale package/custom/luci-app-tailscale
