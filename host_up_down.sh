#!/bin/bash
# host_up_down pings and reports when the host stops or starts reponding
# licensed under GPLv3

PERIOD=2		# default sleep period
LOGFAC="daemon.warn"	# log with this facility.priority
DBG_LEVEL=0

function print_usage() {
	cat <<EOF
Usage:
    $0 [-h] [-d] [-l loghost] [-p period] -t target

	-d	optional, increase debug level, use multiple times for more vebosity
	-h	optional, print help (you are here)
	-l	optional, log host, send a syslog message here, e.g. 192.168.1.1
	-t	mandatory, ping target, e.g. ipv6.google.com
	-p	optionl, default period is $PERIOD secs
EOF

}

#### parameters
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
		"-p")
			shift
			PERIOD="$1"
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
LAST_STATE_TSTAMP=$( date +%s)
while /bin/true ; do
	YMDHMS=$( date +%Y%m%d-%H:%M:%S )
	ping -c 2 -n -w 2 "$TARG" > /dev/null
	#ping -c 1 -n -w 2 "$TARG" | grep -q " 0% packet loss"
	PINGRES=$?

	if [ $PINGRES -eq 0 ] && [ $STATE -ne 1 ] ; then
		NEW_STATE_TSTAMP=$( date +%s)
		PERIOD=$(( NEW_STATE_TSTAMP - LAST_STATE_TSTAMP ))
		[ "$LOGHOST" != "" ] && logger -n "$LOGHOST" -p "$LOGFAC" "target $TARG responded to $HOSTNAME - state lasted $PERIOD seconds"
		echo "$YMDHMS target $TARG responded - state lasted $PERIOD seconds"
		STATE=1
		NEW_STATE_TSTAMP="$LAST_STATE_TSTAMP"
	fi

	if [ $PINGRES -ne 0 ] && [ $STATE -ne 0 ] ; then
		NEW_STATE_TSTAMP=$( date +%s)
		PERIOD=$(( NEW_STATE_TSTAMP - LAST_STATE_TSTAMP ))
		[ "$LOGHOST" != "" ] && logger -n "$LOGHOST" -p "$LOGFAC" "target $TARG failed to responded to $HOSTNAME - state lasted $PERIOD seconds"
		echo "$YMDHMS target $TARG failed to respond - state lasted $PERIOD seconds"
		STATE=0
		NEW_STATE_TSTAMP="$LAST_STATE_TSTAMP"
	fi

	[ "$DBG_LEVEL" -gt 0 ] && echo "Sleeping for $PERIOD"
	sleep "$PERIOD"
done

# end host_up_down.sh
