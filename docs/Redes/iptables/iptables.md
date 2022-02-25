#IPTABLES
|![Tablas y cadenas predeterminadas más utilizadas en netfilter](netfilter_abreviado_003.png)|
|:--:|
|**Imagen 1:** Tablas y cadenas predeterminadas más utilizadas en netfilter|
##Configuración básica
###Politicas por defecto
```console title="Denegar por defecto (CleanUp Rules)"
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
```
###Reglas estáticas
No guardan el estado de las conexiones
```console title="Salida"
iptables -A OUTPUT -p udp --dport 53 -d 8.8.8.8 -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -d 8.8.4.4 -j ACCEPT
```
```console title="Entrada"
iptables -A INPUT -p udp --sport 53 -s 8.8.8.8 -j ACCEPT
iptables -A INPUT -p udp --sport 53 -s 8.8.4.4 -j ACCEPT
```
```console title="Varios puertos al mismo tiempo"
iptables -A OUTPUT -p tcp -m multiport --dports 80,443 -j ACCEPT
iptables -A INPUT -p tcp -m multiport --sports 80,443 -j ACCEPT
```
###Reglas con estados persistentes
```console title="Persistentes"
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -A OUTPUT -p udp --dport 53 -d 8.8.8.8 -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p tcp -m multiport --dports 80,443 -m state --state NEW -j ACCEPT

iptables -A INPUT -p tcp --dport 22 -m state --state NEW -j ACCEPT
```
##SNAT (Source Network Address Translation)
En netfilter, SNAT o Masquerade se realizan en la cadea POSTROUTING y permite especificar:
- La Dirección IP origen que debe ponerse
- Iindicar el puerto/s
```console title="SNAT / Masquerade" hl_lines="4"
# La IP de origen de los paquetes procedentes de los equipos de la red 192.168.1.0/24 será reemprazada por 79.0.0.1
iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -j SNAT --to-source 79.0.0.1
# La IP de origen de los paquetes procedentes de los equipos de la red 192.168.1.0/24 será reemprazada por la IP pública del router
iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -j MASQUERADE
# La IP de origen de los paquetes procedentes de equipos de la red 192.168.1.0/24 será reemprazada por 79.0.0.1 y el puerto de origen tcp/udp se cambiara por un de rango 100-1100
iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -j SNAT --to-source 79.0.0.1:100-1100
# La IP de origen de los paquetes procedentes de los equipos de la red 192.168.1.0/24 será reemprazada por una IP del rango 79.0.0.1-79.0.0.6
iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -j SNAT --to-source 79.0.0.1-79.0.0.6
# La IP de origen de los paquetes procedentes de los equipos de la red 192.168.1.0/24 será reemprazada por  una IP del rango 79.0.0.1-79.0.0.6 y 80.0.0.1
iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -j SNAT --to-source 79.0.0.1-79.0.0.6 --to-source 80.0.0.1
```