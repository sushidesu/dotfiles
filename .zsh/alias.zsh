# 基本的なコマンド
alias ls='exa -1 --sort Extension'
alias lst='ls -T -L=2'
alias la='exa -1 --sort Extension -a'
alias lat='la -T -L=2'
alias vim='nvim'

# 競プロ用
alias atest='g++ main.cpp && oj t'
alias ainit='xclip -o | xargs oj d && touch main.cpp'

# vscode
alias coder='code -r .'

# lazygit
alias lg='lazygit'

# npm
alias nr='npm run'
alias yw='yarn workspace'

# test
alias testfile='f() { 
  FILE="$1"
  BASENAME=$(basename "$FILE")
  EXT="${BASENAME##*.}"
  NAMEONLY="${BASENAME%.*}"
  TESTFILE="${NAMEONLY}.test.${EXT}"
  npm test -- --silent --coverage --watchAll=false --collectCoverageFrom="$FILE" "$TESTFILE"
}; f'

# git
alias ss='git ss'
alias cc='git c'
alias ccc='git c -a'
alias ca='git ca'
alias can='git can'
alias aa='git a'
alias sw='git sw'
alias swc='git sw -c'
alias lo='git lo'
alias lon='git lo -n'
alias bb='git b'
alias ba='git ba'
alias bd='git bd'
alias fp='git fp'
alias gogo='git push'
alias fpl='git fp && git pull'
alias gr='git rebase'
alias gri='git rebase -i'
alias grc='git rebase --continue'
alias gra='git rebase --abort'
alias gogogo='git push -u origin HEAD'

# always includes dotfiles
alias rg='rg -.'
alias fd='fd -H'

# tmux
alias t='tmux'
alias ta='tmux attach -t'
alias td='tmux detach'
alias tls='tmux ls'

tmxmain() {
  tmux has-session -t main 2>/dev/null && tmux attach -t main || tmux new -s main
}

tmx() {
  local name
  local dir="${1:-$PWD}"
  name="$(basename "$dir")"
  if tmux has-session -t "$name" 2>/dev/null; then
    tmux switch-client -t "$name"
  else
    tmux new-session -d -s "$name" -c "$dir"
    tmux switch-client -t "$name"
  fi
}

tmxspwn() {
  tmx ~/dev/spwn/main
}

tmxsplarate() {
  tmx ~/dev/splarate-hybrid
}
