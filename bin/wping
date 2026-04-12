#!/bin/bash

# Monitor Wi-Fi connection status and ping latency.
# Configuration can be adjusted via environment variables:
#   IFACE=en0            # network interface to monitor
#   TARGET=8.8.8.8       # ping destination
#   PING_TIMEOUT_MS=1000 # ping timeout in milliseconds
#   SLOW_THRESHOLD_MS=300# mark ping as slow when above this value
#   SLEEP_SEC=1          # interval between checks
#   SHOW_SSID=1          # set to 0 to skip SSID lookup

IFACE=${IFACE:-en0}
TARGET=${TARGET:-8.8.8.8}
PING_TIMEOUT_MS=${PING_TIMEOUT_MS:-1000}
SLOW_THRESHOLD_MS=${SLOW_THRESHOLD_MS:-300}
SLEEP_SEC=${SLEEP_SEC:-1}
SHOW_SSID=${SHOW_SSID:-1}

# Cache availability of helper utilities so we don't probe every loop.
have_networksetup=0
if command -v networksetup >/dev/null 2>&1; then
  have_networksetup=1
fi

airport_bin=""
for candidate in \
  "/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport" \
  "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport" \
  "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport"; do
  if [[ -x $candidate ]]; then
    airport_bin=$candidate
    break
  fi
done

get_ssid() {
  [[ $SHOW_SSID -eq 1 ]] || return 1

  if [[ $have_networksetup -eq 1 ]]; then
    local line
    line=$(networksetup -getairportnetwork "$IFACE" 2>/dev/null)
    if [[ $line == "Current Wi-Fi Network:"* ]]; then
      local ssid=${line#Current Wi-Fi Network: }
      if [[ -n $ssid && $ssid != "$line" ]]; then
        echo "$ssid"
        return 0
      fi
    fi
  fi

  if [[ -n $airport_bin ]]; then
    local ssid
    ssid=$($airport_bin -I 2>/dev/null | awk -F': ' '/ SSID: /{print $2; exit}')
    if [[ -n $ssid ]]; then
      echo "$ssid"
      return 0
    fi
  fi

  return 1
}

format_ping_result() {
  local output status rtt err_line
  output=$(ping -c 1 -W "$PING_TIMEOUT_MS" "$TARGET" 2>&1)
  status=$?

  if [[ $status -eq 0 ]]; then
    rtt=$(awk -F'time=' 'NF>1 {split($2,a," "); print a[1]; exit}' <<<"$output")
    if [[ -z $rtt ]]; then
      echo "Response"
      return 0
    fi
    if awk -v r="$rtt" -v t="$SLOW_THRESHOLD_MS" 'BEGIN{exit !(r > t)}'; then
      echo "${rtt} ms [SLOW]"
    else
      echo "${rtt} ms"
    fi
    return 0
  fi

  err_line=$(printf "%s\n" "$output" | grep -m1 '^ping:' | sed 's/^ping: //')
  [[ -z $err_line ]] && err_line="timeout"
  echo "No response (${err_line})"
  return 1
}

while true; do
  timestamp=$(date +"%H:%M:%S")
  ifconfig_out=$(ifconfig "$IFACE" 2>/dev/null)

  if [[ $? -eq 0 && $ifconfig_out == *"inet "* ]]; then
    ip_addr=$(awk '/inet / && $2 !~ /^127\./ {print $2; exit}' <<<"$ifconfig_out")
    [[ -z $ip_addr ]] && ip_addr="--"
    ssid_label=""
    if ssid_value=$(get_ssid); then
      ssid_label=" (SSID: $ssid_value)"
    elif [[ $SHOW_SSID -eq 1 ]]; then
      ssid_label=" (SSID: --)"
    fi
    status="CONNECTED${ssid_label}"
  else
    status="DISCONNECTED"
    ip_addr="--"
  fi

  ping_info=$(format_ping_result)
  echo "[$timestamp] Wi-Fi: $status (IP: $ip_addr) | Ping: $ping_info"

  sleep "$SLEEP_SEC"
done
