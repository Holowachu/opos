TENEMOS QUE CAMBIAR ESTE INDEX
# SQL
``` sql title="Cacharra" linenums="1"
DELIMITER $$
DROP function if EXISTS sizeCiudad $$
create function if not EXISTS sizeCiudad(id int) returns char(50)
BEGIN
   declare pob int;
   declare tam char(50);
   
   select CiudadPoblacion INTO pob from Ciudad where CiudadId = id;
   set tam = case pob 
      when  pob < 100000 THEN 'pueblo'
      when  pob > 1000000  THEN  'gran ciudad'
      ELSE 'ciudad'
   END;
   return tam;
END$$
DELIMITER ;

select sizeCiudad(665);
```
![Screenshot](../data/Captura.png)
