#!/usr/bin/env bash
### maybe i should check if this is enabled somehow and then run it?
AMIFORWARDING=`sysctl net.ipv4.conf.all.forwarding | grep 1`
if [ -z "${AMIFORWARDING}" ]
then
  echo "forwarding rules do not seem to be set. setting them right now"
  sudo sysctl net.ipv4.conf.all.forwarding=1 >/dev/null
  sudo iptables -P FORWARD ACCEPT
else
  echo "forwarding rule seems to be set"
fi
