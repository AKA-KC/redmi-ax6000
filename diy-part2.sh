#!/bin/bash
# File name: diy-part2.sh
# description: 系统设置

# 1. 修改默认 IP 为 192.168.2.1
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# 2. 移除默认密码 (空密码)
if [ -f package/base-files/files/etc/shadow ]; then
    sed -i '/root/c\root:$1$0$0:0:99999:7:::' package/base-files/files/etc/shadow
fi

# 3. 修复部分依赖 (由于使用了 feed 源，这里不需要再手动搞 Golang 了)
# 但为了保险，我们可以再次运行一次 feed 安装
./scripts/feeds update -a
./scripts/feeds install -a
