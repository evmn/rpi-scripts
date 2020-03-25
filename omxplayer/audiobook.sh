#!/bin/bash

dir="/home/pi/book-path"# Your audiobook path
lists="${dir}/index.txt"
if [ ! -f "$lists" ]
then
	cd "$dir"
	find . -name "*.mp3" | sed 's/\.\///g' | sort > "$lists"#Change mp3 to your file format
fi
total_chap=`wc -l < $lists`
if [ ! $1 ]
then
	day_of_year=$(date +%-j)
	let "chap_n = ($day_of_year - 233) % $total_chap + 1"#Change 233 to your current day of year
else
	if [ $1 -ge 1 ] && [ $1 -le $total_chap ]
	then
		chap_n=$1
	else
		let "chap_n = $(( RANDOM % $total_chap)) + 1"
	fi
fi

for i in {1..1}
do
	title=$(cat $lists | sed -n ${chap_n}p)
	echo "${chap_n}/${total_chap}: $title"
	current="$dir/$title"
	omxplayer "$current" --vol 600
	if [ $chap_n -ge $total_chap ]
	then
		chap_n=0
	fi
	let "chap_n = $chap_n + 1"
done
