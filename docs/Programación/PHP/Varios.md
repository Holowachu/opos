
# Seguridad

## Password hash
```php
<?php
//string password_hash ( string $password , integer $algoritmo [, array $options ] )
$hash = password_hash('micontraseña', PASSWORD_DEFAULT, [15]);
password_verify($password, $hash)
```
## Subir Ficheros
``` php
<form enctype="multipart/form-data" action="upload.php" method="POST">
    <input type="hidden" name="MAX_FILE_SIZE" value="100000" />
    Elige el archivo a subir: <br>
    <input name="uploadedfile" type="file" /><br />
    <input type="submit" value="Subir archivo" />
</form>
<?php
$target_path  =  "uploads/";
$target_path  =  $target_path  .  basename($_FILES['uploadedfile']['name']);
if (move_uploaded_file($_FILES['uploadedfile']['tmp_name'], $target_path)) {
    echo "El archivo " . basename($_FILES['uploadedfile']['name']) . " se ha subido con éxito";
} else {
    echo "Hubo un error subiendo el archivo, por favor inténtalo de nuevo!";
}
?>
```
```php
<?php
$_FILES['uploadedfile']['name'] // Nombre original del archivo en el ordenador del usuario
$_FILES['uploadedfile']['type'] // El MIME type del archivo
$_FILES['uploadedfile']['size'] //El tamaño del archivo en bytes
$_FILES['uploadedfile']['tmp_name'] //El archivo temporal guardado de archivo subido
```
## Cargar clases forma dinámica
```php
<?php
//spl_autoload_register(callable $autoload_function = ?, bool $throw = true, bool $prepend = false): bool
spl_autoload_register(function ($nombre_clase) {
    include 'clases/'.$nombre_clase . '.php';
});
```

## Objetos Contructores y destructores 
```php
<?php
class MyDestructableClass
{
    static function test(){print ("test");}
     private function textoSaludo(string $nombre, string $apellidos): string {   return 'HOLA ' . $nombre . " ".$apellidos; }
    function __construct() {
        print "En el constructor\n";
        //self: hace referencia a la clase actual.
        //this: hace referencia al objeto actual.
        self::test();
        echo $this->textoSaludo("Pepe");
        $this->secretos("no contar","no leer");
        $this->textoSaludo(...["Pepe","gotera"]);
    }

    function __destruct() {
        print "Destruyendo " . __CLASS__ . "\n";
    }


    private function secretos(...$Secretos) {
       var_dump($secretos); // array con parametros
    }
}

$obj = new MyDestructableClass();
```

## Sesiones
```php
<?php
if (session_status() === PHP_SESSION_ACTIVE) {} ;
session_start();
session_unset();
session_destroy();
$_SESSION[];
```
## Cookies
``` php
<?php 
setcookie(string $name,
    string $value = "",
    int $expires = 0,
    string $path = "",
    string $domain = "",
    bool $secure = false,
    bool $httponly = false
): bool
setcookie("TestCookie", $value, time()+3600);  /* expira en 1 hora */
setcookie("TestCookie", $value, time()-60); /* Solicitar borrar cookie*/
setcookie("TestCookie", $value, time()+3600, "/~rasmus/", "example.com", 1);
$_COOKIE["TestCookie"]
```

## Header
```php
<?php
header('Location: http://www.example.com/');
// 301 Moved Permanently
header("Location: /foo.php",TRUE,301);
//--------
header("HTTP/1.0 404 Not Found");
exit;
header('Content-Type: application/pdf');
header('Content-Disposition: attachment; filename="downloaded.pdf"');
// La fuente de PDF se encuentra en original.pdf
readfile('original.pdf');
?>
```

## Ficheros
```php
<?php
$líneas = file('http://www.example.com/'); //array con las lineas del fichero
$página_inicio = file_get_contents('http://www.example.com/'); //contenido completo del fichero en una variable


$handle = fopen("/home/rasmus/fichero.txt", "r");
//'r''r+''w''w+''a''a+''x''x+''c''c+''e'
fwrite($handle, "contenido"); 
fseek($handle, 0); 
fclose($handle);
```

## Expresiones regulares

Metacaracteres fuera de los corchetes:
Metacarácter	Descripción
\	escape
^	inicio de string o línea
$	final de string o línea
.	coincide con cualquier carácter excepto nueva línea
[	inicio de la definición de clase carácter
]	fin de la definición de clase carácter
|	inicio de la rama alternativa
(	inicio de subpatrón
)	fin de subpatrón
?	amplía el significado del subpatrón, cuantificador 0 ó 1, y hace lazy los cuantificadores greedy
*	cuantificador 0 o más
+	cuantificador 1 o más
{	inicio de cuantificador mín/máx
}	fin de cuantificador mín/máx
Metacaracteres dentro de los corchetes:
Metacarácter	Descripción
\	carácter de escape general
^	niega la clase, pero sólo si es el primer carácter
-	indica el rango de caracteres

Secuencia	Coincidencia	Equivalencia
\d	Cualquier carácter numérico	[0-9]
\D	Cualquier carácter no numérico	[^0-9]
\s	Cualquier espacio	[\t\n\r\f\v]
\S	Cualquiera que no sea espacio	[^ \t\n\r\f\v]
\w	Cualquier carácter alfanumérico	[a-zA-Z0-9_]
\W	Cualquier carácter no alfanumérico	[^a-zA-Z0-9_]


Modificador	Significado
i	Insensible a mayúsculas y minúsculas
m	Múltiples líneas
x	Se pueden añadir comentarios
u	Strings de patrones y objetivos son tratados como UTF-8

```php
<?php
if(preg_match("/^calle/i", $direccion)) { //i	Insensible a mayúsculas y minúsculas

}
```