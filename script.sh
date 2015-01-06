#!/bin/bash

function GetIPByName {
	egrep .*$1.* list.txt | cut -d: -f2
}

function GetNameByIP {
	egrep .*$1.* list.txt | cut -d: -f1
}

function GetMSByName {
	cat /tmp/ping-$1.out | egrep .*min/avg/max.* | cut -d"/" -f5
}

function LaunchPing {
	for IP in $(cat list.txt | cut -d: -f2)
	do
		NAME=$(GetNameByIP $IP)
		ping -qc 3 -W5 $IP > /tmp/ping-$NAME.out &
	done
}

function ShowResult {
	for NAME in $(cat list.txt | cut -d: -f1)
	do
		IP=$(GetIPByName $NAME)
		MS=$(GetMSByName $NAME)
		echo $NAME"(" $IP "):" $MS " ms"
	done
}

LaunchPing
echo "Pings in progress..."
sleep 7
ShowResult

#for NAME in $(cat list.txt | cut -d: -f1) 
#do
#	IP=$(egrep ^$NAME.* list.txt | cut -d: -f2)
#	ping -qc 3 $IP > /tmp/ping.out &
#	MS=$(cat /tmp/ping.out | egrep .*min/avg/max.* | cut -d"/" -f5)
#	echo $NAME "(" $IP ") : " $MS " ms"
#done

rm -rf /tmp/ping-*.out
