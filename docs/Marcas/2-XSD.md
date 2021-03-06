# XSD

## Vinculación con XSD

### XML sin espacio de nombres

``` xml title="marcadoresNoNS.xml" linenums="1"
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
``` xml title="marcadoresNoNS.xsd" linenums="1"
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

### XML con espacio de nombres

``` xml title="marcadoresNS.xml" linenums="1"
<?xml version="1.0" encoding="UTF-8"?>
<mar:marcadores xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="http://www.abrirllave.com/marcadores marcadores.xsd"
xmlns:mar="http://www.abrirllave.com/marcadores">
   <mar:pagina>
      <mar:nombre>Abrirllave</mar:nombre>
      <mar:descripcion>Tutoriales de informática.</mar:descripcion>
      <mar:url>http://www.abrirllave.com/</mar:url>
   </mar:pagina>
   <mar:pagina>
      <mar:nombre>Wikipedia</mar:nombre>
      <mar:descripcion>La enciclopedia libre.</mar:descripcion>
      <mar:url>http://www.wikipedia.org/</mar:url>
   </mar:pagina>
   <mar:pagina>
      <mar:nombre>W3C</mar:nombre>
      <mar:descripcion>World Wide Web Consortium.</mar:descripcion>
      <mar:url>http://www.w3.org/</mar:url>
   </mar:pagina>
</mar:marcadores>
```
``` xml title="marcadoresNS.xsd" linenums="1"
<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"
targetNamespace="http://www.abrirllave.com/marcadores"
xmlns="http://www.abrirllave.com/marcadores"
elementFormDefault="qualified">
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

## Definición de elementos

``` xml title="element.xsd" linenums="1"
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

### Valores por defecto
``` xml title="default.xsd" linenums="1"
<xs:element name="color" type="xs:string" default="red"/>
```

### Valores fijos
``` xml title="fixed.xsd" linenums="1"
<xs:element name="color" type="xs:string" fixed="red"/>
```

## Definición de atributos
``` xml title="attribute.xsd" linenums="1"
<xs:attribute name="xxx" type="yyy"/>
```
Los tipos de datos definidos por XSD son los mismos que ya vimos para los elementos.

### Atributos opcionales, obligatorios y prohibidos
``` xml title="required.xsd" linenums="1"
<xs:attribute name="lang" type="xs:string" use="required"/>
```
**`use`** puede tomar los siguiente valores:

* `required` - Atributo obligatorio.
* `optional` - Atributo opcional.
* `prohibited` - Atributo prohibido (no puede usarse).

### Reutilización de atributos

``` xml title="refAttribute.xsd" linenums="1"
<xs:attribute name="mybaseattribute">
  <xs:simpleType>
   <xs:restriction base="xs:integer">
      <xs:maxInclusive value="1000"/>
   </xs:restriction>
  </xs:simpleType>
</xs:attribute>
<xs:complexType name="myComplexType">
  <xs:attribute ref="mybaseattribute"/>
</xs:complexType>
```
> Podemos definir un atributo aislado para después reutilizarlo en la definición de varios tipos complejos mediante el atributo `ref`.

## Elementos complejos
Un elemento complejo es todo aquel que contenga otros elementos y/o atributos. Por tanto, al no existir un tipo simple de datos predefinido que se amolde a nuestro elemento, debemos definir un tipo complejo de datos (complexType).

### Indicadores de orden
Los tipos complejos que contengan otros elementos deben indocar el orden de los mismos, mediante el uso de una de las siguientes estructuras:

* **Sequence** - Secuencia ordenada de elementos.
``` xml title="sequence.xsd" linenums="1"
<xs:element name="empleado" type="tipoPersona"/>

<xs:complexType name="tipoPersona">
  <xs:sequence>
    <xs:element name="nombre" type="xs:string"/>
    <xs:element name="apellidos" type="xs:string"/>
  </xs:sequence>
</xs:complexType>
```

* **All** - Secuencia desordenada de elementos. En esta estructura el maxOccurs de cada elemento no se puede modificar (siempre vale 1) y el minOccurs podrá valer 0 o 1.
``` xml title="all.xsd" linenums="1"
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
``` xml title="choice.xsd" linenums="1"
<xs:element name="persona">
  <xs:complexType>
    <xs:choice>
      <xs:element name="en_activo" type="xs:string"/>
      <xs:element name="retirado" type="xs:string"/>
    </xs:choice>
  </xs:complexType>
</xs:element>
```

### Indicadores de ocurrencia

* **maxOccurs** - Limita el número máximo de apariciones de un elemento.
``` xml title="maxOccurs.xsd" linenums="1"
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
``` xml title="minOccurs.xsd" linenums="1"
<xs:element name="person">
  <xs:complexType>
    <xs:sequence>
      <xs:element name="full_name" type="xs:string"/>
      <xs:element name="child_name" type="xs:string" maxOccurs="10" minOccurs="0"/>
    </xs:sequence>
  </xs:complexType>
</xs:element>
```

### Indicadores de grupo

#### Grupos de elementos

Se declaran con **xs:group** y sirven para agrupar conjuntos de elementos relacionados que después podrán ser referenciados en tipos complejos de datos.

``` xml title="group.xsd" linenums="1"
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

#### Grupos de atributos

Se declaran con **xs:attributeGroup** y sirven para agrupar conjuntos de atributos relacionados que después podrán ser referenciados en tipos complejos de datos.

``` xml title="attributeGroup.xsd" linenums="1"
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

### Elementos complejos con contenido mixto

Permiten intercalar los subelementos con texto.
``` xml title="mixed.xsd" linenums="1"
<xs:element name="letter">
  <xs:complexType mixed="true">
    <xs:sequence>
      <xs:element name="name" type="xs:string"/>
      <xs:element name="orderid" type="xs:positiveInteger"/>
      <xs:element name="shipdate" type="xs:date"/>
    </xs:sequence>
  </xs:complexType>
</xs:element>
```

## Extensiones

Se usan en general para añadir nuevos elementos o atributos a cualquier tipo definido. Como por ejemplo, para definir elementos con contenido simple, pero que contienen atributos.

``` xml title="extension.xsd" linenums="1"
<xs:element name="distancia">
  <xs:complexType>
    <xs:simpleContent>
      <xs:extension base="xs:double">
        <xs:attribute name="unidad" type="xs:string"/>
      </xs:extension>
     </xs:simpleContent>
  </xs:complexType>
</xs:element>
```

``` xml title="extension.xml" linenums="1"
<distancia unidad="Km">32</distancia>
```

## Restricciones

Se emplean para restringir los valores que puede tomar un tipo simple, ya sea de un elemento o de un atributo. Siguen la siguiente estructura:
``` xml title="restriction.xsd" linenums="1"
<xs:simpleType name="nombreTipoSimple">
  <xs:restriction base="nombreTipoBase">
    ...
  </xs:restriction>
</xs:simpleType>
```

### Restricciones por rangos de valores

* **minInclusive** - Mínimo valor incluyéndolo.
* **maxInclusive** - Máximo valor incluyéndolo.
* **minExclusive** - Mínimo valor excluyéndolo.
* **maxExclusive** - Máximo valor excluyéndolo.

``` xml title="range.xsd" linenums="1"

<xs:simpleType name="ageType">
  <xs:restriction base="xs:integer">
    <xs:minExclusive value="0"/>
    <xs:maxInclusive value="120"/>
  </xs:restriction>
</xs:simpleType>
```

### Restricciones por conjunto de valores

Limitan los valores posibles al conjunto definido en el enumerado.

``` xml title="enumeration.xsd" linenums="1"
<xs:simpleType name="carType">
  <xs:restriction base="xs:string">
    <xs:enumeration value="Audi"/>
    <xs:enumeration value="Mercedes"/>
    <xs:enumeration value="BMW"/>
  </xs:restriction>
</xs:simpleType>
```

``` xml title="enumeration.xsd" linenums="1"
<xs:simpleType name="Sizes">
      <xs:restriction base="xs:decimal">
         <xs:enumeration value="10.5"/>
         <xs:enumeration value="9"/>
         <xs:enumeration value="8"/>
         <xs:enumeration value="11"/>
      </xs:restriction>
   </xs:simpleType>   

   <xs:attribute name="shoeSizes">
      <xs:simpleType>
         <xs:list itemType="Sizes"/>
      </xs:simpleType>
   </xs:attribute>
```
> Permitiría una lista de valores al atributo como: `shoeSizes="10.5 9 8 11"`.
### Restricciones por longitud

* **length** - Longitud exacta.
* **maxLength** - Máxima longitud.
* **minLength** - Mínima longitud.

``` xml title="length.xsd" linenums="1"
<xs:simpleType name="passwordType">
  <xs:restriction base="xs:string">
    <xs:minLength value="5"/>
    <xs:maxLength value="8"/>
  </xs:restriction>
</xs:simpleType>
```

Ejemplo de un elemento vacío y sin atributos:
``` xml title="empty.xsd" linenums="1"
<xs:simpleType name="emptyType">
  <xs:restriction base="xs:string">
    <xs:maxLength value="0"/>
  </xs:restriction>
</xs:simpleType>
```

### Restricciones por patrones

Limita los valores posibles a aquellos que cumplan un determinado patrón. Con esta restricción se pueden modelar todas las anteriores.

``` xml title="pattern.xsd" linenums="1"
<xs:simpleType name="tipoDNI">
    <xs:restriction base="xs:string">
      <xs:pattern value="([0-9]{8}[A-Z]{1})" />
    </xs:restriction>
</xs:simpleType>
```

### Restricciones de uso de atributos

Limita el uso de los atributos definidos para un tipo base.

``` xml title="required.xsd" linenums="1"
<xs:complexType name="A">
  <xs:attribute name="x" type="xs:integer"/>
  <xs:attribute name="y" type="xs:integer"/>
</xs:complexType>

<xs:complexType name="B">
  <xs:complexContent>
    <xs:restriction base="xs:A">
      <xs:attribute name="x" use="required" />
      <xs:attribute name="y" use="prohibited"/>
    </xs:restriction>
  </xs:complexContent>
</xs:complexType>
```

## Tipos union

Sirven para crear nuevos tipos de datos mediante la unión de otros, de tal modo que podrá tomar el valor indicado por cualquiera de ellos.

``` xml title="union.xsd" linenums="1"
<xs:simpleType name="tipoNum">
  <xs:union memberTypes="integer float" />
</xs:simpleType>
```

``` xml title="union.xsd" linenums="1"
<xs:simpleType name="tipoNota">
  <xs:union>
    <xs:simpleType>
      <xs:restriction base="xs:integer">
        <xs:maxInclusive value="1"/>
        <xs:minInclusive value="10"/>
      </xs:restriction>
    </xs:simpleType>
    <xs:simpleType>
      <xs:restriction base="xs:string">
        <xs:enumeration value="NP"/>
      <xs:restriction>
    </xs:simpleType>
  </xs:union>
</xs:simpleType>
```

## Unicidad

### Unique

El elemento **unique** permite indicar que un elemento o atributo deberá tomar un valor único en todo el documento. Puede ser nulo.

Consta de dos elemento:

* **selector** - Empleando XPath selecciona un subconjunto del documento.
* **field** - Empleando XPath selecciona el campo que deberá ser clave dentro del subconjunto indicado por selector.

``` xml title="unique.xsd" linenums="1"
<xs:unique name="idUnico">
  <xs:selector xpath="cliente"/>
  <xs:field xpath="@id"/>
</xs:unique>
```

### Claves

Se emplean para definir claves primarias y foráneas dentro del XML.

``` xml title="keys.xsd" linenums="1"
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="empresa">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="empleado" type="tipoEmpregado" maxOccurs="200"/>
        <xs:element name="departamento" type="tipoDepartamento" maxOccurs="8"/>
      </xs:sequence>
    </xs:complexType>
  
    <xs:key name="depUnico">
      <xs:selector xpath="departamento"/>
      <xs:field xpath="@codigo"/>
    </xs:key>
    <xs:keyref name="departamento" refer="depUnico">
      <xs:selector xpath="empleado"/>
      <xs:field xpath="departamento"/>
    </xs:keyref>
  </xs:element>

  <xs:complexType name="tipoEmpregado">
    <xs:sequence>
      <xs:element name="nombre" type="xs:string"/>
      <xs:element name="departamento" type="xs:string"/>
    </xs:sequence>
  </xs:complexType>

  <xs:complexType name="tipoDepartamento">
    <xs:sequence>
      <xs:element name="nombre" type="xs:string"/>
    </xs:sequence>
    <xs:attribute name="codigo" type="xs:string" use="required"/>
  </xs:complexType>
</xs:schema>
```

``` xml title="keys.xml" linenums="1"
<?xml version='1.0' encoding='UTF-8' ?>
<empresa xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:noNamespaceSchemaLocation="keys.xsd">
  <empleado>
      <nombre>Iria</nombre>
      <departamento>IFC</departamento>
  </empleado>
       <empleado>
      <nombre>Xoel</nombre>
      <departamento>CON</departamento>
  </empleado>
  <departamento codigo="IFC">
    <nombre>Informática</nombre>
  </departamento>
  <departamento codigo="CON">
    <nombre>Contabilidad</nombre>
  </departamento>
</empresa>
```

## Reutilización de esquemas

### Reutilización mediante includes

Mediante el elemento include dentro de un esquema podemos incluir todo lo definido en otro.

``` xml title="include.xsd" linenums="1"
<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:include schemaLocation="definicionesComunes.xsd"/>
  ...
</xs:schema>
```

### Redefiniciones

Mediante el elemento redefine podemos redefinir tipos complejos, simples, grupos o grupos de atributos definidos en un archivo externo.

``` xml title="redefine1.xsd" linenums="1"
<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:complexType name="nombreCompleto">
    <xs:sequence>
      <xs:element name="nombre" type="xs:string"/>
      <xs:element name="apellido1" type="xs:string"/>
    </xs:sequence>
  </xs:complexType>
</xs:schema>
```

``` xml title="redefine2.xsd" linenums="1"
<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:redefine schemaLocation="redefine1.xsd">
    <xs:complexType name="nombreCompleto">
      <xs:complexContent>
        <xs:extension base="nombreCompleto">
          <xs:sequence>
            <xs:element name="apellido2" type="xs:string"/>
          </xs:sequence>
        </xs:extension>
      </xs:complexContent>
    </xs:complexType>
  </xs:redefine>

  <xs:element name="persona">
    <xs:complexType>
      <xs:choice>
        <xs:element name="nombreC" type="nombreCompleto"/>
        <xs:element name="apodo" type="xs:string"/>
      </xs:choice>
    </xs:complexType>
  </xs:element>
</xs:schema>
```

## Ejercicios resueltos de examen

### Galicia 2021

Partindo do seguinte documento XML:
``` xml title="reservas.xml" linenums="1"
--8<-- "./data/marcas/xsd/reservas.xml"
```
Cree os elementos do XML Schema necesarios para realizar as seguintes tarefas:

* Defina o elemento reserva_habitación creando un grupo que se poida reutilizar para definir o
elemento reserva_salón. Defina tamén o grupo creado.

* Defina un tipo de dato chamado tipoIdCliente para reutilizar cos atributos cliente e id, tendo en conta que sempre seguen o mesmo formato: a letra C, un guión e o DNI (8 díxitos e unha letra maiúscula), por exemplo C_53454123X.

``` xml title="reservas.xsd" linenums="1"
--8<-- "./data/marcas/xsd/reservas.xsd"
```

### Galicia 2019

``` xml title="ordenadores.xml" linenums="1"
--8<-- "./data/marcas/xsd/ordenadores.xml"
```

Partiendo del documento XML anterior, crea los elementos del XML Schema necesarios para realizar las siguientes tareas:

1. Definir el elemento sistemaOperativo (el que es hijo de ordenadores). El atributo codigo contiene una cadena de caracteres.
2. Definir el elemento del XML Schema que permita comprobar que los ordenadores utilicen el software existente en el documento XML.
3. Definir el elemento sala creando un grupo que se pueda reutilizar para definir el elemento taller.
4. Definir el elemento numOrdenadores sabiendo que tiene que contener un número mayor que 20 y menor o igual que 40.
5. Definir el atributo numero del ordenador teniendo en cuenta que siempre sigue el mismo formato: comienza por 200.300. y a continuación tiene un número del 0 al 999.

``` xml title="ordenadores1.xsd" linenums="1"
--8<-- "./data/marcas/xsd/ordenadores1.xsd"
```