
#!/bin/sh

# 自动检测网卡（优先无线）
IFACE=$(ls /sys/class/net | grep -E 'wlan|wl|wifi' | head -n 1)
[ -z "$IFACE" ] && IFACE=$(ls /sys/class/net | grep -E 'eth|en' | head -n 1)

RX1=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)
TX1=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)

sleep 1

RX2=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)
TX2=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)

R=$((RX2 - RX1))
T=$((TX2 - TX1))

# 自动选择单位
human() {
    v=$1
    if [ $v -lt 1024 ]; then
        printf "%dB/s" "$v"
    elif [ $v -lt 1048576 ]; then
        printf "%dKB/s" $((v / 1024))
    else
        printf "%.1fMB/s" "$(echo "$v 1048576" | awk '{printf $1/$2}')"
    fi
}

icon_down=""
icon_up=""

printf "%s %s  %s %s\n" "$icon_down" "$(human $R)" "$icon_up" "$(human $T)"
