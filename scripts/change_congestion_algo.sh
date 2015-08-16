#!/bin/bash
#title           :change_congestion_algo.sh
#description     :change the tcp vongestion algorithm 
#author          :Alois paulus
#date            :10/07/2015
#=============================================================================
IP=$1
algo=$2


ssh root@$IP "sysctl -w net.ipv4.tcp_congestion_control=$algo"

