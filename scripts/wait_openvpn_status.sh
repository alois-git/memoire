#!/bin/bash
clientIP=$1
up=$(ssh root@$clientIP "cat /sys/class/net/tun0/operstate")
while [[ "$up" != "unknown" ]]
do
sleep 1 
up=$(ssh root@$clientIP "cat /sys/class/net/tun0/operstate")
done
echo "openvpn up"
