# XPath

## Tipos de nodos

Un documento XML puede representarse como un árbol dirigido, considerando por ejemplo los elementos como nodos y que un elemento es padre de los elementos que contiene. Pero en XPath no sólo los elementos son nodos, en realidad hay siete tipos de nodos:

* Raíz
* Elemento
* Atributo
* Texto
* Comentario
* Instrucción de procesamiento
* Espacio de nombres
* Entidad
* Sección CDATA

``` xml
<?xml version="1.0" encoding="UTF-8"?>
<biblioteca>
  <libro>
    <titulo>La vida está en otra parte</titulo>
    <autor>Milan Kundera</autor>
    <fechaPublicacion año="1973"/>
  </libro>
  <libro>
    <titulo>Pantaleón y las visitadoras</titulo>
    <autor fechaNacimiento="28/03/1936">Mario Vargas Llosa</autor>
    <fechaPublicacion año="1973"/>
  </libro>
  <libro>
    <titulo>Conversación en la catedral</titulo>
    <autor fechaNacimiento="28/03/1936">Mario Vargas Llosa</autor>
    <fechaPublicacion año="1969"/>
  </libro>
</biblioteca>
```
![Árbol XML](grafos-documento.svg)

## Expresiones XPath

Una expresión XPath simple consta de 3 pasos de localización:

* Eje --> Indica con respecto al nodo contexto el conjunto de nodos sobre los cuales se evaluará el test de nodo.
* Test de nodo --> Sirve para, una vez identificado un conjunto de nodos con el eje adecuado, especificar exactamente que nodos de ese conjunto son los que queremos.
* Predicado --> Son condiciones que deben cumplir los nodos a seleccionar.

``` xslt
eje::test-nodo[predicado]
```

### Ejes

* **self** --> El propio nodo contexto.
* **child** --> Los hijos del nodo contexto.
* **parent** --> El padre del nodo contexto.
* **ancestor** --> Los antepasados del nodo contexto.
* **ancestor-or-self** --> El nodo contexto y sus antepasados.
* **descendant** --> Los descendientes del nodo contexto.
* **descendant-or-self** --> El nodo contexto y sus descendientes.
* **following** --> Los nodos siguientes al nodo contexto, sin descendientes.
* **following-sibling** --> Los nodos del mismo nivel que siguen al nodo contexto.
* **preceding** --> Los nodos anteriores al nodo contexto, sin antepasados.
* **preceding-sibling** --> Los nodos del mismo nivel que preceden al nodo contexto.
* **attribute** --> Los nodos atributo del nodo contexto.
* **namespace** --> Los nodos de espacio de nombres del nodo contexto.

Si no se indica un eje explícitamente, este toma el valor de "child".

``` xslt
<!-- Sentencias equivalentes -->
/venta/cliente/@cod
/child::venta/child::cliente/attribute::cod
```

#### Ejemplos de utilidad de los ejes:
```xml
<document id="1">
  <content>
    <html>
      <head>
      </head>
      <body>
        <div id="outer">
          <div id="inner">
            <ul>
              <li><a href="http://www.google.de/">Google</a>
                <ul>
                  <li><a href="http://earth.google.de/">Google Earth</a></li>
                  <li><a href="http://picasa.google.de/intl/de/">Picasa</a></li>
                </ul>
              </li> 
              <li><a href="http://www.heise.de/">Heise</a></li> 
              <li><a href="http://www.yahoo.de/">Yahoo</a></li> 
            </ul>
          </div>
        </div>
      </body>
    </html>
  </content>
</document>
```

```xslt
<!-- Coger el atributo id del elemento div antecesor más cercano al enlace a Google Earth -->
//a[contains(@href, "earth.google.")]/ancestor::div[1]/@id
```

```xml
<artist name="Robbie Williams">
  <cd name="Rudebox"> 
    <title>Rudebox</title>
    <title>Viva Life On Mars</title>
    <title>Lovelight (Lewis Taylor Cover)</title>
    <title>King Of The Bongo (Manu Chao Cover)</title>
    <title>Swing when you're winning</title>
    <title>Good Doctor</title>
  </cd> 
</artist>
```

```xslt
<!-- Calcular la posición del tema de Manu Chao dentro del cd -->
//title[contains(./text(), "Manu Chao")]/count(preceding-sibling::title) + 1
```

### Tests de nodo

Los test de nodo pueden ser:

* nombre_de_un_nodo --> Selecciona todos los nodos con el nombre indicado. 
* \* --> Selecciona todos los elementos y atributos.
* node() --> Selecciona todos los nodos (de cualquier tipo).
* text() --> Selecciona los nodos de texto.
* comment() --> Selecciona los nodos de comentario.
* processing-instructions() --> Selecciona los nodos de procesamiento de instrucciones.


```xslt
<!-- Expresiones equivalentes para obtener todos los atributos del documento -->
/descendant-or-self::node()/@*
//@*
```

Debido a su frecuente uso, existen abreviaturas para algunas rutas de localización:

* "//" equivale a "descendant-or-self::node()"
```xslt
<!-- Selecciona los elementos "autor" descendientes de biblioteca hijo del raíz -->
/biblioteca//autor
```

* ".." equivale la "parent::node()"
```xslt
<!-- Selecciona los elementos con un atributo "fechaNacimiento" -->
//@fechaNacimiento/..
```

* "." equivale la "self::node()"

Además existe la posibilidad de combinar los conjuntos de nodos devueltos por varias expresiones complejas haciendo uso de **|**
```xslt
<!-- Selecciona los elementos "autor" y "titulo" del documento -->
//autor|//titulo
```

### Predicados

El predicado es opcional, y se escribe entre corchetes, a continuación del test de nodo. Si el eje y el test de nodo han seleccionado unos nodos, el predicado permite restringir esa selección a los que cumplan determinadas condiciones.

* [@atributo] --> Selecciona los elementos que tienen el atributo.
```xslt
<!-- Selecciona los elementos "autor" con un atributo "fechaNacimiento" -->
//autor[@fechaNacimiento]
```

* [número] --> Si hay varios resultados selecciona uno de ellos por número de orden; el primero es el número 1 y **last()** selecciona el último de ellos.
```xslt
<!-- Selecciona el primer libro del documento -->
//libro[1]

<!-- Selecciona el último libro del documento -->
//libro[last()]

<!-- Selecciona el penúltimo libro del documento -->
//libro[last()-1]
```

* [condicion] --> Selecciona los nodos que cumplen la condición.
En las condiciones se pueden utilizar los operadores siguientes:

	* operadores lógicos: and, or, not()
	* operadores aritméticos: +, -, *, div, mod
	* operadores de comparación: =, !=, <, >, <=, >=
```xslt
<!-- Selecciona los elementos "fechaPublicacion" cuyo atributo "año"
 tenga un valor mayor a 1970 -->
//fechaPublicacion[@año>1970]

<!-- Selecciona los elementos "libro" cuyo elemento hijo "autor" 
tenga por valor mayor "Mario Vargas Llosa" -->
//libro[autor="Mario Vargas Llosa"]

<!-- Selecciona los atributos "año" cuyo valor sea superior a 1970 -->
//@año[.>1970]

<!-- Selecciona los atributos "libro" de "Mario Vargas Llosa"
con año de publicación 1973 -->
//libro[autor="Mario Vargas Llosa" and fechaPublicacion/@año="1973"]
```

## Funciones

* **not()** --> Devuelve verdadero si el valor del operando es falso, verdadero en caso contrario.
```xslt
<!-- Selecciona los elementos "autor" sin atributo "fechaDefuncion" -->
//autor[not(@fechaDefuncion)]
```

* **ceiling()** --> Devuelve el primero entero mayor que el valor del parámetro.
```xslt
<!-- Devuelve 2 -->
ceiling(3 div 2)
```

* **floor()** --> Devuelve el primero entero menor que el valor del parámetro.
```xslt
<!-- Devuelve 1 -->
floor(3 div 2)
```

* **round()** --> Devuelve el entero más próximo al valor del parámetro.
```xslt
<!-- Devuelve 2 -->
round(3 div 2)
```

* **sum()** --> Devuelve la suma de los valores de los nodos que se pasan como parámetros.
```xslt
<!-- Devuelve la suma del importe de todos los productos del XML -->
sum(//producto/@importe)
```

* **concat()** --> Concatena en una cadena todas las que se le pasan como parámetros.
```xslt
concat("Don ", //autor/text())
```

* **contains()** --> Devuelve verdadero si la primera cadena contiene a la segunda, falso en caso contrario.
```xslt
contains(//nombre/ text(),"Uxío")
```

* **starts-with()** --> Devuelve verdadero si la primera cadena comienza con la segunda, falso en caso contrario.
```xslt
starts-with(//nombre/ text(),"V")
```

* **string-length()** --> Devuelve el número de carácteres de la cadena.
```xslt
<!-- En Xpath 1.0 -->
string-length(//nombre/text())

<!-- En Xpath 3.1 -->
//nombre/string-length(text())
```

* **substring()** --> De la cadena que recibe como primero parámetro, devuelve tantos carácteres como indique el tercero parámetro, contando a partir de la posición que indique el segundo parámetro.
```xslt
<!-- Devuelve los 2 primeros caracteres del nombre -->

<!-- En Xpath 1.0 -->
substring(//nome/text(), 1, 2)

<!-- En Xpath 3.1 -->
//nome/substring(text(), 1, 2)
```

* **translate()** --> Devuelve la cadena del primer parámetro, sustituyendo todas las ocurrencias de los carácteres del segundo parámetro por los carácteres del tercero parámetro.
```xslt
<!-- En Xpath 1.0 -->
translate(//dirección/text(),",","-")

<!-- En Xpath 3.1 -->
//dirección/translate(.,",","-")
```

* **count()** --> Devuelve el número de nodos del conjunto de nodos.
```xslt
count(//producto)
```

* **name()** --> Devuelve el nombre calificado del primer nodo en el conjunto de nodos que se le pasa como parámetro.
```xslt
<!-- En Xpath 1.0 solo se aplica al primer nodo del set -->
name(//nombre)

<!-- En Xpath 3.1 se puede aplicar a todos los nodos del set -->
//nombre/name()
```

* **position()** --> Devuelve la posición (comenzando con 1) del nodo contexto en el conjunto de nodos del contexto actual.
```xslt
<!-- Selecciona los 3 primeros autores -->
//autor[position() <= 3]
```

## Ejercicios de exámen resueltos

### Galicia 2021

Partindo do seguinte documento XML:
``` xml title="reservas.xml" linenums="1"
--8<-- "./data/marcas/xsd/reservas.xml"
```
Empregue expresións XPath para obter os seguintes datos:

* O nome dos clientes que reservaron algunha habitación para entrar en Agosto.
```xslt
//cliente[@id=//reserva_habitación[fechaEntrada/@mes="Agosto"]/@cliente]/nombre/text()
```

```xslt
#otras soluciones
# Recuperando datos del padre
//cliente[(@id=//reserva_habitación/fechaEntrada[@mes="Agosto")]/../@cliente]/nombre/text()
# Clientes con una reserva cualquiera (habitación / salón):
//cliente[@id=//*[starts-with(name(), 'reserva')][fechaEntrada/@mes="Agosto"]/@cliente]/nombre/text()

```

* O identificador (id) dos clientes que teñan un nome que empece por F.
```xslt
//cliente[starts-with(nombre,"F")]/@id
```
```xslt
#otras posibles soluciones:
//cliente[starts-with(nombre/text(),"F")]/@id
//cliente/nombre[starts-with(text(),"F")]/../@id
```