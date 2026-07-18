# hide-spaces patch

`ui.sidebar.spaces.hidden = true` で sidebar の spaces セクションを完全に
消し、agents パネルに全高を割り当てる自前パッチ。実 diff は同ディレクトリの
`hide-spaces.patch`(`herdr-rebuild` が適用する)。

upstream 提案: https://github.com/ogulcancelik/herdr に
「option to hide the spaces section」として issue/PR を出せば
パッチ管理は不要になる。

## 変更点(herdr 0.7.4 時点)

1. `src/config/sidebar.rs` — `SpacesSidebarConfig` に `hidden: bool` を追加
2. `src/ui/sidebar.rs` — `sidebar_section_heights()` の先頭で
   hidden なら `(0, total_h)` を返す(全レイアウト計算・マウス判定が
   この関数を通るため、ここ1箇所で完結する)。フラグは static
   AtomicBool で、config 読込/reload 時に設定
3. `src/app/mod.rs` — 起動時と reload 時に `set_hide_spaces()` を呼ぶ
4. `src/ui.rs` — `set_hide_spaces` を re-export

## 注意

- spaces セクション下部の "new" / "menu" マウスボタンも一緒に消える
  (new workspace は `prefix+shift+n`、menu は使っていない)
- `herdr update` はパッチなしの公式バイナリで上書きするので、
  update 後は `herdr-rebuild` を再実行する
