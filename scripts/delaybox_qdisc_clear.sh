#!/bin/bash
#title           :delaybox_clear_qdisc.sh
#description     :Remove the delay/bandwidth limitation from a delaybox
#author          :Alois paulus
#date            :10/07/2015
#usage           :bash delaybox_clear_qdisc.sh delayboxIP
#==============================================================================

IP=$1
gateway=192.168.1.1
# remove previous qdisc
echo "removing any qdisc on interfaces"
ssh root@$gateway ssh -i /etc/dropbear/dropbear_rsa_host_key root@$IP tc qdisc del dev eth0 root || true
ssh root@$gateway ssh -i /etc/dropbear/dropbear_rsa_host_key root@$IP tc qdisc del dev eth1 root || true

