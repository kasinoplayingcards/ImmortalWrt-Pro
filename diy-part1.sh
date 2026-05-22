#!/bin/bash

echo "stable build start"

# 清理冲突（只清必要的）
rm -rf feeds/packages/net/sing-box
rm -rf feeds/packages/net/xray-core
rm -rf feeds/packages/net/v2ray-core

# 更新 feeds（关键）
./scripts/feeds update -a
./scripts/feeds install -a

echo "feeds ready"
