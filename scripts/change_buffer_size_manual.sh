#!/bin/bash
#title           :change_buffer_size.sh
#description     :change the buffer size in openvpn configuration
#author          :Alois paulus
#date            :10/07/2015
#==============================================================================
clientIP=$1
serverIP=$2
buffer_size=$3

echo "buffer size" $buffer_size
echo "openvpn client change openvpn buffer size"
ssh root@$clientIP "sed -i.bak 's/^\(sndbuf\).*/\1 $buffer_size/' /etc/openvpn/client.conf"
ssh root@$clientIP "sed -i.bak 's/^\(rcvbuf\).*/\1 $buffer_size/' /etc/openvpn/client.conf"

sleep 5
echo "openvpn server change openvpn buffer size"
ssh root@$serverIP "sed -i.bak 's/^\(sndbuf\).*/\1 $buffer_size/' /etc/openvpn/server.conf"
ssh root@$serverIP "sed -i.bak 's/^\(rcvbuf\).*/\1 $buffer_size/' /etc/openvpn/server.conf"
sleep 5


