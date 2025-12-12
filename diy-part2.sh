#!/bin/bash
# File name: diy-part2.sh
# description: 插件下载与配置脚本 (修复 Nikki 下载失败问题)

# -----------------------------------------------------------------------------
# 1. 系统基础设置
# -----------------------------------------------------------------------------
# 修改默认 IP 为 192.168.2.1
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# 移除默认密码 (适配 ImmortalWrt)
if [ -f package/base-files/files/etc/shadow ]; then
    sed -i '/root/c\root:$1$0$0:0:99999:7:::' package/base-files/files/etc/shadow
fi

# -----------------------------------------------------------------------------
# 2. 编译环境修复 (Tailscale 必须)
# -----------------------------------------------------------------------------
# 移除旧版 Golang，换成 kenzok8 的新版
rm -rf feeds/packages/lang/golang
git clone https://github.com/kenzok8/golang feeds/packages/lang/golang

# -----------------------------------------------------------------------------
# 3. 插件下载 (更稳的源)
# -----------------------------------------------------------------------------
mkdir -p package/custom

echo "⬇️ 正在下载 DDNS-Go..."
git clone https://github.com/sirpdboy/luci-app-ddns-go.git package/custom/luci-app-ddns-go

echo "⬇️ 正在下载 Tailscale..."
git clone https://github.com/asvow/luci-app-tailscale package/custom/luci-app-tailscale

echo "⬇️ 正在下载 Nikki (使用 Kenzok8 源提取)..."
# 【关键修改】使用 kenzok8 的仓库，这里比较稳
git clone --depth 1 https://github.com/kenzok8/openwrt-packages.git package/temp_kenzo

# 提取 Nikki 和 依赖
if [ -d "package/temp_kenzo/luci-app-nikki" ]; then
    cp -r package/temp_kenzo/luci-app-nikki package/custom/
    cp -r package/temp_kenzo/nikki package/custom/
    echo "✅ Nikki 提取成功！"
else
    echo "❌ 错误：无法提取 Nikki，请检查网络或源。"
fi

# 提取 TurboACC (顺便从这个大仓库里拿，比官方源稳)
if [ -d "package/temp_kenzo/luci-app-turboacc" ]; then
    cp -r package/temp_kenzo/luci-app-turboacc package/custom/
    echo "✅ TurboACC 提取成功！"
fi

# 清理临时文件
rm -rf package/temp_kenzo

echo "🎉 所有插件准备完成！"
