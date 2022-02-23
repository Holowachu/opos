#IPTABLES
|![Tablas y cadenas predeterminadas más utilizadas en netfilter](netfilter_abreviado_003.png)|
|:--:|
|**Imagen 1:** Tablas y cadenas predeterminadas más utilizadas en netfilter|

##Politicas por defecto
```
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
```
##Reglas estáticas
<<<<<<< Local Changes
```
=======
No guardan el estado de las conexiones
```console title="Salida"
>>>>>>> External Changes
iptables -A OUTPUT -p udp --dport 53 -d 8.8.8.8 -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -d 8.8.4.4 -j ACCEPT
```
```console title="Entrada"
iptables -A INPUT -p udp --sport 53 -s 8.8.8.8 -j ACCEPT
iptables -A INPUT -p udp --sport 53 -s 8.8.4.4 -j ACCEPT
```
