#!/bin/bash

# Map copy/paste buttons on Contour Rollermouse Red to back/forward

DISPLAY=:0
export DISPLAY

for USER in $(w -h | cut -d\  -f1 | sort | uniq)
do
	XAUTHORITY=$(sudo -Hiu $USER env | grep ^HOME= | cut -d= -f2)/.Xauthority
	export XAUTHORITY

	XID=$(xinput list \
		| grep "Contour Design Contour Rollermouse Red" \
		| grep pointer \
		| grep -v "Keyboard" \
		| awk '{print $8}' \
		| cut -d = -f 2)

	if [ -n "$XID" ]
	then
		xinput set-button-map $XID 1 2 3 4 5 6 7 8 9 8 9 12
	else
		>&2 echo "ID of rollermouse not found. Is it connected?"
	fi
done
