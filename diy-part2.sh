#!/bin/bash
# File name: diy-part2.sh
# description: 修复递归依赖死循环 + 系统设置

# 1. 基础设置
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
if [ -f package/base-files/files/etc/shadow ]; then
    sed -i '/root/c\root:$1$0$0:0:99999:7:::' package/base-files/files/etc/shadow
fi

# 2. 【核心修复】删除导致死循环的 fchomo
# Kenzok8 源里的这个包会导致 Nikki 被强制剔除，必须删掉！
echo "🔥 正在移除冲突包 fchomo..."
rm -rf feeds/small/luci-app-fchomo
rm -rf feeds/small/fchomo
rm -rf package/feeds/small/luci-app-fchomo
rm -rf package/feeds/small/fchomo

# 3. 重新安装 Feeds (刷新索引)
# 删了坏包后，必须刷新一下，让编译器重新计算依赖
./scripts/feeds update -a
./scripts/feeds install -a

echo "🎉 修复完成！死循环已打破，Nikki 应该能正常编译了。"
