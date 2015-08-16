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
delays=(1 25 200)
bws=(8 32 240)
protos=("tcp" "udp")
output_filename="data/request_response_crr_1_1.csv"
#---------------#
# End Variables
#---------------#

# Create result file
echo "Test Name,Local Send Socket Size Final,Local Recv Socket Size Final,Remote Recv Socket Size Final,Remote Send Socket Size Final,Request Size Bytes,Response Size Bytes,Elapsed Time (sec),Throughput,Throughput Units" > $output_filename

for proto in "${protos[@]}"
do
echo "OpenVPN protocol: $proto"
./change_openvpn_protocol.sh $proto 192.168.1.1 192.168.21.11
./restart_openvpn.sh 192.168.1.1 192.168.21.11
for delay in "${delays[@]}"
do
 for bw in "${bws[@]}"
 do
   echo "--------------"	
   echo "Bandwidth: $bw"
   echo "Delay: $delay"
   echo "-------------"
   ./bothdelaybox_setup.sh $bw $bw $delay $delay  
   wait 
   echo "netperf running"

   # Launch a test for 60 second or max 50000 transaction and save result to file
   output=$(netperf -t tcp_rr -H 10.9.8.1 -l 40 -- -r 1,1 -o | sed -n 3p)
   echo ""$proto"_"$bw"_"$delay",$output" >> $output_filename
   wait
   echo "netperf done"
 done
done
done
