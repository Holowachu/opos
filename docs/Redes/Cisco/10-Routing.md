# Enrutamiento

## Enrutamiento estático
### Definición de una ruta estática:

```bash
Router(config)# ip route [red-destino] [máscara-destino] [ip-siguiente-salto | interfaz-salida] [distancia] [permanent]
```
> * El siguiente salto puede ser una IP, una interfaz de salida, sin embargo, la interfaz de salida solo se debe indicar en el caso de enlaces punto a punto.
> * **distancia** → Distancia administrativa (0~255), cuanto mayor, peor es la ruta.
> * **permanent** → Indica que la ruta no debe ser eliminada aunque la interfaz de salida deje de estar activa.

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
  
### Ejemplo de ruta por defecto:
```bash
Router(config)# ip route 0.0.0.0 0.0.0.0 Serial 0
```
> Cabe destacar que esta ruta matchea con cualquier destino, pero su prefijo es el más largo posible (/32), por lo que únicamente se aplicará si no se encuentra otra ruta más específica.

### Distancias administrativas predeterminadas:
| | Tipo de ruta | Distancia por defecto |
| ----------- | --- |
| Interfaz o conectada | 0 |
| Estática | 1 |
| EIGRP | 90 |
| OSPF | 110 |
| IS-IS | 115 |
| RIP | 120 |
| EIGRP externo | 170 |
| Inalcanzable | 255 |