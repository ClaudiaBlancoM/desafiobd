-- 1. Cargar el respaldo de la base de datos unidad2.sql. (2 Puntos)
-- IMPORTANTE: Para cumplir los siguientes requerimientos, debes recordar tener desactivado el autocommit en tu base de datos.
\set AUTOCOMMIT off 
-- verificar el estado de los autocommit
\echo :AUTOCOMMIT 

--Se creó la base de datos
--claudia=# CREATE DATABASE bill;
-- CREATE DATABASE

-- Se cargó el archivo unidad2.sql
--psql -U claudia bill<unidad2.sql
-- SET
-- SET
-- SET
-- SET
-- SET
--  set_config 
-- ------------
-- (1 row)

-- 2. El cliente usuario01 ha realizado la siguiente compra:
-- ● producto: producto9.
-- ● cantidad: 5
-- ● fecha: fecha del sistema
-- Mediante el uso de transacciones, realiza las consultas correspondientes para este
-- requerimiento y luego consulta la tabla producto para validar si fue efectivamente
-- descontado en el stock. (3 Puntos)
--Se mostró la tabla producto

SELECT * FROM producto;

--  id | descripcion | stock | precio 
-- ----+-------------+-------+--------
--   3 | producto3   |     9 |   9449
--   4 | producto4   |     8 |    194
--   5 | producto5   |    10 |   3764
--   6 | producto6   |     6 |   8655
--   7 | producto7   |     4 |   2875
--  10 | producto10  |     1 |   3001
--  11 | producto11  |     9 |   7993
--  12 | producto12  |     3 |   8504
--  13 | producto13  |    10 |   2415
--  14 | producto14  |     5 |   3824
--  15 | producto15  |    10 |   7358
--  16 | producto16  |     7 |   3631
--  17 | producto17  |     3 |   4467
--  18 | producto18  |     2 |   9383
--  19 | producto19  |     6 |   1140
--  20 | producto20  |     4 |    102
--   9 | producto9   |     8 |   4219
--   1 | producto1   |     6 |   9107
--   2 | producto2   |     5 |   1760
--   8 | producto8   |     0 |   8923
-- (20 rows)  SE REALIZÓ LA TRANSACCIÓN

BEGIN TRANSACTION;
INSERT INTO compra (id, cliente_id, fecha)
VALUES (35, 1, current_date);
INSERT INTO detalle_compra (id, producto_id, compra_id, cantidad)
VALUES (43, 9, 35, 5);
UPDATE producto SET stock = stock - 5 WHERE id = 9; 
COMMIT;
SAVEPOINT primera_compra;
-- SELECT * FROM producto;
-- Al consultar la tabla producto y la tabla compra verificamos que fueron descontados los productos. Eran 8 inicialmente, ahora quedan 3

-- 3.- El cliente usuario02 ha realizado la siguiente compra:
-- ● producto: producto1, producto 2, producto8.
-- ● cantidad: 3 de cada producto.
-- ● fecha: fecha del sistema.
-- Mediante el uso de transacciones, realiza las consultas correspondientes para este
-- requerimiento y luego consulta la tabla producto para validar que si alguno de ellos
-- se queda sin stock, no se realiza la compra. 

-- se realiza la transacción al producto 1, además un savepoint para realizar un rollback en caso de que no haya stock
BEGIN TRANSACTION;
INSERT INTO compra (id, cliente_id, fecha)
VALUES (34, 2, current_date);

-- Producto N°1
INSERT INTO detalle_compra (id, producto_id, compra_id, cantidad)
VALUES (44, 1, 34, 3);
UPDATE producto SET stock = stock - 3 WHERE id = 1; 

-- Producto N°2
INSERT INTO detalle_compra (id, producto_id, compra_id, cantidad)
VALUES (45, 2, 34, 3);
UPDATE producto SET stock = stock - 3 WHERE id = 2;

-- Producto N°8
INSERT INTO detalle_compra (id, producto_id, compra_id, cantidad)
VALUES (46, 8, 34, 3);
UPDATE producto SET stock = stock - 3 WHERE id = 8; 
ROLLBACK TO primera_compra;
COMMIT;
-- Consultamos la tabla compra para validar que la transacción se haya ejecutado.
SELECT * FROM compra;
-- Consultamos la tabla producto para validar que se vendieron los productos 1 y 2; el producto 8 no se vendió, por no tener stock suficiente.
SELECT * FROM producto;