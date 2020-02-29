-- Практическое задание по теме “Транзакции, переменные, представления”
-- Задание 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

-- открываем транзакцию
START TRANSACTION;

-- копируем запись из таблицы shop.users в таблицу sample.users
INSERT INTO sample.users (id, name, birthday_at, created_at, updated_at) 
  SELECT id, name, birthday_at, created_at, updated_at 
    FROM shop.users WHERE shop.users.id = 1;

-- удаляем запись из таблицы shop.users
DELETE FROM shop.users WHERE shop.users.id = 1;

-- подтверждаем изменения и закрываем транзакцию
COMMIT;

-- проверяем верно ли внеслись изменения в таблицы
SELECT * FROM shop.users;
SELECT * FROM sample.users;

-- Задание 2. Создайте представление, которое выводит название name товарной позиции из таблицы 
-- products и соответствующее название каталога name из таблицы catalogs.

USE shop;

-- удаляем представление, если оно уже существует
DROP VIEW IF EXISTS task2_lesson_9;

-- создаем представление
CREATE VIEW task2_lesson_9 AS 
  SELECT products.name AS pname, catalogs.name AS cname 
    FROM products
    JOIN catalogs 
      ON products.catalog_id = catalogs.id;
      
-- смотрим, что получилось
SELECT * FROM task2_lesson_9;

-- Практическое задание по теме “Хранимые процедуры и функции, триггеры"
-- Задание 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости 
-- от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
-- с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", 
-- с 00:00 до 6:00 — "Доброй ночи".

USE shop;
DROP PROCEDURE IF EXISTS shop.hello;

DELIMITER $$
$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `shop`.`hello`()
BEGIN
  CASE 
    WHEN HOUR(NOW()) BETWEEN 0 AND 6 THEN
      SELECT 'GOOD NIGHT';
    WHEN HOUR(NOW()) BETWEEN 6 AND 12 THEN
      SELECT 'GOOD MORNING';
    WHEN HOUR(NOW()) BETWEEN 12 AND 18 THEN
      SELECT 'GOOD DAY';
    WHEN HOUR(NOW()) BETWEEN 18 AND 24 THEN
      SELECT 'GOOD EVENING';
    ELSE
      SELECT 'ERROR' ;
  END CASE;
END$$
DELIMITER ;

-- Задание 2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
-- Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение 
-- NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.

-- Добавление триггера для операции INSERT
DROP TRIGGER IF EXISTS shop.check_products_name_and_description_insert;
USE shop;

DELIMITER $$
$$
CREATE DEFINER=`root`@`localhost` TRIGGER `check_products_name_and_description_insert` BEFORE INSERT ON `products` FOR EACH ROW 
BEGIN
	IF NEW.name IS NULL AND NEW.description IS NULL THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled';
    END IF;
END$$
DELIMITER ;

-- Добавление триггера для операции UPDATE
DROP TRIGGER IF EXISTS shop.check_products_name_and_description_update;
USE shop;

DELIMITER $$
$$
CREATE DEFINER=`root`@`localhost` TRIGGER `check_products_name_and_description_update` BEFORE UPDATE ON `products` FOR EACH ROW 
BEGIN
	IF NEW.name IS NULL AND NEW.description IS NULL THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UPDATE canceled';
    END IF;
END$$
DELIMITER ;

