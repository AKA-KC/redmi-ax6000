#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# ------------------ 基础设置区 ------------------

# 1. 设置默认 IP 为 192.168.2.1
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# 2. 设置默认密码为空 (无密码)
sed -i '/CYXluq4wUazHjmCDBCqXF/d' package/lean/default-settings/files/zzz-default-settings

# 3. 修正可能的编译错误 (针对 golang 版本等)
# 移除系统 feeds 自带的 golang，使用最新版本，防止 tailscale/ddns-go 编译失败
rm -rf feeds/packages/lang/golang
git clone https://github.com/kenzok8/golang feeds/packages/lang/golang

# ------------------ 插件添加区 ------------------
# 创建一个专用目录存放手动添加的插件
mkdir -p package/custom

# 【Nikki】(基于 Mihomo 的轻量级代理)
# 核心程序
git clone https://github.com/nikkinolife/openwrt-nikki.git package/custom/openwrt-nikki
# LuCI 界面
git clone https://github.com/nikkinolife/luci-app-nikki.git package/custom/luci-app-nikki

# 【DDNS-Go】
# 官方源可能没有或版本较旧，使用第三方库
git clone https://github.com/sirpdboy/luci-app-ddns-go.git package/custom/luci-app-ddns-go

# 【Tailscale & ZeroTier】
# ImmortalWrt 的官方源通常已经包含这两个，一般不需要手动 clone。
# 如果你发现 menuconfig 里找不到 luci-app-tailscale，可以取消下面这行的注释：
# git clone https://github.com/asvow/luci-app-tailscale package/custom/luci-app-tailscale

# ------------------ 冲突清理区 ------------------

# 如果官方 feed 里有旧版 nikki/mihomo 导致冲突，可以在这里删除它 (一般不需要)
# rm -rf feeds/packages/net/mihomo
