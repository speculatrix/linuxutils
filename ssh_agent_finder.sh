#!/bin/bash
# this script attempts to recover access to a working ssh-agent to minimise
# duplicate processes or having to re-enter ssh key passwords

# use this script like so:
# . /usr/local/bin/ssh_agent_finder

# or if you need multiple agents with different keys loaded,
# . /usr/local/bin/ssh_agent_finder <profile>

#set -x

# we should only output messages if on an interactive session,
# otherwise it might upset ssh, scp or rsync
ON_TTY=/bin/true
tty > /dev/null 2>&1
if [ $? -eq 1 ] ; then
	ON_TTY=/bin/false
fi

# the profile changes the agent output file
if [ "$1" == "" ] ; then
	agent_profile="default"
	#$ON_TTY && echo "Info, using profile default"
else
	agent_profile="$1"
	#$ON_TTY && echo "Info, using profile $1"
fi


# we store ssh agent info in a per-host file, so we can recover it later
AGENTSAVEFILE="$HOME/.ssh/agent-$( hostname )_${agent_profile}"

# SSH_AGENT_PROFILE tells us the current profile
# set to default if not set, probably when first logging in
if [ "$SSH_AGENT_PROFILE" == "" ] ; then
	export SSH_AGENT_PROFILE=default
fi

# ensure we save the default profile if it doesn't exist already and we have SSH_AUTH_SOCK set
if [ "$SSH_AGENT_PROFILE" == "default" ] && [ ! -f "$AGENTSAVEFILE" ] && [ "$SSH_AUTH_SOCK" != "" ]  ; then
	echo "Info, creating/saving SSH env to $AGENTSAVEFILE"
	env \
		| grep SSH_ \
		| grep -v -E "SSH_CONNECTION|SSH_CLIENT" \
		> "$AGENTSAVEFILE"
	echo "export SSH_AUTH_SOCK"		>> "$AGENTSAVEFILE"
	echo "export SSH_AGENT_PID"		>> "$AGENTSAVEFILE"
	echo "export SSH_AGENT_PROFILE"		>> "$AGENTSAVEFILE"
fi

# switch to the profile if we're not already on it, usually this
# means because we're logging in and thus starting at the default profile
if [ "$SSH_AGENT_PROFILE" != "$agent_profile" ] ; then
	echo "Info, switching to agent save file $AGENTSAVEFILE"
	export SSH_AGENT_PROFILE="$agent_profile"
	#. "$AGENTSAVEFILE"
	. "$AGENTSAVEFILE" > /dev/null
fi


# when logging in on desktop, ssh-agent often already started for us and
# SSH_AUTH_SOCK should already be set, if not try and find existing agent
if [ "$SSH_AUTH_SOCK" == "" ] ; then
	#echo "Debug, SSH_AUTH_SOCK not set"
	if [ ! -f "$AGENTSAVEFILE" ] ; then
		echo "Debug, there's no saved agent details, starting a new one"
		$ON_TTY && echo "Info, SSH_AUTH_SOCK wasn't set, no recovery file, starting new agent"
		ssh-agent | tee > "$AGENTSAVEFILE"
	else
		#echo "Debug, found and loading a saved agent file"
		. "$AGENTSAVEFILE"
	fi

	# now load the agent details
	# shellcheck disable=SC1090
	#. "$AGENTSAVEFILE"
	. "$AGENTSAVEFILE" > /dev/null
	#$ON_TTY && echo "Debug, agent details 1: sock $SSH_AUTH_SOCK, pid $SSH_AGENT_PID"
fi

# now re-test to see if the agent is actually working
if [ "$SSH_AUTH_SOCK" == "" ] ; then
	# if SSH_AUTH_SOCK not set something went badly wrong
	$ON_TTY && echo "Error, SSH_AUTH_SOCK still not set!"
else
	#env | grep SSH
	# ssh-add returns 0 if working with keys, 1 if working but no keys, 2 if dead
	ssh-add -l > /dev/null 2>&1
	AGENT_COND=$?
	#echo "AGENT_COND $AGENT_COND"
	if [ $AGENT_COND -eq 0 ] ; then
		#$ON_TTY && echo "Debug, the ssh agent was functional and has keys loaded"
		: # need something if debug above is disabled
	elif [ $AGENT_COND -eq 1 ] ; then
		#$ON_TTY && echo "Info, the ssh agent was functional but has no keys loaded"
		: # need something if debug above is disabled
	else
		#$ON_TTY && echo "Info, SSH_AUTH_SOCK pointed to defunct agent, starting a new one"
		ssh-agent > "$AGENTSAVEFILE"
		# shellcheck disable=SC1090
		. "$AGENTSAVEFILE" > /dev/null
		$ON_TTY && echo "Debug, agent details 2: sock $SSH_AUTH_SOCK, pid $SSH_AGENT_PID"
	fi
fi

set +x

# end ssh_agent_finder.sh
