#!/bin/bash
# host_up_down pings and reports when the host stops or starts reponding
# licensed under GPLv3

SLEEP_PERIOD=2		# default sleep period
PING_COUNT=2		# how many pings to send
PING_WAIT=2		# how long to wait for a reply
LOGFAC="daemon.warn"	# log with this facility.priority
DBG_LEVEL=0

function print_usage() {
	cat <<EOF
Usage:
    $0 [-h] [-d] [-mp] [-md] [-l loghost] [-p period] -t target

	-d	optional, increase debug level, use multiple times for more vebosity
	-h	optional, print help (you are here)
	-l	optional, log host, send a syslog message here, e.g. 192.168.1.1
	-md	method is to dig the target - i.e dns lookup
	-mp	method is to ping the target (the default)
	-t	mandatory, ping target, e.g. ipv6.google.com
	-p	optional, default period is $SLEEP_PERIOD secs
EOF

}

# check if linux
PING_WAIT_OPT="-w"
if [ ! -f /etc/os-release ] || grep -q -i Linux /etc/os-release ; then
	# probably on a Mac whose ping is more BSD-ish
	PING_WAIT_OPT="-i"
fi


#### parameters
METHOD=ping	# by default, use ping; others are dig
while [ "$#" -gt 0 ] && [ "$1" != "" ] ; do
	case "${1}" in
		"-d")
			DBG_LEVEL=$(( DBG_LEVEL + 1 ))
			echo "Debug is $DBG_LEVEL"
		;;
		"-h")
			print_usage
			exit 0
		;;
		"-l")
			shift
			LOGHOST="$1"
		;;
		"-md")
			METHOD=dig
		;;
		"-mp")
			METHOD=ping
		;;
		"-p")
			shift
			SLEEP_PERIOD="$1"
		;;
		"-t")
			shift
			TARG="$1"
		;;
		# catchall
		*)
			echo "Error, unknown option '$1'" > /dev/stderr
			exit 1
		;;
	esac

	shift
done

if [ "$TARG" == "" ] ; then
	echo "Error, no target specified, use -h for help"
	exit 1
fi

#### main
STATE=2			# 0 = down, 1 = up, 2= unknown
MAX_DOWN=0
MAX_UP=0

LAST_STATE_TSTAMP=$( date +%s)

echo "Sleep count $PING_COUNT, sleep $SLEEP_PERIOD, wait $PING_WAIT"
while /usr/bin/true ; do
	YMDHMS=$( date +%Y%m%d-%H:%M:%S )
	RESPONDED=1	# default code is a failure
	case "$METHOD" in
		"dig")
			dig +short "$TARG" | grep -q -F '.'
			RESPONDED=$?
		;;
		"ping")

			ping -c "$PING_COUNT" -n "$PING_WAIT_OPT" "$PING_WAIT" "$TARG" > /dev/null
			#ping -c "$PING_COUNT" -n "$PING_WAIT_OPT" "$PING_WAIT" "$TARG" | grep -q " 0% packet loss"
			RESPONDED=$?
		;;
		*)
			echo "Error, unknown host detection method"
			exit 1
		;;
	esac

	echo -n "$YMDHMS"
	if [ $RESPONDED -eq 0 ] && [ $STATE -ne 1 ] ; then
		NEW_STATE_TSTAMP=$( date +%s)
		DURATION=$(( NEW_STATE_TSTAMP - LAST_STATE_TSTAMP ))
		LAST_STATE_TSTAMP="$NEW_STATE_TSTAMP"
		if [ "$STATE" -eq 2 ] ; then
			echo " $METHOD target $TARG responsive - previously in unknown state"
			[ "$LOGHOST" != "" ] && logger -n "$LOGHOST" -p "$LOGFAC" "$METHOD target $TARG responsive from $HOSTNAME - previously in unknown state"
		else
			if [ "$DURATION" -gt "$MAX_DOWN" ] ; then
				MAX_DOWN="$DURATION"
			fi
			[ "$LOGHOST" != "" ] && logger -n "$LOGHOST" -p "$LOGFAC" "$METHOD target $TARG responsive from $HOSTNAME - down state lasted $DURATION seconds, max down $MAX_DOWN"
			echo " $METHOD target $TARG responsive - down state lasted $DURATION seconds, max down $MAX_DOWN"
		fi
		STATE=1
	fi

	if [ $RESPONDED -ne 0 ] && [ $STATE -ne 0 ] ; then
		NEW_STATE_TSTAMP=$( date +%s)
		DURATION=$(( NEW_STATE_TSTAMP - LAST_STATE_TSTAMP ))
		LAST_STATE_TSTAMP="$NEW_STATE_TSTAMP"
		if [ "$STATE" -eq 2 ] ; then
			echo " $METHOD target $TARG unresponsive - previously in unknown state"
			[ "$LOGHOST" != "" ] && logger -n "$LOGHOST" -p "$LOGFAC" "$METHOD target $TARG unresponsive from $HOSTNAME - previously in unknown state"
		else
			if [ "$DURATION" -gt "$MAX_UP" ] ; then
				MAX_UP="$DURATION"
			fi
			[ "$LOGHOST" != "" ] && logger -n "$LOGHOST" -p "$LOGFAC" "$METHOD target $TARG unresponsive from $HOSTNAME - up state lasted $DURATION seconds, max up $MAX_UP"
			echo " $METHOD target $TARG unresponsive - up state lasted $DURATION seconds, max up $MAX_UP"
		fi
		STATE=0
	fi

	echo -n -e "\r"
	[ "$DBG_LEVEL" -gt 0 ] && echo "Sleeping for $SLEEP_PERIOD"
	sleep "$SLEEP_PERIOD"
done

# end host_up_down.sh
