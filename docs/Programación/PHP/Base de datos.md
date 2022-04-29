# Base de datos
## PDO
``` php
try {
$dsn = "mysql:host=localhost;dbname=$dbname";
$dbh = new PDO($dsn, $user, $password);
$dbh->setAttribute(PDO::ATTRR_ERRMODE, PDO::ERRMODE_EXCEPTION);
$stmt = $dbh->prepare("INSERT INTO Clientes (nombre, ciudad) VALUES (?, ?)");
$stmt = $dbh->prepare("INSERT INTO Clientes (nombre, ciudad) VALUES (:nombre, :ciudad)");
$stmt->bindParam(':nombre', $nombre); // ... Resto de Binds
$stmt->execute([':nombre'=> $nombre, ":ciudad)" => $ciudad])

while($row = $stmt->fetch(PDO::FETCH_OBJ)){
    // recuperar filas
}
//Array de objetos PDO::FETCH_OBJ otras opciones: PDO::FETCH_ASSOC, PDO::FETCH_CLASS FETCH_BOUND
$clientes = $stmt->fetchAll(PDO::FETCH_OBJ);

$stmt->setFetchMode(PDO::FETCH_CLASS, 'Clientes');
$clientes = $stmt->fetchAll(PDO::FETCH_CLASS, 'Clientes');


$stmt = $dbh->query("SELECT * FROM Clientes");
$clientes = $stmt->fetchAll(PDO::FETCH_OBJ);
//Otras funciones de utilidad
$dbh->exec("SELECT * FROM Clientes");
$dbh->lastInsertId();
// Transacciones
$dbh->beginTransaction();
$dbh->commit();
$dbh->rollback();

}catch (PDOException $e){
    echo $e->getMessage();
}
```

## MySQLi
```php
$db = new mysqli($server, $user, $password, $dbname);
// Comprobar conexión
if($db->connect_error){
    die("La conexión ha fallado, error número " . $db->connect_errno . ": " . $db->connect_error);
$stmt = $db->prepare("INSERT INTO Clientes (nombre, ciudad, contacto) VALUES (?, ?, ?)");
$stmt->bind_param('ssi', $nombre, $ciudad, $contacto);
//Aquí podemos modificar los valores de los parámetros
$stmt->execute();


    while ($stmt->fetch()) {
        printf("%s %s\n", $nombre, $ciudad);
    }

  $datos =  $stmt->fetchAll(); //parametros: MYSQLI_ASSOC, MYSQLI_NUM, o MYSQLI_BOTH.


$resultado = $db->query($consulta)
while ($fila = $resultado->fetch_assoc()) {
        printf ("%s (%s)\n", $fila["Name"], $fila["CountryCode"]);
}

//Tenemos que cerrar la conexión 
$stmt->close();
$db->close();
```