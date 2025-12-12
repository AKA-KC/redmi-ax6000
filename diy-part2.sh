#!/bin/bash
# File name: diy-part2.sh
# description: 插件下载 + 依赖修复 (修复 Nikki 丢失问题)

# -----------------------------------------------------------------------------
# 1. 系统基础设置
# -----------------------------------------------------------------------------
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

if [ -f package/base-files/files/etc/shadow ]; then
    sed -i '/root/c\root:$1$0$0:0:99999:7:::' package/base-files/files/etc/shadow
fi

# -----------------------------------------------------------------------------
# 2. 编译环境修复 (这一步破坏了原来的索引，后面必须修复)
# -----------------------------------------------------------------------------
rm -rf feeds/packages/lang/golang
git clone https://github.com/kenzok8/golang feeds/packages/lang/golang

# -----------------------------------------------------------------------------
# 3. 插件下载
# -----------------------------------------------------------------------------
mkdir -p package/custom

echo "⬇️ 正在下载 DDNS-Go..."
git clone https://github.com/sirpdboy/luci-app-ddns-go.git package/custom/luci-app-ddns-go

echo "⬇️ 正在下载 Tailscale..."
git clone https://github.com/asvow/luci-app-tailscale package/custom/luci-app-tailscale

echo "⬇️ 正在下载 Nikki 和 TurboACC (使用 small-package 源)..."
git clone --depth 1 https://github.com/kenzok8/small-package.git package/temp_small

# 智能提取
echo "🔍 正在搜索插件..."
find package/temp_small -type d -name "luci-app-nikki" -exec cp -r {} package/custom/ \;
find package/temp_small -type d -name "nikki" -exec cp -r {} package/custom/ \;
find package/temp_small -type d -name "luci-app-turboacc" -exec cp -r {} package/custom/ \;

rm -rf package/temp_small

# -----------------------------------------------------------------------------
# 4. 【核心修复】重新安装 Feeds
# -----------------------------------------------------------------------------
# 因为我们在第2步替换了 Golang，必须运行这步来修复断裂的软链接！
# 否则编译器找不到 Go 环境，就会把依赖 Go 的插件（Nikki/Tailscale）全部丢弃。
./scripts/feeds install -a

echo "🎉 修复完成，依赖已重置！"
