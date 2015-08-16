#!/bin/bash

ip=192.168.21.11
bw1=$1
bw2=$2
d1=$3
d2=$4
echo "bring eth1 down"
ssh root@$ip ip link set eth1 down
echo "start capturing packets"
ssh root@$ip tcpdump -s0 -i any -w /var/www/"$1_$2-$3_$4".pcap & 
pid=$!
echo "bring eth1 up"
ssh root@$ip ip link set eth1 up
echo "restart openvpn tunnel"
ssh root@$ip /etc/init.d/openvpn restart
