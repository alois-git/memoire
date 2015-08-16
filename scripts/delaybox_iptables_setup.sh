iptables -A INPUT -p tcp --tcp-flags SYN,ACK SYN,ACK -s 192.168.21.11 -j DROP


iptables -A INPUT -p tcp --tcp-flags SYN,ACK SYN,ACK -s 192.168.22.11 -j DROP
