# Listas de control de acceso (ACLs)

## Tipos de ACL en Cisco

* **ACL estándar**: Filtran el tráfico en la capa 3, así que solo podemos definir las restricciones basándonos en el protocolo de red (IPv4 o IPv6) y en la *dirección IP de origen* de los paquetes.
* **ACL extendida**: Filtran el tráfico en las capas 3 y 4, por lo que podemos filtrar por protocolo (IP, TCP, UDP, ICMP...) y direcciones del nivel de transporte (*direcciones IP y puertos de origen y de destino*).
> Cabe destacar que las ACLs en Cisco tienen una política de descarte, es decir, cada ACL que creemos tiene una última regla implícita que descarta todo el tráfico que no hayamos permitido con las reglas anteriores (*deny any*).
---
* **ACL de entrada**: Se aplica a los paquetes que se reciben por una interfaz determinada, antes de que sean enrutados por una interfaz de salida. De este modo, ya no hay que buscar la ruta de salida si el paquete es descartado.
* **ACL de salida**: Se aplica en la interfaz de salida, independientemente de la interfaz por la que fueran recibidos los paquetes.
> De manera predeterminada las ACLs no bloquean el tráfico originado en el router, por lo que una ACL aplicada en salida en una interfaz será ignorada por los paquetes que el router genere y envíe por la misma.
---

* Crear ACL:
```bash
Router(config)# ip access-list [standard | extended] name
```
* Añadir reglas de filtrado estándar:
```bash
Router(config-std-nacl)# [permit | deny | remark] {source [source-wildcard]} [log]
```
> *permit* → Permite
> *deny* → Deniega
> *remark* → Añade un comentario a la ACL
> *source* → IP de la red origen (si es una única IP se puede preceder de la palabra clave *host* y omitimos la wildcard)
> *log* → Genera un mensaje de log

* Aplicar ACL a interfaz de un router:
```bash
Router(config-if)# ip access-group name [in | out]
```
> *in* → Se aplica en entrada
> *out* → Se aplica en salida

* Ejemplo ACL estándar:
```bash
R1(config)# ip access-list standard ACL_1
R1(config-std-nacl)# remark Denegamos el tráfico del host 192.168.11.10 y permitimos el del resto de la red
R1(config-std-nacl)# deny host 192.168.11.10
R1(config-std-nacl)# permit 192.168.10.0 0.0.0.255
R1(config-std-nacl)# exit
R1(config)# interface g0/0
R1(config-if)# ip access-group ACL_1 out
```
> Lo habitual en las ACLs estándar es aplicar el filtro en salida de la interfaz más cercana al destino hacia el que queremos denegar el acceso, pues al poder filtrar únicamente por IP origen debemos evitar cortar el tráfico antes de tiempo para permitir a los equipos llegar al resto de destinos a los que sí se le permite acceder.

* Aplicar ACL estándar a líneas VTY:
```bash
R1(config)# ip access-list standard ACL_1
R1(config-std-nacl)# remark Permitir acceso remoto únicamente desde la red 192.168.10.0/24
R1(config-std-nacl)# permit 192.168.10.0 0.0.0.255
R1(config-std-nacl)# exit
R1(config)# line vty 0 4
R1(config-line)# login local
R1(config-line)# transport input ssh
R1(config-line)# access-class ACL_1 in
```

* Añadir reglas de filtrado extendidas:
```bash
{deny | permit | remark text} protocol source source-wildcard [operator {port}] destination destination-wildcard [operator {port}] [established] [log]
```
> *protocol* → ip, icmp, tcp, udp... 
> *operator* → lt (less than), gt (greater than), eq (equal), neq (not equal)
> *established* → Conexión establecida (**solo para TCP!**)


* Ejemplo ACL extendida:
```bash
R1(config)# ip access-list extended PERMIT-PC1
R1(config-ext-nacl)# Remark Permit PC1 TCP access to internet 
R1(config-ext-nacl)# permit tcp host 192.168.10.10 any eq 20
R1(config-ext-nacl)# permit tcp host 192.168.10.10 any eq 21
R1(config-ext-nacl)# permit tcp host 192.168.10.10 any eq 22
R1(config-ext-nacl)# permit tcp host 192.168.10.10 any eq 23
R1(config-ext-nacl)# permit udp host 192.168.10.10 any eq 53
R1(config-ext-nacl)# permit tcp host 192.168.10.10 any eq 53
R1(config-ext-nacl)# permit tcp host 192.168.10.10 any eq 80
R1(config-ext-nacl)# permit tcp host 192.168.10.10 any eq 443
R1(config-ext-nacl)# deny ip 192.168.10.0 0.0.0.255 any
R1(config-ext-nacl)# exit
R1(config)# 
R1(config)# ip access-list extended REPLY-PC1
R1(config-ext-nacl)# Remark Only permit returning traffic to PC1 
R1(config-ext-nacl)# permit tcp any host 192.168.10.10 established
R1(config-ext-nacl)# exit
R1(config)# interface g0/0/0
R1(config-if)# ip access-group PERMIT-PC1 in
R1(config-if)# ip access-group REPLY-PC1 out
R1(config-if)# end
R1#
```

* Ejemplo ACL IPv6:
```bash
Router(config)# ipv6 access-list DENY_TELNET_Lo4
Router(config-ipv6-acl)# deny tcp host 400A:0:400C::1 host 1001:ABC:2011:7::1 eq telnet
Router(config-ipv6-acl)# permit ipv6 any any
Router(config-ipv6-acl)# exit
Router(config)# interface Serial1/0
Router(config-if)# no ip address
Router(config-if)# ipv6 address AB01:2011:7:100::/64 eui-64
Router(config-if)# ipv6 enable
Router(config-if)# ipv6 traffic-filter DENY_TELNET_Lo4 in
```