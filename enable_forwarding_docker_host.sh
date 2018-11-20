#!/usr/bin/env bash
### maybe i should check if this is enabled somehow and then run it?
sudo sysctl net.ipv4.conf.all.forwarding=1
sudo iptables -P FORWARD ACCEPT
