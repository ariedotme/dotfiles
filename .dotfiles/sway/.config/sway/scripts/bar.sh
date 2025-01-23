while true; do
	date=$(date +'%A, %b %d')
	time=$(date +'%I:%M:%S %p')
	mpd=$(mpc current)
	echo "$mpd			| $date  $time"
	sleep 1
done
