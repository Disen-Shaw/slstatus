#!/bin/sh

Mem() {
    # 读取 /proc/meminfo（单位 kB）
    total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    avail=$(grep MemAvailable /proc/meminfo | awk '{print $2}')

    used=$((total - avail))

    # 转换为 MB
    used_mb=$((used / 1024))
    total_mb=$((total / 1024))

    # 如果超过 1024MB → 用 GB 显示
    if [ $used_mb -gt 1024 ]; then
        used_gb=$(echo "$used_mb 1024" | awk '{printf "%.1f", $1/$2}')
        total_gb=$(echo "$total_mb 1024" | awk '{printf "%.1f", $1/$2}')
        printf "%sG ┃ %sG\n" "$used_gb" "$total_gb"
    else
        printf "%sM ┃ %sM\n" "$used_mb" "$total_mb"
    fi
}

Mem


