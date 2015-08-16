#!/bin/sh
serverIP=$1
interface1=eth0.3
interface2=eth0.4

echo "turning on and off one interface from server"
#ssh root@$serverIP ip link set dev $interface1 multipath on 
#ssh root@$serverIP ip link set dev $interface2 multipath on 
