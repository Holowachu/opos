#XSD

##Vinculación con XSD

``` xml title="marcadores.xml" linenums="1"
<?xml version="1.0" encoding="UTF-8"?>
<marcadores xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:noNamespaceSchemaLocation="marcadores.xsd">
   <pagina>
      <nombre>Abrirllave</nombre>
      <descripcion>Tutoriales de informática.</descripcion>
      <url>http://www.abrirllave.com/</url>
   </pagina>
   <pagina>
      <nombre>Wikipedia</nombre>
      <descripcion>La enciclopedia libre.</descripcion>
      <url>http://www.wikipedia.org/</url>
   </pagina>
   <pagina>
      <nombre>W3C</nombre>
      <descripcion>World Wide Web Consortium.</descripcion>
      <url>http://www.w3.org/</url>
   </pagina>
</marcadores>
```
``` xml title="marcadores.xsd" linenums="1"
<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="marcadores">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="pagina" maxOccurs="unbounded">
          <xs:complexType>
            <xs:sequence>
              <xs:element name="nombre" type="xs:string"/>
              <xs:element name="descripcion" type="xs:string"/>
              <xs:element name="url" type="xs:string"/>
             </xs:sequence>
          </xs:complexType>
        </xs:element>
      </xs:sequence>
    </xs:complexType>
  </xs:element>
</xs:schema>
```

##Definición de elementos

``` xml
<xs:element name="xxx" type="yyy"/>
```

* **name** - Define el nombre del elemento.
* **type** - Define el tipo del elemento. Algunos de los tipos más comunes son:
  * xs:string
  * xs:decimal
  * xs:integer
  * xs:boolean
  * xs:date
  * xs:time

###Valores por defecto
``` xml
<xs:element name="color" type="xs:string" default="red"/>
```

###Valores fijos
``` xml
<xs:element name="color" type="xs:string" fixed="red"/>
```

##Definición de atributos
``` xml
<xs:attribute name="xxx" type="yyy"/>
```
Los tipos de datos definidos por XSD son los mismos que ya vimos para los elementos.

###Atributos opcionales y obligatorios
``` xml
<xs:attribute name="lang" type="xs:string" use="required"/>
```
**use** puede tomar los siguiente valores:
* required - Atributo obligatorio.
* optional - Atributo opcional.

##Elementos complejos
Un elemento complejo es todo aquel que contenga otros elementos y/o atributos. Por tanto, al no existir un tipo simple de datos predefinido que se amolde a nuestro elemento, debemos definir un tipo complejo de datos (complexType).

###Indicadores de orden
Los tipos complejos que contengan otros elementos deben indocar el orden de los mismos, mediante el uso de una de las siguientes estructuras:

* **Sequence** - Secuencia ordenada de elementos.

``` xml
<xs:element name="empleado" type="tipoPersona"/>

<xs:complexType name="tipoPersona">
  <xs:sequence>
    <xs:element name="nombre" type="xs:string"/>
    <xs:element name="apellidos" type="xs:string"/>
  </xs:sequence>
</xs:complexType>
```
* **All** - Secuencia desordenada de elementos. En esta estructura el maxOccurs de cada elemento no se puede modificar (siempre vale 1) y el minOccurs podrá valer 0 o 1.

``` xml
<xs:element name="persona">
  <xs:complexType>
    <xs:all>
      <xs:element name="nombre" type="xs:string"/>
      <xs:element name="apellidos" type="xs:string"/>
    </xs:all>
  </xs:complexType>
</xs:element>
```

* **Choice** - Elección entre los elementos de un enumerado.

``` xml
<xs:element name="persona">
  <xs:complexType>
    <xs:choice>
      <xs:element name="en_activo" type="xs:string"/>
      <xs:element name="retirado" type="xs:string"/>
    </xs:choice>
  </xs:complexType>
</xs:element>
```

###Indicadores de ocurrencia

* **maxOccurs** - Limita el número máximo de apariciones de un elemento.

``` xml
<xs:element name="person">
  <xs:complexType>
    <xs:sequence>
      <xs:element name="full_name" type="xs:string"/>
      <xs:element name="child_name" type="xs:string" maxOccurs="10"/>
    </xs:sequence>
  </xs:complexType>
</xs:element>
```
* **minOccurs** - Limita el número mínimo de apariciones de un elemento.

``` xml
<xs:element name="person">
  <xs:complexType>
    <xs:sequence>
      <xs:element name="full_name" type="xs:string"/>
      <xs:element name="child_name" type="xs:string" maxOccurs="10" minOccurs="0"/>
    </xs:sequence>
  </xs:complexType>
</xs:element>
```

###Indicadores de grupo

####Grupos de elementos

Se declaran con **xs:group** y sirven para agrupar conjuntos de elementos relacionados que después podrán ser referenciados en tipos complejos de datos.

``` xml
<xs:group name="persongroup">
  <xs:sequence>
    <xs:element name="firstname" type="xs:string"/>
    <xs:element name="lastname" type="xs:string"/>
    <xs:element name="birthday" type="xs:date"/>
  </xs:sequence>
</xs:group>

<xs:element name="person" type="personinfo"/>

<xs:complexType name="personinfo">
  <xs:sequence>
    <xs:group ref="persongroup"/>
    <xs:element name="country" type="xs:string"/>
  </xs:sequence>
</xs:complexType>
```

####Grupos de atributos

Se declaran con **xs:attributeGroup** y sirven para agrupar conjuntos de atributos relacionados que después podrán ser referenciados en tipos complejos de datos.

``` xml
<xs:attributeGroup name="personattrgroup">
  <xs:attribute name="firstname" type="xs:string"/>
  <xs:attribute name="lastname" type="xs:string"/>
  <xs:attribute name="birthday" type="xs:date"/>
</xs:attributeGroup>

<xs:element name="person">
  <xs:complexType>
    <xs:attributeGroup ref="personattrgroup"/>
  </xs:complexType>
</xs:element>
```


##Extensiones y restricciones

TODO: Meter ejemplos de las dos. String con atributos (complexType con simpleContent), restricciones sobre tipos simples (longitud, valores, pattern...), elementos vacíos sin atributos (caso anterios con length="0").

Cosas raras: Elementos solo con atributos, mixed, union, unique, key y keyref.