#!/bin/bash

# =========================================
# 默认主题
# =========================================

sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# =========================================
# 创建首次启动优化脚本
# =========================================

mkdir -p files/etc/uci-defaults

cat > files/etc/uci-defaults/99-custom << 'EOF'
#!/bin/sh

# =========================================
# IPv6 全关闭
# =========================================

uci set network.lan.ipv6='0'

uci delete network.wan6 2>/dev/null

uci set dhcp.lan.dhcpv6='disabled'
uci set dhcp.lan.ra='disabled'
uci set dhcp.lan.ndp='disabled'

uci commit network
uci commit dhcp

/etc/init.d/network restart

# =========================================
# 防火墙优化
# =========================================

uci set firewall.@defaults[0].flow_offloading='0'
uci set firewall.@defaults[0].fullcone='1'

uci commit firewall

/etc/init.d/firewall restart

# =========================================
# DNS 优化（防泄漏）
# =========================================

uci set dhcp.@dnsmasq[0].noresolv='1'
uci set dhcp.@dnsmasq[0].cachesize='10000'

uci add_list dhcp.@dnsmasq[0].server='1.1.1.1'
uci add_list dhcp.@dnsmasq[0].server='8.8.8.8'

uci commit dhcp

/etc/init.d/dnsmasq restart

# =========================================
# ttyd 默认 bash
# =========================================

uci set ttyd.@ttyd[0].command='/bin/bash'

uci commit ttyd

# =========================================
# Samba 优化
# =========================================

uci set samba4.@samba[0].description='ImmortalWrt Samba4'
uci set samba4.@samba[0].charset='UTF-8'

uci commit samba4

# =========================================
# 硬盘休眠（30分钟）
# =========================================

uci set hd-idle.config.enabled='1'
uci set hd-idle.config.idle_time_interval='180'

uci commit hd-idle

# =========================================
# UPnP 默认开启
# =========================================

/etc/init.d/miniupnpd enable

# =========================================
# 删除自身（只执行一次）
# =========================================

rm -f /etc/uci-defaults/99-custom

exit 0
EOF

chmod +x files/etc/uci-defaults/99-custom

echo "DIY-PART2 完成"
