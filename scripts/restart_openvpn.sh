#!/bin/bash
clientIP=$1
serverIP=$2
echo "restarting openvpn client and server"
ssh root@$clientIP /etc/init.d/openvpn restart
ssh root@$serverIP /etc/init.d/openvpn restart
