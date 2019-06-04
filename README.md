# linuxutils

This is a set of utilities I have written which I think other people might find useful.


## filegrow

This is a simple tool that reports how quickly a file is growing, and if you
tell it how big the file will be, estimates how long before it gets there.

This can be useful when copying a big file from one server to another, or
seeing how fast a log file is growing and when it will reach a specific size.


## squidlogtimedecode

a script which reads the squid access log and prints the time stamp
in a friendly format.


## ssh_agent_finder

put this in /usr/local/bin and call it in your .bashrc or .profile where
it will try and find a working ssh agent (whether you're ssh'd in with
agent forwarding) or there's broken ssh environment vars and needs to 
start a new one.

