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

#!/bin/bash
# File name: diy-part1.sh
# description: 添加第三方插件源 (Kenzok8)

#!/bin/bash
# 只添加 Mihomo (Clash Meta) 源，其他用系统自带的，最稳！
echo "src-git mihomo https://github.com/morytyann/OpenWrt-mihomo" >> feeds.conf.default
