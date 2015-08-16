#!/bin/bash
#title           :change_buffer_size.sh
#description     :change the buffer size in openvpn configuration
#author          :Alois paulus
#date            :10/07/2015
#==============================================================================
clientIP=$1
serverIP=$2
bandwidth=$3
delay=$4


rtt=$(($delay * 2)) # rtt should be divide by 1000 but bash does not like decimal so I do it later
buffer_size=$(($bandwidth  * $rtt))
buffer_size=$(($buffer_size * 125000))
buffer_size=$(($buffer_size / 1000))
buffer_size=$(($buffer_size * 2))
echo $buffer_size

if [ $buffer_size -ne 0 ]
then
  if [ $buffer_size -lt 64000 ]
    then
     buffer_size=64000	
  fi
fi

echo "buffer size" $buffer_size
echo "openvpn client change openvpn buffer size"
ssh root@$clientIP "sed -i.bak 's/^\(sndbuf\).*/\1 $buffer_size/' /etc/openvpn/client.conf"
ssh root@$clientIP "sed -i.bak 's/^\(rcvbuf\).*/\1 $buffer_size/' /etc/openvpn/client.conf"

echo "openvpn server change openvpn buffer size"
ssh root@$serverIP "sed -i.bak 's/^\(sndbuf\).*/\1 $buffer_size/' /etc/openvpn/server.conf"
ssh root@$serverIP "sed -i.bak 's/^\(rcvbuf\).*/\1 $buffer_size/' /etc/openvpn/server.conf"


