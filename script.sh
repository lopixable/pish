#!/bin/bash

echo "      _      _   "
echo " ___ <_> ___| |_ "
echo "| . \| |<_-<| . |"
echo "|  _/|_|/__/|_|_|"
echo "|_|          v1.1"
echo 

if [ -z $1 ]
then
    echo "Usage ./script.sh filename"
    echo "Format of filename content: "
    echo "Name:IPv4"
    exit 1
elif [ ! -f $1 ]
then
    echo "$1 is not a valid file"
    exit 2
fi

FILE=$1

function GetIPByName {
    egrep .*$1.* $FILE | cut -d: -f2
}

function GetNameByIP {
    egrep .*$1.* $FILE | cut -d: -f1
}

function GetMSByName {
    cat /tmp/ping-$1.out | egrep .*min/avg/max.* | cut -d"/" -f5
}

function LaunchPing {
    for IP in $(cat $FILE | cut -d: -f2)
        do
            NAME=$(GetNameByIP $IP)
                ping -qc 3 -W5 $IP > /tmp/ping-$NAME.out &
                done
}

function getResult {
    for NAME in $(cat $FILE | cut -d: -f1)
        do
            IP=$(GetIPByName $NAME)
                MS=$(GetMSByName $NAME)
                printf "%-12s %-18s %8s\n" "$NAME" "$IP" "$MS"
                done
}

LaunchPing
echo "Pings in progress..."
sleep 7
echo 
printf "%-12s %-18s %8s\n" "name" "ip" "ms"
printf "%s" "$(getResult | sort -n -k3)"
echo

rm -rf /tmp/ping-*.out
