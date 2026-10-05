# Creación de la base de datos del proyecto
CREATE DATABASE AlkeWallet;
# Selección de la base de datos
USE AlkeWallet;

SHOW DATABASES;
# Creación de la tabla usuario
CREATE TABLE usuario (
	user_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo_electronico VARCHAR(150) NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    saldo DECIMAL(10,2) NOT NULL
);

SHOW TABLES;

DESCRIBE usuario;

# Creación de la tabla moneda
CREATE TABLE moneda (
	currency_id INT AUTO_INCREMENT PRIMARY KEY,
    currency_name VARCHAR(50) NOT NULL,
    currency_symbol VARCHAR(10) NOT NULL
);

# Creación de la tabla transaccion
CREATE TABLE transaccion (
	transaccion_id INT AUTO_INCREMENT PRIMARY KEY,
    sender_user_id INT NOT NULL,
    receiver_user_id INT NOT NULL,
    #Moneda utilizada en la transacción
    currency_id INT NOT NULL,
    #Monto transferido
    importe DECIMAL(10,2) NOT NULL,
    #Fecha y hora de la transacción
    transaction_date DATETIME NOT NULL,
    #Relaciones con las tablas correspondientes
    FOREIGN KEY (sender_user_id)
		REFERENCES usuario(user_id),
        
	FOREIGN KEY (receiver_user_id)
		REFERENCES usuario(user_id),
        
	FOREIGN KEY (currency_id)
		REFERENCES moneda(currency_id)
  
);

SHOW TABLES;
#Revisar estructura de la tabla transaccion
DESCRIBE transaccion;

DESCRIBE moneda;

#Insertando usuarios de prueba
USE AlkeWallet;
INSERT INTO usuario
(nombre, correo_electronico, contrasena, saldo)
VALUES
('Juan Valdez', 'juan@gmail.com','12345',500000),
('Maria Salome', 'maria@gmail.com', '54321', 350000),
('Carlos Pinto', 'cpinto@gmail.com', '987654',15000000);

SELECT * FROM usuario;

INSERT INTO moneda 
(currency_name, currency_symbol)
VALUES 
('Peso Chileno', ' $'),
('Dolar Estadounidense', 'USD'),
('Euro','EUR');

SELECT * FROM moneda;

INSERT INTO transaccion
(sender_user_id,
receiver_user_id,
currency_id,
importe,
transaction_date)
VALUES
(1,2,1,50000,NOW()),
(2,3,1,25000,NOW()),
(3,2,1,100,NOW());
SELECT * FROM transaccion;
SELECT * FROM usuario;

SELECT
t.transaccion_id,
u.nombre,
t.importe
FROM transaccion t
INNER JOIN usuario u
ON t.sender_user_id = u.user_id;

SELECT COUNT(*) AS total_usuarios
FROM usuario; 

SELECT SUM(importe) AS total_transferido
FROM transaccion; 

SELECT
sender_user_id,
COUNT(*) AS total_transacciones
FROM transaccion
GROUP BY sender_user_id;

SELECT nombre 
FROM usuario
WHERE user_id IN (
	SELECT sender_user_id
    FROM transaccion
);

CREATE VIEW top5_usuarios AS 
SELECT * 
FROM usuario
ORDER BY saldo DESC
LIMIT 5;

SELECT * FROM top5_usuarios;

UPDATE usuario
SET saldo = saldo - 500000
WHERE user_id = 1; 

SELECT * 
FROM usuario;

START TRANSACTION;
UPDATE usuario
SET saldo = saldo - 100000
WHERE user_id = 1;

UPDATE usuario
SET saldo = saldo + 10000
WHERE user_id = 2;

COMMIT;

START TRANSACTION;
UPDATE usuario
SET saldo = saldo - 200000
WHERE user_id = 1;

ROLLBACK;

SELECT * 
FROM usuario
WHERE user_id = 1; 

START TRANSACTION; 

UPDATE usuario
SET saldo = saldo - 999999999
WHERE user_id = 1;

ROLLBACK;

#indice para búsquedas por correo
CREATE INDEX idx_correo
ON usuario(correo_electronico);

#indice compuesto para optimizar transacciones
CREATE INDEX idx_transacccion_usuarios
ON transaccion(sender_user_id, receiver_user_id);

SHOW INDEX FROM usuario;
SHOW INDEX FROM transaccion; 

# Modificación de la tabla usuario agregando fecha de creación
ALTER TABLE usuario
ADD fecha_creacion DATETIME; 

DESCRIBE usuario;