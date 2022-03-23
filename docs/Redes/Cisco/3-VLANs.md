# VLANs

## Creación de VLANs en switch

Al crear una VLAN en un switch solo hay que asignarle un identificador y un nombre.

```bash
S1(config)# vlan 10
S1(config-vlan)# name alumnos
S1(config-vlan)# vlan 20
S1(config-vlan)# name profesores
S1(config-vlan)# end
```
## Asignación de puertos de VLAN

### Puertos en modo acceso

Un puerto de acceso solo puede tener asignada una VLAN de datos (más la VLAN de voz).

* Configuración de un puerto de acceso con una VLAN de datos:
```bash
S1(config)# interface Fa0/18
S1(config-if)# switchport mode access
S1(config-if)# switchport access vlan 10
S1(config-if)# end
```

* Configuración de un puerto de acceso con una VLAN de datos y una de voz:
```bash
S1(config)# vlan 10
S1(config-vlan)# name alumnos
S1(config-vlan)# vlan 150
S1(config-vlan)# name voz
S1(config)# interface Fa0/18
S1(config-if)# switchport mode access
S1(config-if)# switchport access vlan 10
S1(config-if)# mls qos trust cos
S1(config-if)# switchport voice vlan 10
S1(config-if)# end
```
> El comando `mls qos trust cos` garantiza que el tráfico de voz se identifique como tráfico prioritario.

### Puertos en modo troncal

En los enlaces troncales se indica la lista de VLANs cuyo tráfico se transporta. Si no se indica con el comando `switchport trunk allowed-vlan vlan vlan-list` y únicamente se activa el modo trunk, por defecto el enlace transportará el tráfico de TODAS las VLANs (sería el equivalente a indicar 'all' en la vlan-list).

Además, todo enlace troncal dispondrá de una VLAN nativa para el envío del tráfico sin etiquetar. Por defecto esta VLAN es la 1, pero se recomienda cambiarla.
```bash
S1(config)# vlan 10
S1(config-vlan)# name alumnos
S1(config-vlan)# vlan 20
S1(config-vlan)# name profesores
S1(config-vlan)# vlan 30
S1(config-vlan)# name servidores
S1(config-vlan)# vlan 99
S1(config-vlan)# name nativa
S1(config)# interface Fa0/18
S1(config-if)# switchport mode trunk
S1(config-if)# switchport trunk native vlan 99
S1(config-if)# switchport trunk allowed-vlan vlan 10,20,30,99
S1(config-if)# end
```
> La vlan nativa solo se debe meter en la vlan-list del `allowed-vlan` en caso de cambiarla.

### Propogación de configuración de VLANs - VTP

En lugar de crear todas las VLANs en cada switch, existe la posibilidad de crearlas solo en uno, configurarlo como servidor VTP, configurar los demás como clientes y que estos aprendan las VLAN creadas en el servidor.

Configuración del server:

```bash
S1(config)# vtp mode server
S1(config)# vtp domain dominio1
S1(config)# vtp password contraseña123
```

Configuración de clientes:
```bash
S1(config)# vtp mode client
S1(config)# vtp domain dominio1
S1(config)# vtp password contraseña123
```
> La contraseña es opcional


## Interconexión de VLANs

### Interconexión legacy

Este método ya no se emplea por su mínima escalabilidad, y consiste en emplear una interfaz del router por VLAN.

<img style="width: 300; height: auto; align: center;" src="../inter-vlan-legacy.png">

* Configuración de R1:
```bash
R1(config)# interface G0/0/0
R1(config-if)# no shutdown
R1(config-if)# ip address 192.168.10.1 255.255.255.0
R1(config-if)# interface G0/0/1
R1(config-if)# no shutdown
R1(config-if)# ip address 192.168.20.1 255.255.255.0
R1(config-if)# end
```

* Configuración de S1:
```bash
S1(config)# vlan 10
S1(config-vlan)# name alumnos
S1(config-vlan)# vlan 20
S1(config-vlan)# name profesores
S1(config-vlan)# interface Fa0/1
S1(config-if)# switchport mode access
S1(config-if)# switchport access vlan 10
S1(config-if)# interface Fa0/11
S1(config-if)# switchport mode access
S1(config-if)# switchport access vlan 10
S1(config-if)# interface Fa0/12
S1(config-if)# switchport mode access
S1(config-if)# switchport access vlan 20
S1(config-if)# interface Fa0/24
S1(config-if)# switchport mode access
S1(config-if)# switchport access vlan 20
S1(config-if)# end
```
> En este escenario el switch segmenta el tráfico, pero el resto de dispositivos serían vlan-unaware.

### Router-on-a-stick

Es la configuración más habitual y escalable, pues hace uso de un enlace troncal y configura una subinterfaz por VLAN.

<img style="float: right;" src="../router-on-a-stick.jpeg">

* Configuración router:
```bash
R1(config)# interface FE0/0
R1(config-if)# no shutdown
R1(config-if)# interface F0/0.10
R1(config-if)# description Subinterfaz VLAN-10
R1(config-if)# encapsulation dot1q 10
R1(config-if)# ip address 192.168.10.1 255.255.255.0
R1(config-if)# interface F0/0.20
R1(config-if)# description Subinterfaz VLAN-20
R1(config-if)# encapsulation dot1q 20
R1(config-if)# ip address 192.168.20.1 255.255.255.0
R1(config-if)# end
```

* Configuración switch:
```bash
S1(config)# vlan 10
S1(config-vlan)# name red
S1(config-vlan)# vlan 20
S1(config-vlan)# name green
S1(config-vlan)# interface F1/0/2
S1(config-if)# switchport mode access
S1(config-if)# switchport access vlan 10
S1(config-if)# interface Fa1/0/3
S1(config-if)# switchport mode access
S1(config-if)# switchport access vlan 20
S1(config-if)# interface Fa1/0/1
S1(config-if)# switchport mode trunk
S1(config-if)# switchport trunk allowed vlan 10,20
S1(config-if)# switchport access vlan 20
S1(config-if)# end
```
> En caso de tener en cuenta la VLAN nativa para que la configuración del trunk contra el router fuese completamente correcta, habría que crear una subinterfaz dedicada para esta interfaz y emplear el comando `encapsulation dot1q 99 native` (suponiendo que sea la 99) y asignarle una IP, o bien configurar una IP directamente en la interfaz global (no en una subinterfaz).

### 