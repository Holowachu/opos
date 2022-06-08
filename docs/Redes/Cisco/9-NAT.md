# Traducción de direcciones de red (NAT)

## Tipos de NAT
* **NAT estática** - Asignación uno a uno entre direcciones locales y globales.
Es configurada por el administrador de red y se mantienen constantes.

* **NAT dinámica** - Utiliza un conjunto de direcciones públicas y las asigna según el orden de llegada. Requiere que haya suficientes direcciones públicas para la cantidad total de sesiones de usuario simultáneas.

* **Traducción de la dirección del puerto (PAT)** - Asigna varias direcciones IPv4 privadas a una única dirección IPv4 pública o a unas pocas direcciones. También se conoce como sobrecarga de NAT. Valida que los paquetes entrantes hayan sido solicitados. Utiliza números de puerto para reenviar los paquetes de respuesta al dispositivo interno correcto.

## Configuración de NAT en Cisco

* **Configuración de NAT estática**
1. Crear la asignación entre las direcciones locales internas y locales externas.
```bash
Router(config)# ip nat inside source static ip-local ip-global
```
2. Definir qué interfaces pertenecen a la red interna y cuáles a la red externa.
```bash
Router(config)# interface g0/1
Router(config-if)# ip nat inside
Router(config-if)# interface g0/0
Router(config-if)# ip nat outside
```
* **Configuración de NAT dinámica**
1. Crear un pool con las direcciones a las que vamos a natear.
```bash
Router(config)# ip nat pool name ip-inicial ip-final {netmask máscara-de-red | prefix-length longitud-de-prefijo}
```
2. Crear una ACL estándar para permitir la traducción de esas direcciones.
```bash
Router(config)# ip access-list standard nombre-de-lista-de-acceso
Router(config-std-nacl)# permit origen [comodín-de-origen]
```
3. Vincular la ACL al pool.
```bash
Router(config)# ip nat inside source list número-de-lista-de-acceso pool nombre
```
4. Identificar las interfaces internas y externas.
```bash
Router(config)# interface g0/1
Router(config-if)# ip nat inside
Router(config-if)# interface g0/0
Router(config-if)# ip nat outside
```

* **Configuración de PAT: conjunto de direcciones**
1. Crear un pool con las direcciones a las que vamos a natear.
```bash
Router(config)# ip nat pool name ip-inicial ip-final {netmask máscara-de-red | prefix-length longitud-de-prefijo}
```
2. Crear una ACL estándar para permitir la traducción de esas direcciones.
```bash
Router(config)# ip access-list standard nombre-de-lista-de-acceso
Router(config-std-nacl)# permit origen [comodín-de-origen]
```
3. Vincular la ACL al pool.
```bash
Router(config)# ip nat inside source list número-de-lista-de-acceso pool nombre overload
```
> La palabra clave **overload** es la que indica que se realice la sobrecarga (PAT).
4. Identificar las interfaces internas y externas.
```bash
Router(config)# interface g0/1
Router(config-if)# ip nat inside
Router(config-if)# interface g0/0
Router(config-if)# ip nat outside
```

* **Configuración de PAT: dirección única**
1. Definir una ACL estándar para permitir la traducción de esas direcciones.
```bash
Router(config)# ip access-list standard nombre-de-lista-de-acceso
Router(config-std-nacl)# permit origen [comodín-de-origen]
```
2. Establecer la traducción de origen dinámica, especificar la ACL, la interfaz de salida y la opción de sobrecarga.
```bash
Router(config)# ip nat inside source list número-de-lista-de-acceso interface type nombre overload
```
4. Identificar las interfaces internas y externas.
```bash
Router(config)# interface g0/1
Router(config-if)# ip nat inside
Router(config-if)# interface g0/0
Router(config-if)# ip nat outside
```
> Nótese que la interfaz indicada en el comando *ip nat inside* deberá ser la g0/0 en este ejemplo (salida del NAT).

* **Configuración de reenvío a puerto asignado con IOS**
```bash
Router(config)# ip nat inside source [static {tcp | udp ip-local puerto-local ip-global puerto-global} [extendable]
Router(config)# interface g0/1
Router(config-if)# ip nat inside
Router(config-if)# interface g0/0
Router(config-if)# ip nat outside
```

* Ejemplo -Reenvío de puertos hacia un server 172.16.0.2:8080 accesible desde la 80.0.0.1:80-:
```bash
Router(config)# interface GigabitEthernet0/0
Router(config-if)# ip address 172.16.0.1 255.255.0.0
Router(config-if)# ip nat inside
Router(config-if)# interface GigabitEthernet0/1
Router(config-if)# ip address 80.0.0.1 255.0.0.0
Router(config-if)# ip nat outside
Router(config-if)# exit
Router(config)# ip nat inside source static tcp 172.16.0.2 8080 80.0.0.1 80 
```