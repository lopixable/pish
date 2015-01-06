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

function getResult {
	for NAME in $(cat list.txt | cut -d: -f1)
	do
		IP=$(GetIPByName $NAME)
		IP="($IP)"
		MS=$(GetMSByName $NAME)
		printf "%-12s %-18s %8s\n" "$NAME" "$IP" "$MS"
	done
}

echo "      _      _   "
echo " ___ <_> ___| |_ "
echo "| . \| |<_-<| . |"
echo "|  _/|_|/__/|_|_|"
echo "|_|          v1.0"
echo 
LaunchPing
echo "Pings in progress..."
sleep 7
echo 
printf "%-12s %-18s %8s\n" "name" "ip" "ms"
printf "%s" "$(getResult | sort -n -k3)"
echo

rm -rf /tmp/ping-*.out
