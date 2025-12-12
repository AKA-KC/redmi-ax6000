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

# 添加 kenzok8 的 small 仓库 (包含 Nikki, TurboACC, Golang 等全套依赖)
echo 'src-git small https://github.com/kenzok8/small' >>feeds.conf.default
# 添加依赖库
echo 'src-git kenzo https://github.com/kenzok8/openwrt-packages' >>feeds.conf.default
