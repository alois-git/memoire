#!/bin/bash
#title           :delaybox_qdisc_setup.sh
#description     :Set a bandwith limit and a delay to a box
#author          :Alois paulus
#date            :10/07/2015
#usage           :bash delaybox_qdisc_setup.sh delayboxIP rate delay
#==============================================================================

# tc qdisc on openWRT :
# 1) How to install : 
#  opkg install tc iptables-mod-ipopt kmod-sched
# 2) How to use :
# First load kernel module depending on which QDisc module you need ex:
#  insmod sch_tbf
# delete any rules on the interface
#  tc qdisc del dev eth0 root
#then set the upload limit ex:
#  tc qdisc add dev eth0 root tbf rate 5mbit burst 10kb limit 5mbit

bd_unit="mbit"
ping_unit="ms"
delayboxIP=$1
bandwidth=$2
delay=$3
rtt=$(($delay * 2))
rtt_2=$(($rtt * 2)) 
mainboxIP=192.168.1.1

# load kernel module
ssh root@$mainboxIP ssh -i /etc/dropbear/dropbear_rsa_host_key root@$delayboxIP insmod sch_tbf 
ssh root@$mainboxIP ssh -i /etc/dropbear/dropbear_rsa_host_key root@$delayboxIP insmod sch_netem

# remove previous qdisc
echo "clearing qdisc"
./delaybox_qdisc_clear.sh $delayboxIP
echo "setup qdisc"

#adding qdisc on interface eth0 and eth1 for delay box

#eth0
ssh root@$mainboxIP ssh -i /etc/dropbear/dropbear_rsa_host_key root@$delayboxIP tc qdisc add dev eth0 root handle 1:0 tbf rate $bandwidth$bd_unit burst 16000 latency 5$ping_unit 
ssh root@$mainboxIP ssh -i /etc/dropbear/dropbear_rsa_host_key root@$delayboxIP tc qdisc add dev eth0 parent 1:1 handle 10: netem delay $delay$ping_unit

#eth1
ssh root@$mainboxIP ssh -i /etc/dropbear/dropbear_rsa_host_key root@$delayboxIP tc qdisc add dev eth1 root handle 1:0 tbf rate $bandwidth$bd_unit burst 16000 latency 5$ping_unit
ssh root@$mainboxIP ssh -i /etc/dropbear/dropbear_rsa_host_key root@$delayboxIP tc qdisc add dev eth1 parent 1:1 handle 10: netem delay $delay$ping_unit


