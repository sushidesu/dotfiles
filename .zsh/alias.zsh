# 基本的なコマンド
alias ls='exa -1 --sort Extension'
alias lst='ls -T -L=2'
alias la='exa -1 --sort Extension -a'
alias lat='la -T -L=2'
alias vim='nvim'

# 競プロ用
alias atest='g++ main.cpp && oj t'
alias ainit='xclip -o | xargs oj d && touch main.cpp'
