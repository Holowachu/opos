
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
    function __construct() {
        print "En el constructor\n";
    }

    function __destruct() {
        print "Destruyendo " . __CLASS__ . "\n";
    }
}

$obj = new MyDestructableClass();
```