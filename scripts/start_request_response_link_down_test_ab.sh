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
delays=(1)
bws=(8 32)	
protos=("tcp" "udp")
#bws=(32)
#protos=("tcp")
output_filename="data/request_response_link_down.csv"
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
   # Launch the two command to add a loss and remove a loss in the background
   ( sleep 5; echo "link down"; ssh root@192.168.1.1 ssh -i /etc/dropbear/dropbear_rsa_host_key root@192.168.21.2 tc qdisc add dev eth1 parent 10:1 handle 20: netem loss 100% ) &
   ( sleep 15; echo "link back up"; ssh root@192.168.1.1 ssh -i /etc/dropbear/dropbear_rsa_host_key root@192.168.21.2 tc qdisc del dev eth1 parent 10:1 handle 20: ) &
   # Launch a test for 60 second or max 50000 transaction and save result to file
   output=$(ab -k -c 6 -t 30 http://10.9.8.1/ | grep -E 'Requests per second:|Time per request:|Transfer rate:|Concurrency Level:')
   readarray -t results <<<"$output"
   writeV=""
   # For each output of apache bench, extract the result we want
   for i in "${results[@]}"
   do
    extract=$(echo $i | cut -d':' -f2 | cut -d' ' -f2)
    writeV="$writeV,$extract"
   done
   # Write result to result file
   echo ""$proto"_"$bw"_"$delay"$writeV" >> $output_filename
   wait
   echo "apache bench done"
 done
done
done
