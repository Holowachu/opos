#DTD

##Vinculación con DTD
###DTD interno

``` xml title="note.xml" linenums="1"
<?xml version="1.0" standalone="yes"?>
<!DOCTYPE note [
<!ELEMENT note (to,from,heading,body)>
<!ELEMENT to (#PCDATA)>
<!ELEMENT from (#PCDATA)>
<!ELEMENT heading (#PCDATA)>
<!ELEMENT body (#PCDATA)>
]>
<note>
<to>Tove</to>
<from>Jani</from>
<heading>Reminder</heading>
<body>Don't forget me this weekend</body>
</note>
```

###DTD externo

XML:
``` xml title="note.xml" linenums="1"
<?xml version="1.0" standalone="no"?>
<!DOCTYPE note SYSTEM "note.dtd">
<note>
  <to>Tove</to>
  <from>Jani</from>
  <heading>Reminder</heading>
  <body>Don't forget me this weekend!</body>
</note>
```
``` dtd title="note.dtd" linenums="1"
<!ELEMENT note (to,from,heading,body)>
<!ELEMENT to (#PCDATA)>
<!ELEMENT from (#PCDATA)>
<!ELEMENT heading (#PCDATA)>
<!ELEMENT body (#PCDATA)>
```

##Declaración de entidades

###Entidades internas
Son básicamente constantes.
```dtd title="intEntity.dtd" linenums="1"
<!ENTITY ciudad "Santiago de Compostela">
```
``` xml title="intEntity.xml" linenums="1"
<direccion>
    <calle>Ponzano</calle>
    <numero>66</numero>
    <poblacion>&ciudad;</poblacion>
    <cp>15891</cp>
</direccion>
```

###Entidades externas
Vinculan otros documentos externos a nuestro XML.

####Externas parseadas
El documento externo **debe contener XML válido**.
```dtd title="extParsedEntity.dtd" linenums="1"
<!ENTITY capitulo1 SYSTEM "capitulo1.xml">
```
``` xml title="extParsedEntity.xml" linenums="1"
<entidadelibro>
   <tema>Ejemplo de entidad externa</tema>
   &capitulo1;
</entidadelibro>
```
``` xml title="capitulo1.xml" linenums="1"
<?xml version="1.0" encoding="UTF-8"?>
<capitulo>
     <para>Este es el primero capitulo</para>
</capitulo>
```

####Externas no parseadas
El documento externo **no es XML**.
```dtd title="extNoParsedEntity.dtd" linenums="1"
<!ELEMENT fruta EMPTY>
<!ATTLIST fruta foto ENTITY #REQUIRED>

<!NOTATION gif SYSTEM "image/gif">

<!ENTITY manzana SYSTEM "manzana.gif" NDATA gif>
```
``` xml title="extNoParsedEntity.xml" linenums="1"
<fruta foto="manzana"/>
```

##Declaración de elementos

``` dtd title="element.dtd" linenums="1"
<!ELEMENT nombreElemento (tipoDeContido)>
```
###Tipos de contenido más usados:
* **EMPTY** - Elementos vacíos.
```dtd title="empty.dtd" linenums="1"
<!ELEMENT br EMPTY>
```
``` xml title="empty.xml" linenums="1"
<br />
```
* **(#PCDATA)** - Elementos con texto.
```dtd title="pcdata.dtd" linenums="1"
<!ELEMENT nombre (#PCDATA)>
```
``` xml title="pcdata.xml" linenums="1"
<nombre>Juan Carlos</nombre>
```
* **(subElemento1, subElemento2, subElemento3, ...)** - Secuencia de subelementos.
* **(subElemento1 | subElemento2 | subElemento3 | ...)** - Elección de entre varios subelementos.
* **(#PCDATA | subElemento1 | subElemento2 | ...)\*** - Mezcla de texto con subelementos.
```dtd title="mixed.dtd" linenums="1"
<!ELEMENT parte (#PCDATA | padre | hijo | fecha)*>
```
``` xml title="mixed.xml" linenums="1"
<parte>
  Estimado Sr. <padre>Elver Galarga</padre>. Le comunico que su hijo <hijo>Jonathan Montoya</hijo>
  ha sido apercibido con un parte por mala conducta en clase con fecha <fecha>20/02/2021</fecha>.
</parte>
```
* **(subElemento1, subElemento2, (subElemento3 | subElemento4))** - Combinaciones de secuencias y elecciones.

###Indicadores de ocurrencia

Pueden acompañar a un elemento o a un conjunto de estos (como en el caso de las mezclas):
* **\*** - Cero o más veces.
* **\+** - Una o más veces.
* **?** - Cero o una vez.

##Declaración de atributos
``` dtd title="attribute.dtd" linenums="1"
<!ATTLIST nombreDelElemento nombreDelAtributo tipoDeAtributo valorDelAtributo>
```
###Tipos de atributos más frecuentes:
* **CDATA** - Texto.
* **(en1|en2|en3|...)** - Elección de un valor entre una lista enumerada.
* **ID** - Identificador único en el XML.
* **IDREF** - Referencia a un ID existente en el XML.
* **IDREFS** - Varios IDREF separados por espacios.
* **NMTOKEN** - Texto sin espacios formado por letras, números y los caracteres **.**, **-** y **_**  (para fechas, valores numéricos...).
* **NMTOKENS** - Varios NMTOKEN separados por espacios.
* **NOTATION** - Notación previamente definida (habitualmente se usa para definir formatos de datos no XML como entidades no parseadas). Pueden ser privadas (SYSTEM) o públicas (PUBLIC).
```dtd title="notationAtt.dtd" linenums="1"
<!ELEMENT documentos (documento)*>
<!ELEMENT documento (#PCDATA)>
<!ATTLIST documento version NOTATION (h4|h5) #REQUIRED>

<!NOTATION h5 PUBLIC "HTML 5">
<!NOTATION h4 PUBLIC "HTML 4.01">
```
``` xml title="notationAtt.xml" linenums="1"
<documentos>
   <documento version="h4"><!-- Código del documento 1. --></documento>
   <documento version="h5"><!-- Código del documento 2. --></documento>
   <documento version="h5"><!-- Código del documento 3. --></documento>
   <documento version="h4"><!-- Código del documento 4. --></documento>
</documentos>
```
* **ENTITY** - Entidades no parseadas (no son datos XML, p.ej. Imágenes). Deben ir vinculadas a una notación definida con NDATA.

```dtd title="entityAtt.dtd" linenums="1"
<!ELEMENT frutas (fruta)*>
<!ELEMENT fruta EMPTY>
<!ATTLIST fruta foto ENTITY #REQUIRED>

<!NOTATION gif SYSTEM "image/gif">

<!ENTITY manzana SYSTEM "manzana.gif" NDATA gif>
<!ENTITY naranja SYSTEM "naranja.gif" NDATA gif>
```
``` xml title="entityAtt.xml" linenums="1"
<frutas>
   <fruta foto="manzana"/>
   <fruta foto="naranja"/>
</frutas>
```
* **ENTITIES** - Varias ENTITY separadas por espacios.

###Modificadores de presencia/valor:
* **"Valor por defecto"** - Atributo con valor por defecto.
```dtd title="defaultAtt.dtd" linenums="1"
<!ELEMENT square EMPTY>
<!ATTLIST square width CDATA "0">
```
``` xml title="defaultAtt.xml" linenums="1"
<square width="100" />
```
* **\#REQUIRED** - Atributo obligatorio.
```dtd title="requiredtAtt.dtd" linenums="1"
<!ATTLIST person number CDATA #REQUIRED>
```
``` xml title="requiredAtt.xml" linenums="1"
<person number="5677" />
```
* **\#IMPLIED** - Atributo opcional.
```dtd title="impliedtAtt.dtd" linenums="1"
<!ATTLIST contact fax CDATA #IMPLIED>
```
``` xml title="impliedAtt.xml" linenums="1"
<contact />
```

* **\#FIXED "Valor fijo"** - Atributo con valor fijo.
```dtd title="fixedtAtt.dtd" linenums="1"
<!ATTLIST sender company CDATA #FIXED "Microsoft">
```
``` xml title="fixedAtt.xml" linenums="1"
<sender company="Microsoft" />
```

##Ejercicios resueltos de examen
```
--8<--​ ".informacion.xml"
```


Partiendo del documento XML anterior, crea un DTD que lo valide teniendo en cuenta lo siguiente:
* Siempre existirán elementos software y modulo.
* El elemento informacion tendrá un atributo llamado curso que siempre tendrá el valor 1.
* El codigo será único y el tipo podrá tomar los valores gratuito o comercial.
* La fecha de publicación tendrá por defecto el año 2015 y siempre indicará el mes.
* Debemos validar que los módulos usen el software existente en el documento XML.

```dtd title="informacionG.dtd"
--8<--​ "../data/marcas/dtd/informacionG.dtd"
```
