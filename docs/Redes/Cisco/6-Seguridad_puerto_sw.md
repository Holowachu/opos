# Seguridad de puerto en switch

## Activación de seguridad de puerto

* Activar seguridad en puerto de switch:
```bash
Sw(config)# interface interface-id
Sw(config-if)# switchport port-security
```
> Antes de activar la seguridad de puerto se debe configurar el puerto en modo acceso o trunk manualmente, ya que de manera predeterminada se encuentra en modo dinámico y este modo no admite seguridad de puerto.

## Restricciones de MACs conectadas

* Establecer un número máximo de MACs conectadas a un puerto:
```bash
Sw(config)# interface interface-id
Sw(config-if)# switchport port-security maximum number
```
> El valor por defecto al activar la seguridad de puerto es 1.

El switch se puede configurar para aprender direcciones MAC en un puerto seguro de tres maneras:

* **Configuración manual**:
```bash
Sw(config)# interface interface-id
Sw(config-if)# switchport port-security mac-address 0200.1111.1111
```

* **Aprendizaje dinámico**: al activar la seguridad de puerto, la MAC del dispositivo conectado al puerto se asegura automáticamente, pero no se añade a la configuración en ejecución. Si el switch es reiniciado, el puerto tendrá que re-aprender la direccion MAC del dispositivo.

* **Aprendizaje dinámico - Sticky**: el switch puede aprender dinámicamente la dirección MAC y "adherirla" a la configuración en ejecución del siguiente modo:
```bash
Sw(config)# interface interface-id
Sw(config-if)# switchport port-security mac-address sticky
```

## Violación de seguridad de puerto

* Configurar acción ante la violación de restricciones:
```bash
Sw(config)# interface interface-id
Sw(config-if)# switchport port-security violation {protect|restrict|shutdown}
```
  
                           |Protegido (protect)|Restringido (restrict)|Apagar (shutdown)*
---------------------------|-------------------|----------------------|------------------
Descartar tráfico ofensivo|Si|Si|Si
Envía mensajes de registro y SNMP|No|Si|Si
Incrementa el contador de violación por cada violación de trama que llega|No|Si|Si
Deshabilita la interfaz poniéndola en estado err-disable y descartando todo el tráfico|No|No|Si

> *shutdown es la acción de configuración por defecto.
