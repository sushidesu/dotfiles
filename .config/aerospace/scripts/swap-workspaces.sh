#!/usr/bin/env bash

set -euo pipefail

target="${1:?Usage: swap-workspaces.sh <target-workspace|prev|next>}"
ws_a=$(aerospace list-workspaces --focused --format '%{workspace}')

case "$target" in
  prev|next)
    aerospace workspace "$target"
    ws_b=$(aerospace list-workspaces --focused --format '%{workspace}')
    ;;
  *)
    ws_b="$target"
    ;;
esac

if [[ -z "$ws_a" || -z "$ws_b" || "$ws_a" == "$ws_b" ]]; then
  exit 0
fi

ids_a=$(aerospace list-windows --workspace "$ws_a" --format '%{window-id}')
ids_b=$(aerospace list-windows --workspace "$ws_b" --format '%{window-id}')

for id in $ids_a; do
  aerospace move-node-to-workspace --window-id "$id" "$ws_b"
done

for id in $ids_b; do
  aerospace move-node-to-workspace --window-id "$id" "$ws_a"
done

if [[ "$target" != "prev" && "$target" != "next" ]]; then
  aerospace workspace "$ws_b"
fi
