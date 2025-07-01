#!/bin/bash

IFACE="en0"
TARGET="8.8.8.8"

while true; do
  timestamp=$(date +"%H:%M:%S")
  
  if ifconfig "$IFACE" | grep -q "inet "; then
    ssid=$(/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | awk -F': ' '/ SSID: /{print $2}')
    [[ -z "$ssid" ]] && ssid="(取得不可)"
  else
    ssid="未接続"
  fi

  # macOS用のpingコマンド（タイムアウト1秒）
  ping_result=$(ping -c 1 -t 1 8.8.8.8 2>/dev/null | grep 'time=')

  if [[ -n "$ping_result" ]]; then
    rtt=$(echo "$ping_result" | sed -n 's/.*time=\([^ ]*\).*/\1/p')
    # 遅延判定（例：300ms以上で"SLOW"）
    slow=$(echo "$rtt > 300" | bc)
    [[ $slow -eq 1 ]] && rtt="${rtt} ms [SLOW]" || rtt="${rtt} ms"
  else
    rtt="No response"
  fi

  timestamp=$(date +"%H:%M:%S")
  echo "[$timestamp] Wi-Fi: $ssid | Ping: $rtt"

  sleep 1
done

