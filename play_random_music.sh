#/bin/bash

dir=$(pwd)
echo "$dir"

if [ ! -f "$dir/lists" ]
then
	find "$dir" -name *.mp3 > lists
fi

for i in {01..05}
do
	music=$(shuf -n 1 "$dir/lists")
	echo "$i: $music"
	omxplayer -b --vol -1500 "$music"
done
