#!/bin/bash

iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -j REJECT
iptables -A OUTPUT -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
/sbin/iptables-save

