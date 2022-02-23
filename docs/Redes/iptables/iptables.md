#IPTABLES
|![Tablas y cadenas predeterminadas más utilizadas en netfilter](netfilter_abreviado_003.png)|
|:--:|
|**Imagen 1:** Tablas y cadenas predeterminadas más utilizadas en netfilter|

##Politicas por defecto
```console title="Denegar por defecto (CleanUp Rules)"
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
```
##Reglas estáticas
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
##Reglas con estados persistentes
```console title="Persistentes"
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -A OUTPUT -p udp --dport 53 -d 8.8.8.8 -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p tcp -m multiport --dports 80,443 -m state --state NEW -j ACCEPT

iptables -A INPUT -p tcp --dport 22 -m state --state NEW -j ACCEPT
```
