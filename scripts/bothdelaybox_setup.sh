#!/bin/bash
#title           :bothdelaybox_setup.sh
#description     :Setup the two delaybox 192.168.21.2 and 192.168.22.2
#author          :Alois paulus
#date            :10/07/2015
#usage           :bash botdelaybox_setup.sh rate1 rate2 delay1 delay2
#==============================================================================


rate_1=$1
rate_2=$2
delay_1=$3
delay_2=$4

./delaybox_qdisc_setup.sh 192.168.21.2 $rate_1 $delay_1
./delaybox_qdisc_setup.sh 192.168.22.2 $rate_2 $delay_2
