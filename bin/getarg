#!/bin/bash

# stdin判定の習作
# https://www.baeldung.com/linux/pipe-output-to-function
function getInput() {
  if test -n "$1"; then
    echo "Read from arg $1";
  elif  test ! -t 0; then
    while read data;
      do echo "Read from stdin ${data}";
    done;
  else
    echo "no std input"
  fi
}

# stdin読み込みの習作
# https://unix.stackexchange.com/questions/114121/how-to-compose-bash-functions-using-pipes
#
# pipeできる
# echo "hello" | logx
function logx() {
  while read data;
    do echo "xX_${data}_Xx";
  done;
}

# argsがあるならargsを, pipeされてるならstdinを返す
if test -n "$1"; then
  echo "$1"
elif test ! -t 0; then
  while read data;
    do echo "${data?}";
  done;
else
  echo ""
fi

