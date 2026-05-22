#!/bin/bash

# =========================================
# 删除冲突与无用包
# =========================================

# 删除旧版 PassWall
rm -rf feeds/luci/applications/luci-app-passwall

# 删除冲突核心
rm -rf feeds/packages/net/xray-core
rm -rf feeds/packages/net/v2ray-core
rm -rf feeds/packages/net/sing-box

# 删除 OpenClash（避免和 Nikki/PassWall 冲突）
rm -rf feeds/luci/applications/luci-app-openclash

# 删除 mosdns（避免 DNS 冲突）
rm -rf feeds/packages/net/mosdns

# =========================================
# 更新 feeds 前预处理
# =========================================

# 强制关闭 IPv6
sed -i 's/CONFIG_IPV6=y/CONFIG_IPV6=n/g' .config || true

# =========================================
# 默认 IP 修改（避免192.168.1.1冲突）
# =========================================

sed -i 's/192.168.1.1/192.168.11.1/g' package/base-files/files/bin/config_generate

# =========================================
# 默认主机名
# =========================================

sed -i 's/OpenWrt/ImmortalWrt-Pro/g' package/base-files/files/bin/config_generate

# =========================================
# 默认 shell 改 bash
# =========================================

sed -i 's#/bin/ash#/bin/bash#g' package/base-files/files/etc/passwd

# =========================================
# 默认时区
# =========================================

sed -i "s#UTC#Asia/Shanghai#g" package/base-files/files/bin/config_generate

# =========================================
# 默认 NTP
# =========================================

sed -i "s#0.openwrt.pool.ntp.org#ntp.aliyun.com#g" package/base-files/files/bin/config_generate
sed -i "s#1.openwrt.pool.ntp.org#time1.cloud.tencent.com#g" package/base-files/files/bin/config_generate

echo "DIY-PART1 完成"
