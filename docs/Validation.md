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

##Declaración de elementos

``` dtd title="element.dtd" linenums="1"
<!ELEMENT nombreElemento (tipoDeContido)>
```
###Tipos de contenido más usados:
* EMPTY - Elementos vacíos.
```dtd title="empty.dtd" linenums="1"
<!ELEMENT br EMPTY>
```
``` xml title="empty.xml" linenums="1"
<br />
```
* (#PCDATA) - Elementos con texto.
```dtd title="pcdata.dtd" linenums="1"
<!ELEMENT nombre (#PCDATA)>
```
``` xml title="pcdata.xml" linenums="1"
<nombre>Juan Carlos</nombre>
```
* (subElemento1, subElemento2, subElemento3, ...) - Secuencia de subelementos.
* (subElemento1 | subElemento2 | subElemento3 | ...) - Elección de entre varios subelementos.
* (#PCDATA | subElemento1 | subElemento2 | ...)* - Mezcla de texto con subelementos.
```dtd title="mixed.dtd" linenums="1"
<!ELEMENT parte (#PCDATA | padre | hijo | fecha)*>
```
``` xml title="mixed.xml" linenums="1"
<parte>
  Estimado Sr. <padre>Elver Galarga</padre>. Le comunico que su hijo <hijo>Jonathan Montoya</hijo>
  ha sido apercibido con un parte por mala conducta en clase con fecha <fecha>20/02/2021</fecha>.
</parte>
```
* (subElemento1, subElemento2, (subElemento3 | subElemento4)) - Combinaciones de secuencias y elecciones.

###Indicadores de ocurrencia

Pueden acompañar a un elemento o a un conjunto de estos (como en el caso de las mezclas).
- \* - Cero o más veces.
-  \+ - Una o más veces.
-  ? - Cero o una vez.

##Declaración de atributos
``` dtd title="attribute.dtd" linenums="1"
<!ATTLIST nombreDelElemento nombreDelAtributo tipoDeAtributo valorDelAtributo>
```
###Tipos de atributos más frecuentes:
* CDATA - Texto.
* (en1|en2|en3|...) - Elección de un valor entre una lista enumerada.
* ID - Identificador único en el XML.
* IDREF - Referencia a un ID existente en el XML.
* IDREFS - Varios IDREF separados por espacios.
* NMTOKEN - Texto sin espacios formado por letras, números y los caracteres **.**, **-** y **_**  (para fechas, valores numéricos...).
* NMTOKENS - Varios NMTOKEN separados por espacios.
* NOTATION - Notación previamente definida (habitualmente se usa para definir formatos de datos no XML como entidades no parseadas). Pueden ser privadas (SYSTEM) o públicas (PUBLIC).
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
* ENTITY - Entidades no parseadas (no son datos XML, p.ej. Imágenes). Deben ir vinculadas a una notación definida con NDATA.
* ENTITIES - Varias ENTITY separadas por espacios.

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

###Modificadores de presencia/valor:
* "Valor por defecto" - Atributo con valor por defecto.
```dtd title="defaultAtt.dtd" linenums="1"
<!ELEMENT square EMPTY>
<!ATTLIST square width CDATA "0">
```
``` xml title="defaultAtt.xml" linenums="1"
<square width="100" />
```
* \#REQUIRED - Atributo obligatorio.
```dtd title="requiredtAtt.dtd" linenums="1"
<!ATTLIST person number CDATA #REQUIRED>
```
``` xml title="requiredAtt.xml" linenums="1"
<person number="5677" />
```
* \#IMPLIED - Atributo opcional.
```dtd title="impliedtAtt.dtd" linenums="1"
<!ATTLIST contact fax CDATA #IMPLIED>
```
``` xml title="impliedAtt.xml" linenums="1"
<contact />
```

* \#FIXED "Valor fijo" - Atributo con valor fijo.
```dtd title="fixedtAtt.dtd" linenums="1"
<!ATTLIST sender company CDATA #FIXED "Microsoft">
```
``` xml title="fixedAtt.xml" linenums="1"
<sender company="Microsoft" />
```

* (en1|en2|en3|...) "en1" - Atributo enumerado con valor por defecto.
```dtd title="enumAtt.dtd" linenums="1"
<!ATTLIST payment type (check|cash) "cash">
```
``` xml title="enumAtt.xml" linenums="1"
<payment type="check" />
```

##Declaración de entidades