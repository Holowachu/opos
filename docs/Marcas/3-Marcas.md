# Marcas

``` xml title="Reservas.xml" linenums="1"
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="reservas.xsl"?>
<reservas xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="reservas.xsd">
    <reserva_habitacion cliente="C_53454123X" opciones="AD" tipoHabitacion="Doble">
        <fechaEntrada ano="2021" mes="Junio" dia="18"></fechaEntrada>
        <fechaSalida ano="2021" mes="Junio" dia="19"></fechaSalida>
        <observaciones>Llegan sobre las 20:30</observaciones>
    </reserva_habitacion>
    <reserva_habitacion cliente="C_32555111A" opciones="MP" tipoHabitacion="Individual">
        <fechaEntrada ano="2021" mes="Agosto" dia="2"></fechaEntrada>
        <fechaSalida ano="2021" mes="Agosto" dia="4"></fechaSalida>
    </reserva_habitacion>
    <reserva_salon cliente="C_53454123X">
        <fechaEntrada ano="2021" mes="Octubre" dia="25"></fechaEntrada>
        <fechaSalida ano="2021" mes="Octubre" dia="25"></fechaSalida>
    </reserva_salon>
    <reserva_salon cliente="C_44545123A">
        <fechaEntrada ano="2021" mes="Agosto" dia="15"></fechaEntrada>
        <fechaSalida ano="2021" mes="Agosto" dia="15"></fechaSalida>
        <observaciones>Servicio de catering</observaciones>
    </reserva_salon>
    <cliente id="C_53454123X">
        <nombre>Clara</nombre>
        <apellidos>Lago Grau</apellidos>
        <movil>655656777</movil>
    </cliente>
    <cliente id="C_4454123A">
        <nombre>Fernando</nombre>
        <apellidos>Simón Soria</apellidos>
        <movil>785567811</movil>
    </cliente>
    <cliente id="C_32555111A">
        <nombre>Francisco</nombre>
        <apellidos>Castro Ramos</apellidos>
        <movil>649567811</movil>
    </cliente>
    <cliente id="C_37545123L">
        <empleado>E2_4</empleado>
    </cliente>
</reservas>
```

``` xslt title="Reservas.xsl" linenums="1"
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">
    <html lang="es">
        <head>
            <meta charset="UTF-8"/>
            <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
            <title>TÁBOA DE DATOS</title>
            <style>
                table,th,td{
                    border:1px black solid;
                    border-collapse:collapse;
                    padding:1%;
                }
                th{
                    text-align:center;
                    background-color:#ddd;
                }
                td{
                    width:20%;
                }
          </style>
        </head>
        <body>
            <table>
                <tr>
                    <th colspan="3">Reserva de salones</th>
                </tr>
                <tr>
                    <th>Fecha entrada</th>
                    <th>Cliente</th>
                    <th>Observaciones</th>
                </tr>
                <!--de esta forma, llamamos a la plantilla reserva_salon por cada reserva que se encuentre-->
                <xsl:apply-templates select="reservas/reserva_salon">
                <!--el comando sort solo puede ir entre las etiquetas apply-templates o for-each y no puede tener contenido-->
                    <xsl:sort order="ascending" data-type="text" select="fechaEntrada/@mes"/>
                </xsl:apply-templates>
            </table>
        </body>
    </html>
</xsl:template>
 <!--después, este es el patrón que va a ir creando filas en la tabla cada vez que encuentre la etiqueta reserva_salon-->
    <xsl:template match="reserva_salon">
        <xsl:element name="tr">
            <xsl:element name="td">
            <!--crear el enlace no tiene dificultad: cuando hay "" se ponen {} para lo que necesite ser procesado-->
                <xsl:value-of select="fechaEntrada/@dia"/>-
                <xsl:value-of select="fechaEntrada/@mes"/>-
                <xsl:value-of select="fechaEntrada/@ano"/>
            </xsl:element>
            <xsl:element name="td">
                <xsl:value-of select="@cliente"/>
            </xsl:element>
            <xsl:element name="td">
                <xsl:value-of select="observaciones"/>                         
            </xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
```
## Ejemplo Título 2
OPOS 2021- EJERCICIO 2.3

c)nombre de clientes que reservaron habitación con entrada en agosto
``` xquery
//reserva_habitacion/fechaEntrada[@mes="Agosto"]/../@cliente
```
me devuelve: cliente="C_32555111A"
``` xquery
//cliente[@id="C_32555111A"]/nombre/text()
```
me devuelve:  Francisco
ahora sustituyo, y quedaría así:
``` xquery
//cliente[@id=//reserva_habitacion/fechaEntrada[@mes="Agosto"]/../@cliente]/nombre/text()
```

d)identificador de los clientes cuyo nombre empieza por "F"
``` xquery
//cliente[starts-with(nombre, "F")]/@id
```


TESTv 