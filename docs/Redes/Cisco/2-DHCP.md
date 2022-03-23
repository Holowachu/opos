
# Servidor DHCP

Ejemplo de configuración de router para asignar IPs de la 192.168.10.10 a la 192.168.10.253 con opciones de gateway y DNS:

```bash
R1(config)# ip dhcp excluded-address 192.168.10.1 192.168.10.9
R1(config)# ip dhcp excluded-address 192.168.10.254 
R1(config)# ip dhcp pool LAN-POOL-1
R1(dhcp-config)# network 192.168.10.0 255.255.255.0
R1(dhcp-config)# default-router 192.168.10.1
R1(dhcp-config)# dns-server 192.168.11.5
R1(dhcp-config)# domain-name example.com
R1(dhcp-config)# end
R1#
```
Configuración de reservas (asociaciones MAC <--> IP automáticas):

```bash
R1(config)# ip dhcp pool RESERVA-1
R1(dhcp-config)# hardware-address 0800.27AC.1234
R1(dhcp-config)# host 192.168.10.254 255.255.255.0
R1(dhcp-config)# end
```

Configurar un router como agente de retransmisión DHCP hacia un servidor (192.168.10.1):
```bash
R1(config)# interface Gi0/0
R1(config-if)# ip helper-address 192.168.10.1
```
> Se debe aplicar esta instrucción en la interfaz de la LAN donde recibirá las peticiones DHCP.