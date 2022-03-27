#Configuración de FW
```bash
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -N SSH
iptables -N DNS


iptables -A INPUT -p tcp --dport 22 -m state --state NEW -j SSH
iptables -A SSH -s 192.168.1.2 -j ACCEPT
iptables -A SSH -s 192.168.56.1 -j ACCEPT
iptables -A SSH -s 192.168.56.2 -j ACCEPT
iptables -A SSH -j LOG --log-prefix "iptables: SSH Bloqueo "
iptables -A SSH -j DROP


iptables -A OUTPUT -p udp --dport 53 -m state --state NEW -j DNS
iptables -A DNS -d 8.8.8.8 -j ACCEPT
iptables -A DNS -d 8.8.4.4 -j ACCEPT
iptables -A DNS -j DROP

iptables -P INPUT DROP
iptables -P OUTPUT DROP

#Tráfico originado en los equipos de la Intranet

#DNS
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -N DNS_INTRA
iptables -A FORWARD -p udp --dport 53 -d 8.8.8.8 -m state --state NEW -j DNS_INTRA
iptables -A FORWARD -p udp --dport 53 -d 8.8.4.4 -m state --state NEW -j DNS_INTRA
iptables -A DNS_INTRA -s 192.168.56.1 -j ACCEPT
iptables -A DNS_INTRA -s 192.168.56.2 -j ACCEPT
iptables -A DNS_INTRA -s 192.168.56.253 -j ACCEPT

iptables -A DNS_INTRA -m iprange --src-range 192.168.56.3-192.168.56.100 -m time --timestart 07:00:00 --timestop 15:0:00 --weekdays Mon,Tue,Wed,Thu,Fri --kerneltz -j ACCEPT

iptables -A DNS_INTRA -j DROP

#Tráfico WEB
iptables -N WEB_INTRA
iptables -A FORWARD -i eth1 -p tcp -m multiport --dports 80,443 -m state --state NEW -j WEB_INTRA
iptables -A WEB_INTRA -s 192.168.56.1 -j ACCEPT
iptables -A WEB_INTRA -s 192.168.56.2 -j ACCEPT
iptables -A WEB_INTRA -s 192.168.56.253 -j ACCEPT

iptables -A WEB_INTRA -m iprange --src-range 192.168.56.3-192.168.56.100 -m time --timestart 07:00:00 --timestop 15:0:00 --weekdays Mon,Tue,Wed,Thu,Fri --kerneltz -j ACCEPT

iptables -A WEB_INTRA -j DROP

#Reglas NAT para el tráfico iniciado en la Intranet
iptables -t nat -A POSTROUTING -s 192.168.56.0/24 -j SNAT --to-source 192.168.1.254


#Tráfico desde Internet
iptables -t nat -A PREROUTING -p tcp -d 192.168.1.254 -m multiport --dports 80,443 -j DNAT --to-destination 192.168.56.253

iptables -A FORWARD -i eth0 -o eth1 -p tcp -d 192.168.56.253 -m multiport --dports 80,443  -m state --state NEW -j ACCEPT

#Administración por ssh del  servidor desde Internet

iptables -t nat -A PREROUTING -p tcp -d 192.168.1.254 --dport 22000 -j DNAT --to-destination 192.168.56.253:22
iptables -A FORWARD -p tcp -s 192.168.1.2 -d 192.168.56.253 --dport 22  -m state --state NEW -j ACCEPT


#Registros

iptables -A SSH -m limit --limit 5/m --limit-burst 10 -j LOG --log-prefix "iptables: SSH Bloqueo "

#Furtive port scanner:
iptables -A FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s -j ACCEPT
#Ping of death:
iptables -A FORWARD -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT
```
