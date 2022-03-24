
# Servidor DHCP

## DHCPv4

Ejemplo de configuración de router para asignar IPs de la 192.168.10.10 a la 192.168.10.253 con opciones de gateway y DNS:

``` bash
R1(config)# ip dhcp excluded-address 192.168.10.1 192.168.10.9
R1(config)# ip dhcp excluded-address 192.168.10.254 
R1(config)# ip dhcp pool POOL-LAN-1
R1(dhcp-config)# network 192.168.10.0 255.255.255.0
R1(dhcp-config)# default-router 192.168.10.1
R1(dhcp-config)# dns-server 192.168.11.5
R1(dhcp-config)# domain-name example.com
R1(dhcp-config)# end
R1#
```
> Se deben excluir siempre las IPs asignadas a routers, servidores y cualquier otra que se vaya a configurar de manera estática. Con la opción `lease {days [hours [minutes]] | infinite}` se puede configurar la duración de las concesiones.

Configuración de reservas (asociaciones MAC <--> IP automáticas):

``` bash
R1(config)# ip dhcp pool RESERVA-1
R1(dhcp-config)# hardware-address 0800.27AC.1234
R1(dhcp-config)# host 192.168.10.254 255.255.255.0
R1(dhcp-config)# end
```

Configurar un router como agente de retransmisión DHCP hacia un servidor (192.168.10.1):
``` bash
R1(config)# interface Gi0/0
R1(config-if)# ip helper-address 192.168.10.1
```
> Se debe aplicar esta instrucción en la interfaz de la LAN donde recibirá las peticiones DHCP.

## DHCPv6

En IPv6 la configuración de direccionamiento de los hosts se puede configurar de varios modos. Por defecto un router con IPv6 habilitado (`ipv6 unicast-routing`), envía RA periódicamente con información sobre el prefijo IPv6, la puerta de enlace, servidores, etc. Los hosts pueden o bien emplear esta información para generar su propia GUA (indicador A en RA), o bien ser redireccionados hacia un servidor DHCPv6, ya sea para obtener información adicional de red (stateless -  indicador O en RA) o para que directamente este les asigne una GUA (stateful -  indicador M en RA).

<img style="width: 50%; margin-left: auto; margin-right: auto;" src="../slaac-dhcpv6.png">

* Configuración de router como servidor DHCPv6 statefull:
``` bash
Router(config)# ipv6 unicast-routing
Router(config)# ipv6 dhcp pool POOL-LAN-1
Router(config-dhcpv6)# address 2001:1DB8:CAFE::/64
Router(config-dhcpv6)# dns-server 2001:1DB8:CAFE::6
Router(config-dhcpv6)# domain-name xunta.gal
Router(config-dhcpv6)# interface G0/0
Router(config-if)# ipv6 address 2001:1DB8:CAFE::1/64
Router(config-if)# ipv6 dhcp server POOL-LAN-1
Router(config-if)# ipv6 nd managed-config-flag
```
> Se puede configurar la duración de las concesiones con la opción lifetime al indicar la red del pool: `address prefix/length [lifetime {valid-lifetime preferred-lifetime | infinite}]`.
> El comando `ipv6 nd` admite las opciones: `managed-config-flag` (statefull - M) y `other-config-flag` (stateless - O). Con la opción `prefix default no-autoconfig` pondríamos la flag A a 0, indicando que no se autoconfiguren las GLA con el prefijo anunciado.

* Configuración de un router como cliente DHCPv6:
``` bash
R3(config)# interface g0/1
R3(config-if)# ipv6 enable
R3(config-if)# ipv6 address dhcp
```
<img style="width: 50%; margin-left: auto; margin-right: auto;" src="../dhcpv6-client.png">
> El comando `ipv6 enable` se genera una LLA en esa interfaz.
> Con el comand `ipv6 address autoconfig` la interfaz crearía su GUA con SLAAC.

* Configurar un router como agente de retransmisión DHCPv6:
``` bash
R1(config)# interface g0/0
R1(config-if)# ipv6 dhcp relay destination 2001:db8:cafe:1::6
R1(config-if)# end
```