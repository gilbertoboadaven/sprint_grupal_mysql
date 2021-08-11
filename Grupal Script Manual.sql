# Creacion de la basede datos TeLovendoSprint
CREATE SCHEMA IF NOT EXISTS `TeLoVendoSprint` DEFAULT CHARACTER SET utf8 ;

# Creacion del usuario que administrara la base de datos
CREATE USER IF NOT EXISTS 'TeLoVendoSprint'@'localhost' IDENTIFIED BY 'TeLoVendoSprint';

# Otorgamos todos los privilegios al usuario TeLoVendoSprint@localhost
GRANT ALL PRIVILEGES ON TeLoVendoSprint.* TO TeLoVendoSprint@localhost;
FLUSH PRIVILEGES;

# Seleccionamos la base de datos con la que vamos a trabajar
USE `TeLoVendoSprint` ;

# Creamos la tabla para los proveedores
CREATE TABLE IF NOT EXISTS `TeLoVendoSprint`.`Proveedores` (
  `id_proveedor` INT NOT NULL AUTO_INCREMENT,
  `nombre_corporativo` VARCHAR(45) NULL,
  `representante_legal` VARCHAR(45) NULL,
  `telefono` VARCHAR(15) NULL,
  `nombre_asistente` VARCHAR(45) NULL,
  `telefono_asistente` VARCHAR(15) NULL,
  `correo_electronico` VARCHAR(255) NULL,
  PRIMARY KEY (`id_proveedor`))
ENGINE = InnoDB;

# Creamos 5 proveedores
INSERT Proveedores (nombre_corporativo,representante_legal,telefono,nombre_asistente,telefono_asistente,correo_electronico)
VALUES	('Proveedor 1','Responsable 1','967895001','Asistente 1','967895001','proveedor1@email.com'),
		('Proveedor 2','Responsable 2','967895002','Asistente 2','967895002','proveedor2@email.com'),
		('Proveedor 3','Responsable 3','967895003','Asistente 3','967895003','proveedor3@email.com'),
		('Proveedor 4','Responsable 4','967895004','Asistente 4','967895004','proveedor4@email.com'),
		('Proveedor 5','Responsable 5','967895005','Asistente 5','967895005','proveedor5@email.com');

# Creamos la tabla clientes
CREATE TABLE IF NOT EXISTS `TeLoVendoSprint`.`Clientes` (
  `id_cliente` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `apellido` VARCHAR(45) NOT NULL,
  `direccion` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id_cliente`))
ENGINE = InnoDB;

# Creamos 5 clientes
INSERT INTO Clientes (nombre,apellido,direccion) 
VALUES 	('Nombre 1','Apellido 1','Direccion 1'),
		('Nombre 2','Apellido 2','Direccion 2'),
		('Nombre 3','Apellido 3','Direccion 3'),
		('Nombre 4','Apellido 4','Direccion 4'),
		('Nombre 5','Apellido 5','Direccion 5');


# Creamos la tabla productos
CREATE TABLE IF NOT EXISTS `TeLoVendoSprint`.`Productos` (
  `id_producto` INT NOT NULL AUTO_INCREMENT,
  `categoria` VARCHAR(45) NULL,
  `color` VARCHAR(45) NULL,
  `precio` FLOAT NULL,
  PRIMARY KEY (`id_producto`))
ENGINE = InnoDB;

# Creamos una tabla que relacione los productos y proveedores, y lleve el stock de los productos
# 
CREATE TABLE IF NOT EXISTS `TeLoVendoSprint`.`Productos_has_Proveedores` (
  `id_producto` INT NOT NULL,
  `id_proveedor` INT NOT NULL,
  `stock` VARCHAR(45) NULL,  
  INDEX `fk_Productos_has_Proveedores_Proveedores1_idx` (`id_proveedor` ASC) VISIBLE,
  INDEX `fk_Productos_has_Proveedores_Productos_idx` (`id_producto` ASC) VISIBLE,
  CONSTRAINT `fk_Productos_has_Proveedores_Productos`
    FOREIGN KEY (`id_producto`)
    REFERENCES `TeLoVendoSprint`.`Productos` (`id_producto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Productos_has_Proveedores_Proveedores1`
    FOREIGN KEY (`id_proveedor`)
    REFERENCES `TeLoVendoSprint`.`Proveedores` (`id_proveedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

# Creamos 5 productos
INSERT INTO Productos (categoria,color,precio)
VALUES 	('Categoria 1','Rojo',720),
		('Categoria 1','Azul',785),
		('Categoria 1','Rojo',752),
		('Categoria 2','Amarillo',785),
        ('Categoria 2','Rojo',452),
        ('Categoria 3','Azul',652),
        ('Categoria 3','Rojo',125),
        ('Categoria 4','Amarillo',789),
        ('Categoria 4','Blanco',156),
		('Categoria 4','Rojo',1523);
        
# Insertamos 10 pedidos
INSERT INTO Productos_has_Proveedores (id_producto, id_proveedor, stock)
VALUES (1,1,50),
		(2,1,75),
		(3,2,45),
        (4,2,90),
        (5,3,25),
        (6,3,80),
        (7,4,32),
        (8,4,76),
        (9,4,94),
        (10,5,18),
        (10,5,90);
        

 
        
# Cuál es la categoría de productos que más se repite.
SELECT categoria,count(*) AS cantidad 
FROM productos 
GROUP BY categoria 
ORDER BY cantidad DESC ;

# Cuáles son los productos con mayor stock
SELECT productos.id_producto,categoria,color,sum(stock) as total 
FROM productos 
JOIN productos_has_proveedores p 
ON productos.id_producto = p.id_producto 
GROUP BY productos.id_producto
ORDER BY total DESC;

# Qué color de producto es más común en nuestra tienda.
select color,count(color) 
from productos 
group by color;

# Cual o cuales son los proveedores con menor stock de productos.
SELECT nombre_corporativo,sum(proveedor.stock) AS stock_total 
FROM proveedores
JOIN productos_has_proveedores proveedor
ON proveedores.id_proveedor = proveedor.id_proveedor
GROUP BY proveedores.id_proveedor
ORDER BY stock_total ASC;

# Cambien la categoría de productos más popular por ‘Electrónica y computación’

SET sql_safe_updates = 0;

UPDATE Productos 
SET categoria = 'Electrónica y computación' 
WHERE categoria = (
	SELECT categoria 
    FROM (
		SELECT categoria,count(categoria) AS cantidad 
		FROM Productos 
        GROUP BY categoria 
        ORDER BY cantidad DESC 
        LIMIT 1
        ) as temporal
	);
    


