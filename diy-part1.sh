#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
# sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
# echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
# echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

# 注意：
# 你需要的 Nikki, Tailscale, DDNS-Go 等插件
# 我们已经全部安排在 diy-part2.sh 里处理了。
# 这个文件留空或者保持默认即可，不需要添加任何代码。

# 添加 Mihomo 源
echo "src-git mihomo https://github.com/morytyann/OpenWrt-mihomo" >> feeds.conf.default

# 添加 DDNS-Go 源 (如果官方源里没有，建议加上这个保险)
echo "src-git ddns_go https://github.com/sirpdboy/luci-app-ddns-go" >> feeds.conf.default
