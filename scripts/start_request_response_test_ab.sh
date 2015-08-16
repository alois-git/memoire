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
output_filename="data/request_response_ab.csv"
#---------------#
# End Variables
#---------------#

# Create result file
echo "Test Name,Concurrency Level,Requests per second [#/sec] (mean),Time per request [ms] (mean),Time per request [ms] (mean, across all concurrent requests),Transfer rate [Kbytes/sec]'" > $output_filename

for proto in "${protos[@]}"
do
echo "Changing OpenVPN protocol to $proto"
./change_openvpn_protocol.sh $proto 192.168.1.1 192.168.21.11
./restart_openvpn.sh 192.168.1.1 192.168.21.11
for delay in "${delays[@]}"
do
 for bw in "${bws[@]}"
 do
   echo "--------------"
   echo "Delaybox Setup"
   echo "Bandwidth: $bw"
   echo "Delay: $delay"
   echo "-------------"
   ./bothdelaybox_setup.sh $bw $bw $delay $delay  
   wait 
   echo "apache bench running"

   # Launch a test for 60 second or max 50000 transaction and save result to file
   output=$(ab -k -c 6 -n 50000 -t 60 http://10.9.8.1/ | grep -E 'Requests per second:|Time per request:|Transfer rate:|Concurrency Level:')
   readarray -t results <<<"$output"
   writeV=""
   for i in "${results[@]}"
   do
    extract=$(echo $i | cut -d':' -f2 | cut -d' ' -f2)
    writeV="$writeV,$extract"
   done
   echo ""$proto"_"$bw"_"$delay"$writeV" >> $output_filename
   wait
   echo "apache bench done"
 done
done
done
