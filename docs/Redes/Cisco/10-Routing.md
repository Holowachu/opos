# Enrutamiento

## Enrutamiento estático
### Definición de una ruta estática en IPv4:

```bash
Router(config)# ip route [red-destino] [máscara-destino] [ip-siguiente-salto | interfaz-salida] (distancia) (permanent)
```
> * El siguiente salto puede ser una IP, una interfaz de salida, sin embargo, la interfaz de salida solo se debe indicar en el caso de enlaces punto a punto. En el caso de emplear una interfaz de salida la ruta se resuelve en una única búsqueda, mientras que si empleamos IP de siguiente salto necesitamos una búsqueda adicional para resolver la interfaz de salida para la IP especificada.
> * `distancia` → Distancia administrativa (0~255), cuanto mayor, peor es la ruta.
> * Es posible indicar como siguiente salto una interfaz de salida seguida por una IP de siguiente salto, es lo que se denomina como rutas estáticas completamente definidas.
> * `permanent` → Indica que la ruta no debe ser eliminada aunque la interfaz de salida deje de estar activa.

Para que una ruta sea agregada a la tabla de enrutamiento debe cumplir dos cosas:

* Para el ip route que usa la interfaz de salida del router, ésta interfaz debe esta en estado up/up.
* Para el ip route que usa la IP del next-hop del siguiente router, el router local debe tener una ruta para alcanzar la dirección del next-hop.

El proceso seguido por el router para construir su tabla de rutas es:

* Se introducen las rutas de las redes directamente conectadas (una para la IP de la interfaz y otra para la red).
* Se introducen las rutas estáticas en la tabla siempre que cumplan las condiciones anteriores.
* Se introducen las rutas aprendidas por protocolos dinámicos (RIP, OSPF...).
* En caso de empate (2 rutas igual de específicas hacia el mismo destino), únicamente se ingresa la ruta con menor distancia administrativa.
> Cabe destacar que este proceso es dinámico, por lo que es habitual disponer de rutas de backup que ingresarán en la tabla en caso de que la de menor distancia quede inaccesible.

Una vez construída la tabla de rutas puede darse el caso de que varias rutas matcheen con el paquete que estamos enrutando. En este caso **el router elegirá la más específica**, esto es, la de mayor prefijo.

### Ejemplo de ruta estática en IPv4:
```bash
R1(config)# ip route 192.168.10.0 255.255.255.0 10.10.10.2
```

### Ejemplo de ruta por defecto en IPv4:
```bash
Router(config)# ip route 0.0.0.0 0.0.0.0 Serial 0
```
> Cabe destacar que esta ruta matchea con cualquier destino, pero su prefijo es el más largo posible (/32), por lo que únicamente se aplicará si no se encuentra otra ruta más específica.


### Definición de una ruta estática en IPv6:

```bash
Router(config)# ipv6 unicast-routing
Router(config)# ipv6 route [red-destino]/[tamaño-prefijo-destino] [ipv6-siguiente-salto | interfaz-salida] (distance [distancia])
```
> El funcionamiento es el mismo que en IPv4 y también se puede especificar interfaz de salida e IPv6 de siguiente salto (en ese orden) para rutas completamente definidas.

### Ejemplo de ruta estática en IPv6:
```bash
R1(config)# ipv6 route 2001:DB8:ACAD:2::/64 s0/0/0
```

### Ejemplo de ruta por defecto en IPv6:
```bash
Router(config)# ip route ::/0 2001:db8:c::9f:35
```

### Distancias administrativas predeterminadas:
| Tipo de ruta | Distancia por defecto |
| ----------- | --- |
| Interfaz o conectada | 0 |
| Estática | 1 |
| EIGRP | 90 |
| OSPF | 110 |
| IS-IS | 115 |
| RIP | 120 |
| EIGRP externo | 170 |
| Inalcanzable | 255 |
> Es habitual configurar lo que se denomina como rutas estáticas flotantes, las cuales especifican una distancia superior a las aprendidas por protocolos dinámicos como 210, con lo cual sólo se emplearán si no descubrimos una mejor hacia dicho destino.
