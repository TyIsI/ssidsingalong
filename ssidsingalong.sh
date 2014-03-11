#!/bin/sh

###if [ ! -f "$1" ] ; then
 ###echo "Missing file!"
 ###echo ""
 ###echo "Usage: `basename $0` <song file>"
 ###exit
###fi

TEMPLATE=hostapd.template
CONF=hostapd.conf

cat - | cut -c 1-32 | while read ssid
do
 BSSID=`./generatebssid.pl | awk '{ print "s/%BSSID%/" $1 "/g" }'`
 SSID=`echo "s/%SSID%/$ssid/g"`
 cat "$TEMPLATE" | sed "$SSID" | sed "$BSSID" | perl -pe 's/(\,|\-|\.)//g' > "$CONF"
 /usr/sbin/hostapd -B "$CONF"
 sleep 15
 killall hostapd
 sleep 3
done
