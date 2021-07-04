FILEPATH=$1


if [[ ! -e $FILEPATH ]]; then
  echo "$FILEPATH not found"
##  exit
fi

# cp --parents $FILEPATH
HOGE=`dirname $0`
echo $HOGE
echo hoge
echo ${0:a:h}

