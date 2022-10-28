#!/bin/bash

# This script acts like middleware to i3status making it
# possible to extend it by adding custom entries.

# Print current keyboard layout
keyboard_layout() {
    LG=$(xkblayout.sh)
    IFS=', ' read -r -a LAYOUT <<< $(setxkbmap -query | awk '/layout/{print $2}')
    OUT=""
    for IDX in "${!LAYOUT[@]}"
    do
        I="${LAYOUT[IDX]}"
        if [ $I == $LG ]
        then
            C=",\"color\":\"#00FF00\""
        else
            C=",\"color\":\"#555555\""
        fi

        if [[ $IDX -eq 0 ]]; then
            E=""
        else
            E=",\"separator\":false,\"separator_block_width\":6"
        fi
        I="$(echo $I |tr '[a-z]' '[A-Z]')"
        OUT="{\"full_text\":\"$I\"$C$E},$OUT"
    done

    echo $OUT
}

# Print song currently playing
now_playing() {
    PLAYER=`playerctl --ignore-player=chromium metadata --format '{{playerName}}' |tr [:lower:] [:upper:]`
    TITLE=`playerctl --ignore-player=chromium metadata --format '{{title}}'`
    ARTIST=`playerctl --ignore-player=chromium metadata --format '{{artist}}'`
    STATUS=`playerctl --ignore-player=chromium metadata --format '{{status}}'`
    #PROGRESS=`echo $(playerctl metadata --ignore-player=chromium --format '{{position*100/mpris:length}}'/1 |bc) %`
    PROGRESS=`playerctl metadata --ignore-player=chromium --format '{{duration(position)}}/{{duration(mpris:length)}}'`

    if [ -n "$STATUS" ]
    then
        if [ "$STATUS" = "Playing" ]
        then
            COLOR="#00FF00"
        else
            COLOR="#FFA500"
        fi

        if [ -n "$ARTIST" ]
        then
            SONG="$ARTIST - $TITLE"
        else
            SONG="$TITLE"
        fi

        if [ -n "$PROGRESS" ]
        then
            OUT="{\"full_text\":\"$SONG ($PROGRESS)\"},"
        else
            OUT="{\"full_text\":\"$SONG\"},"
        fi

        OUT="{\"full_text\":\"$PLAYER:\",\"color\":\"$COLOR\",\"separator\":false},$OUT"
    fi

    echo $OUT
}

# Print song currently playing on Spotify
spotify_now_playing() {
    TITLE=`dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' |egrep -A 1 "title" |cut -b 44- |cut -d '"' -f 1 |egrep -v ^$`
    ARTIST=`dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' |egrep -A 2 "artist" |cut -b 20- |cut -d '"' -f 2 |egrep -v ^$ |egrep -v array |egrep -v artist`

    if [ -n "$TITLE" ] && [ -n "$ARTIST" ]
    then
        OUT="{\"full_text\":\"$ARTIST - $TITLE\"},"
        OUT="{\"full_text\":\"Spotify:\",\"color\":\"#9EC600\",\"separator\":false},$OUT"
    fi

    echo $OUT
}

vpn_status() {
    STATUS=$(ps ax |grep /usr/sbin/openvpn |grep -v grep)
    if [ -n "$STATUS" ]
    then
        OUT="{\"full_text\":\"UP\",\"color\":\"#00FF00\"},"
    else
        OUT="{\"full_text\":\"DOWN\",\"color\":\"#FFA500\"},"
    fi
    OUT="{\"full_text\":\"VPN:\",\"separator\":false},$OUT"

    echo $OUT
}

fan_speed() {
    SPEED=$(sensors | grep fan | head -1 | awk '{ print $2 }')
    if [ -z "$SPEED" ]
    then
        SPEED="N/A"
    fi
    OUT="{\"full_text\":\"FAN: $SPEED RPM\"},"

    echo $OUT
}

i3status | while :
do
    read LINE

    RES="$(now_playing)$(vpn_status)$(keyboard_layout)$(fan_speed)"

    echo "${LINE/[{/[$RES{}" || exit 1
done
