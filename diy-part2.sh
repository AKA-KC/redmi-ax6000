#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# =========================================================
# 1. 基础系统设置 (修复路径错误)
# =========================================================

# 修改默认 IP 为 192.168.2.1
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# 设置默认密码为空 (修复：使用通用方式修改 shadow 文件，适配 ImmortalWrt)
# 如果文件不存在则跳过，避免报错中断
if [ -f package/base-files/files/etc/shadow ]; then
    sed -i '/root/c\root:$1$0$0:0:99999:7:::' package/base-files/files/etc/shadow
fi

# =========================================================
# 2. 编译环境修复
# =========================================================

# 移除旧版 Golang，拉取最新版 (Tailscale/DDNS-Go 必须)
rm -rf feeds/packages/lang/golang
git clone https://github.com/kenzok8/golang feeds/packages/lang/golang

# =========================================================
# 3. 添加插件源码 (修复下载失败问题)
# =========================================================

mkdir -p package/custom

# 【DDNS-Go】
git clone https://github.com/sirpdboy/luci-app-ddns-go.git package/custom/luci-app-ddns-go

# 【Tailscale】
git clone https://github.com/asvow/luci-app-tailscale package/custom/luci-app-tailscale

# 【Nikki】(关键修复)
# 原来的独立仓库挂了，我们从 kiddin9 的大仓库里把 Nikki 提取出来
# 1. 先把 kiddin9 的仓库拉到一个临时文件夹
git clone --depth 1 https://github.com/kiddin9/openwrt-packages.git package/temp_kiddin9

# 2. 复制 Nikki 相关的包到 custom 目录
if [ -d "package/temp_kiddin9/nikki" ]; then
    cp -r package/temp_kiddin9/nikki package/custom/
    cp -r package/temp_kiddin9/luci-app-nikki package/custom/
else
    # 备选方案：如果目录结构变了，尝试从另一个源拉取 Mihomo (Nikki 的核心)
    echo "Warning: Nikki not found in primary source, trying backup..."
    git clone https://github.com/morytyann/OpenWrt-mihomo.git package/custom/luci-app-mihomo
fi

# 3. 删除临时文件夹，清理垃圾
rm -rf package/temp_kiddin9
