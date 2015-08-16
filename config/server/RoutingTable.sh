#!/bin/bash
#
#eth0

#IP-Address: 192.168.21.11
#Subnet-Mask: 255.255.255.0
#Gateway: 192.168.21.1

#eth1

#IP-Address: 192.168.22.11
#Subnet-Mask: 255.255.255.0
#Gateway: 192.168.22.1

#Create two different routing tables.
ip rule add from 192.168.21.11 table 1
ip rule add from 192.168.22.11 table 2

#Configure the two different routing tables
ip route add 192.168.21.0/24 dev eth0 scope link table 1
ip route add default via 192.168.21.1 dev eth0 table 1

ip route add 192.168.22.0/24 dev eth1 scope link table 2
ip route add default via 192.168.22.1 dev eth1 table 2

#default route for the selection process of traffic
ip route add default scope global nexthop via 192.168.21.1 dev eth0

