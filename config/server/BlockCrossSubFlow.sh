iptables -A INPUT -s 192.168.22.1 -d 192.168.21.11 -j DROP
iptables -A INPUT -s 192.168.21.1 -d 192.168.22.11 -j DROP

