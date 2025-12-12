#!/bin/bash
# File name: diy-part2.sh
# description: 插件下载与配置脚本 (暴力搜索修复版)

# -----------------------------------------------------------------------------
# 1. 系统基础设置
# -----------------------------------------------------------------------------
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

if [ -f package/base-files/files/etc/shadow ]; then
    sed -i '/root/c\root:$1$0$0:0:99999:7:::' package/base-files/files/etc/shadow
fi

# -----------------------------------------------------------------------------
# 2. 编译环境修复
# -----------------------------------------------------------------------------
rm -rf feeds/packages/lang/golang
git clone https://github.com/kenzok8/golang feeds/packages/lang/golang

# -----------------------------------------------------------------------------
# 3. 插件下载 (使用 Find 命令暴力查找)
# -----------------------------------------------------------------------------
mkdir -p package/custom

echo "⬇️ 正在下载 DDNS-Go..."
git clone https://github.com/sirpdboy/luci-app-ddns-go.git package/custom/luci-app-ddns-go

echo "⬇️ 正在下载 Tailscale..."
git clone https://github.com/asvow/luci-app-tailscale package/custom/luci-app-tailscale

echo "⬇️ 正在下载 Nikki 和 TurboACC (使用 small-package 源)..."
# 换用 small-package，这里面插件最全
git clone --depth 1 https://github.com/kenzok8/small-package.git package/temp_small

# --- 智能提取 Nikki ---
echo "🔍 正在搜索 Nikki..."
# 使用 find 命令查找名为 luci-app-nikki 的文件夹，找到后直接复制
find package/temp_small -type d -name "luci-app-nikki" -exec cp -r {} package/custom/ \;
find package/temp_small -type d -name "nikki" -exec cp -r {} package/custom/ \;

# 验证提取结果
if [ -d "package/custom/luci-app-nikki" ]; then
    echo "✅ Nikki 提取成功！"
else
    echo "❌ 警告：依然没找到 Nikki，正在尝试备用方案 (Mihomo)..."
    # 备用：既然 Nikki 实在找不到，就下载 Mihomo 代替，防止编译为空
    # 并自动修改 .config 文件，把 nikki 换成 mihomo (防止编译报错)
    git clone https://github.com/morytyann/OpenWrt-mihomo.git package/custom/luci-app-mihomo
    sed -i 's/CONFIG_PACKAGE_luci-app-nikki=y/CONFIG_PACKAGE_luci-app-mihomo=y/g' .config
    sed -i 's/CONFIG_PACKAGE_nikki=y/CONFIG_PACKAGE_mihomo=y/g' .config
fi

# --- 智能提取 TurboACC ---
echo "🔍 正在搜索 TurboACC..."
find package/temp_small -type d -name "luci-app-turboacc" -exec cp -r {} package/custom/ \;

# 清理临时文件
rm -rf package/temp_small

echo "🎉 脚本执行完毕"
