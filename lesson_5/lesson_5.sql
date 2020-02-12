-- Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение”
-- Задание 1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.

USE vk;
DESC users;

-- Заполнение полей created_at и updated_at текущей датой и временем

UPDATE users SET 
  created_at = Current_Timestamp,
  updated_at = Current_Timestamp
;

-- Визуальная проверка данных
SELECT * FROM users LIMIT 10;

-- Задание 2. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались 
-- значения в формате "20.10.2017 8:10". Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.

USE vk;
DESC users;

-- Тип данных в таблице верный изначально (скриншот Lesson_5_z1_p2)

-- Задание 3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, 
-- если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. 
-- Однако, нулевые запасы должны выводиться в конце, после всех записей.

USE shop;

-- Воспользовались сервисом filldb.info для заполнения таблицы

#
# TABLE STRUCTURE FOR: storehouses_products
#

DROP TABLE IF EXISTS `storehouses_products`;

CREATE TABLE `storehouses_products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `storehouse_id` int(10) unsigned DEFAULT NULL,
  `product_id` int(10) unsigned DEFAULT NULL,
  `value` int(10) unsigned DEFAULT NULL COMMENT 'Запас товарной позиции на складе',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Запасы на складе';

INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('1', 14, 7, 0, '1972-12-30 15:18:43', '2016-03-11 00:09:34');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('2', 8, 42, 0, '1985-05-11 01:55:42', '1987-06-15 15:08:53');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('3', 17, 15, 71, '1999-12-27 03:37:36', '1979-12-04 03:05:23');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('4', 7, 23, 50, '1981-01-29 21:13:29', '1979-10-13 09:30:56');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('5', 6, 5, 27, '2005-04-28 08:02:33', '1989-07-06 21:35:19');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('6', 19, 45, 64, '2010-08-12 01:47:07', '1996-03-26 05:37:45');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('7', 10, 27, 82, '2008-12-07 14:08:29', '1997-01-25 03:11:35');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('8', 17, 40, 56, '1972-10-05 09:02:39', '2004-06-26 16:40:28');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('9', 17, 4, 54, '2010-08-27 21:19:40', '1991-10-11 19:00:30');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('10', 9, 38, 15, '1978-02-14 13:08:52', '1971-04-21 02:11:56');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('11', 13, 30, 77, '2003-09-10 04:25:57', '1999-03-08 21:05:27');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('12', 16, 49, 68, '1992-02-27 02:02:08', '1979-07-22 23:26:41');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('13', 8, 16, 39, '2007-07-09 00:12:26', '2001-01-30 19:35:02');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('14', 16, 9, 64, '1988-06-13 21:26:01', '1971-06-10 08:53:41');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('15', 4, 8, 30, '1991-12-13 23:25:59', '1973-06-16 17:27:52');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('16', 11, 11, 85, '2013-03-17 02:42:31', '2007-01-15 12:44:25');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('17', 20, 17, 23, '1975-03-03 09:05:49', '2004-04-19 13:37:44');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('18', 11, 33, 49, '2012-12-11 13:58:01', '1970-08-23 07:29:40');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('19', 17, 37, 95, '1987-03-13 04:21:00', '1988-05-06 16:20:35');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('20', 18, 25, 0, '2005-09-04 13:15:56', '1971-10-30 14:12:33');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('21', 4, 43, 4, '1983-10-24 07:49:04', '2006-09-11 11:15:19');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('22', 1, 28, 26, '2014-02-05 19:26:33', '1971-02-12 06:48:18');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('23', 16, 44, 43, '2004-05-29 13:02:03', '1981-01-18 17:16:40');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('24', 10, 32, 9, '1998-09-18 16:14:13', '1996-04-30 22:02:55');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('25', 18, 50, 42, '1991-05-24 11:57:18', '1989-08-15 12:47:15');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('26', 14, 41, 3, '1989-07-08 23:17:56', '1983-04-16 21:53:56');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('27', 16, 36, 7, '1995-12-21 11:19:56', '2017-07-19 10:25:15');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('28', 4, 47, 61, '2000-10-06 05:25:58', '1977-10-30 03:52:28');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('29', 19, 29, 67, '1982-08-31 22:29:46', '2005-05-22 00:47:52');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('30', 18, 20, 25, '1994-11-06 13:09:37', '1993-04-11 20:41:25');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('31', 4, 13, 33, '2000-11-26 14:51:41', '2019-10-18 06:02:16');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('32', 17, 35, 76, '1985-10-15 19:36:29', '1980-12-05 10:27:15');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('33', 18, 19, 0, '1992-08-17 14:46:48', '2013-07-25 09:57:03');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('34', 9, 22, 46, '1996-01-02 20:02:47', '1986-04-03 11:43:04');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('35', 6, 14, 14, '1994-06-07 01:43:19', '2011-02-17 22:04:48');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('36', 10, 46, 72, '1996-08-30 12:44:17', '2004-09-27 08:26:21');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('37', 1, 6, 25, '2019-06-20 15:09:50', '1986-11-02 10:23:55');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('38', 8, 1, 90, '1980-01-08 09:57:39', '1985-10-21 03:01:09');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('39', 7, 48, 86, '1998-02-23 06:23:49', '1980-02-12 16:43:02');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('40', 4, 39, 20, '2012-03-05 19:45:49', '1989-09-16 04:20:01');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('41', 8, 12, 31, '2019-03-17 15:38:34', '2011-01-31 22:12:33');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('42', 12, 18, 19, '1982-02-24 11:15:13', '1974-09-09 15:27:09');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('43', 2, 3, 16, '2004-08-25 05:14:48', '1986-03-10 18:03:48');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('44', 4, 31, 9, '2006-01-26 12:02:58', '1981-05-07 06:11:26');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('45', 7, 10, 2, '2009-06-11 07:22:19', '2017-10-24 20:46:41');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('46', 11, 24, 55, '1978-06-02 07:34:31', '2006-06-23 14:36:31');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('47', 15, 34, 56, '1975-02-17 10:00:09', '1998-06-22 02:21:08');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('48', 19, 2, 24, '2013-12-09 23:41:05', '1970-02-25 19:25:23');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('49', 19, 21, 97, '2010-06-13 04:22:50', '1973-08-02 16:57:42');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('50', 17, 26, 76, '1985-01-16 08:16:07', '2001-03-07 22:22:08');

UPDATE storehouses_products SET 
  created_at = Current_Timestamp,
  updated_at = Current_Timestamp
;
SELECT * FROM storehouses_products;

-- Вывод данных в соответствии с заданием 

SELECT * FROM storehouses_products ORDER BY value = 0 ASC, value ASC;

-- Задание 4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий ('may', 'august')

USE shop;

SELECT DATE_FORMAT( SUBSTRING(birthday_at, 1, 10), '%M') AS mounth, COUNT(*)  AS coll FROM users 
WHERE 
  SUBSTRING(birthday_at, 6, 2) = '05' OR SUBSTRING(birthday_at, 6, 2) = '08'
GROUP BY id;

-- Задание 5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
-- Отсортируйте записи в порядке, заданном в списке IN.

USE shop;

-- Сортировка вывода данных в соответствии со списком IN 

SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY FIND_IN_SET(id ,'5, 1, 2') DESC;


-- Практическое задание теме “Агрегация данных”
-- Задание 1. Подсчитайте средний возраст пользователей в таблице users

USE shop;

-- Выведем возраст всех элементов таблицы users

SELECT
  name,
  TIMESTAMPDIFF(YEAR, birthday_at, NOW()) AS age
FROM
  users;

-- Выведем средний возраст всех элементов таблицы users

SELECT 
  ROUND(AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())), 2) AS average_age
FROM 
  users;
 
-- Задание 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
-- Следует учесть, что необходимы дни недели текущего года, а не года рождения.

USE shop;

-- Подсчет количества дней рождений в опредленный день недели

SELECT day_of_week, COUNT(day_of_week) AS n_of_bdays_on_diff_days
FROM
  (SELECT DAYOFWEEK(birthday) AS day_of_week, DAYNAME(birthday) AS day_of_week_name
  FROM 
    (
      SELECT REPLACE (birthday_at, SUBSTRING(birthday_at, 1, 4), '2020') AS birthday FROM users
    ) a
  ) b
GROUP BY day_of_week
ORDER BY day_of_week
;

-- Задание 3. Подсчитайте произведение чисел в столбце таблицы

USE shop;

-- Подсчет произведения значений id в таблице tbl,
-- проблема: работает для всех чисел строго больших 0, потому что используется логарифм по основанию 2

SELECT EXP(SUM(LN(id))) FROM tbl;





