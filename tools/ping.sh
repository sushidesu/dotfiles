#!/bin/bash

# 監視対象のインターフェイス名（Wi-Fi）。必要に応じて変更してください。
IFACE="en0"

# 監視ループ
while true; do
  # 時刻を取得
  timestamp=$(date +"%H:%M:%S")

  # Wi-Fi接続状態の確認（ifconfigでinet取得）
  if ifconfig "$IFACE" | grep -q "inet "; then
    # 接続中: IPアドレス取得
    ip_addr=$(ifconfig "$IFACE" | awk '/inet /{print $2}' | grep -v 127.0.0.1)
    # SSID取得（airportコマンドを使用）
    ssid=$(/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I 2>/dev/null | awk -F': ' '/ SSID: /{print $2}')
    [[ -z "$ssid" ]] && ssid="(SSID取得不可)"
    status="CONNECTED ($ssid)"
  else
    # 未接続
    status="DISCONNECTED"
    ip_addr="--"
  fi

  # Pingによる遅延チェック（1回だけICMP送信）
  target="8.8.8.8"          # またはルーターのIPアドレス等
  ping_result=$(ping -c 1 -W 1 $target 2>/dev/null | grep 'time=')
  if [[ -n "$ping_result" ]]; then
    # 応答時間を抽出 (time=XXms 部分)
    rtt=$(echo "$ping_result" | sed -n 's/.*time=\([^ ]*\).*/\1/p')
    # 極端な遅延の判定（例：300ms超えたら"SLOW"マーク）
    if [[ $(echo "$rtt > 300" | bc) -eq 1 ]]; then
      rtt="${rtt} ms **SLOW**"
    else
      rtt="${rtt} ms"
    fi
  else
    # 応答がない場合
    rtt="No response"
  fi

  # 結果出力
  echo "[$timestamp] Wi-Fi: $status (IP: $ip_addr) | Ping: $rtt"

  sleep 1
done

