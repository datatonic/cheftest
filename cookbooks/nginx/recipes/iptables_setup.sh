#!/bin/bash

#iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp -m tcp -m multiport ! --dports 80,443,8080,22 -j DROP
iptables -A INPUT -m conntrack -j ACCEPT  --ctstate RELATED,ESTABLISHED
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -j DROP
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -j DROP
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -j DROP
#iptables -A INPUT -j REJECT
iptables -A OUTPUT -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

/sbin/iptables-save

