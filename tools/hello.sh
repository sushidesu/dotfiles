# https://qiita.com/t_nakayama0714/items/80b4c94de43643f4be51

hoge="hoge-value"
echo ${hoge}

# return "deafult" if empty
echo ${fuga:-"default"}
echo ${fuga}
echo ${fuga:="dfault-init"}
echo ${fuga}

# error
unset fuga
# echo ${fuga:?}

fuga="12345678"
echo ${fuga:2} # -> 345678
echo ${fuga:2:3} # -> 345
echo ${fuga:2:-1} # -> 34567

echo ${#fuga} # -> 8

echo ${fuga#*5} # -> 678
echo ${fuga/345/333}
echo ${fuga/345}

arr=("aa", "bb", "cc")
echo ${arr}
echo ${#arr[*]} # -> 3
echo ${#arr[@]} # -> 3

hoge="aaaabbbbccc"
echo ${hoge}
echo ${hoge^} # zshだと動かない bashのバージョン上げて試す
echo ${hoge^^} # //

for char in {A..Z} ; do vars=($(eval echo \$\{\!${char}*\})) ; echo "${char}: (${#vars[*]}) ${vars[*]}" ; done
