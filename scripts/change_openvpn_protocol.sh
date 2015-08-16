#!/bin/sh
clientIP=$2
serverIP=$3
echo "openvpn client change openvpn protocol"
if [ "$1" = "udp" ]
then
 ssh root@$clientIP "sed -i.bak 's/^\(proto\).*/\1 udp/' /etc/openvpn/client.conf"
else
 ssh root@$clientIP "sed -i.bak 's/^\(proto\).*/\1 tcp/' /etc/openvpn/client.conf"
fi
sleep 5
echo "openvpn server change openvpn protocol"
if [ "$1" = "udp" ]
then
 ssh root@$serverIP "sed -i.bak 's/^\(proto\).*/\1 udp/' /etc/openvpn/server.conf"
else
 ssh root@$serverIP "sed -i.bak 's/^\(proto\).*/\1 tcp/' /etc/openvpn/server.conf"
fi
sleep 5
