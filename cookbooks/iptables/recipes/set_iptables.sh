#!/bin/bash

iptables -A INPUT -p tcp -m tcp -m multiport --dports 8080,443 -j ACCEPT
<insert further allowed list here>
iptables -A INPUT -m conntrack -j ACCEPT  --ctstate RELATED,ESTABLISHED
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -j DROP
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -j DROP
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -j DROP

# to continue accepting packets after connection is established. 
# When it happens connection is moved on the server side to some random >1024 port, that's why accepting packets on port 22 and 3389 is not enough.

iptables -A INPUT  --match state --state ESTABLISHED,RELATED --jump ACCEPT
iptables -A OUTPUT --match state --state ESTABLISHED,RELATED --jump ACCEPT
To allow DNS lookups:
iptables -A INPUT  --proto udp --sport 53 --jump ACCEPT
iptables -A OUTPUT --proto udp --dport 53 --jump ACCEPT
iptables -A OUTPUT --proto tcp --dport 53 --jump ACCEPT

# To set rule for several ports at once (so --sports or --dports) you have to enable multiportmodule.
# Otherwise iptables will complain about unknown option "--dports". So to allow SSH and RDP incoming connections in one line:
iptables -A INPUT --proto tcp -m multiport --dports 22,3389 --jump ACCEPT

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
# Exceptions to default policy
iptables -A INPUT -p tcp --dport 80 -j ACCEPT       # HTTP
iptables -A INPUT -p tcp --dport 443 -j ACCEPT      # HTTPS

