#!/bin/bash
#title           :request_response_test.sh
#description     :Run the request and response test for different delay/bandwidth/openvpn protocol
#author		 :Alois paulus
#date            :10/07/2015
#usage		 :bash request_response_test.sh
#==============================================================================

# -------- #
# Variable #
# -------- #
algo=(cubic lia olia wvegas)
#---------------#
# End Variables
#---------------#

# Create result file
 for algo in "${algo[@]}"
 do
   echo "changing congestion algorithm"
   ./change_congestion_algo.sh 192.168.21.11 $algo 
   sleep 2
   echo "netperf running"
   $(netperf -P 0 -v 0 -D 2 -ipv4 -H 10.9.8.1 -t omni -l 40 -f m -- -d maerts -o -H 10.9.8.1 > "data/custom_congestion_algo_basic/"$algo".csv")
   wait
   echo "netperf bench done"
 done
