#!/bin/bash

audio_file="/home/pi/Audio.mp3" # Change to your audio file
length=30 # 30 -> x mins every time
hour=$(ffmpeg -i "${audio_file}" 2>&1 | grep Duration | cut  -d: -f 2)
minute=$(ffmpeg -i "${audio_file}" 2>&1 | grep Duration | cut  -d: -f 3)
let "time = $hour * 60 + $minute + 1"
let "n = time / $length + 1"
echo "File length: $time mins，we will play $length mins a time for $n times."

if [ $1 ] && [ $1 -ge 1 ] && [ $1 -le $n ]
then
	let "k = $1"
else
	day_of_Year=$(date +%-j)
	let "k = ($day_of_Year - 8) % n" # 8 -> day-of-year
fi

let "h = ($k - 1)  * $length / 60"
let "m = ($k - 1) * $length % 60"

echo ""
echo "$k/$n: start at $h hour $m minute"

omxplayer -l $h:$m:0 --vol 600 "${audio_file}" &
sleep ${length}m
kill $(pgrep omxplayer)
