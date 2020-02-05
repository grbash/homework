-- создание базы данных example 
CREATE DATABASE example;
USE example;

-- создание таблицы users в базе данных example
CREATE TABLE if not exists users (
	id SERIAL,
	name VARCHAR(255) NOT NULL
);

-- создание дампа базы данных example
mysqldump example > example.sql

CREATE DATABASE sample;

-- загрузка дампа в новую базу данных sample
mysql sample < example.sql

USE sample;
SHOW TABLES;

-- «адание 4

mysqldump mysql help_keyword --where='TRUE LIMIT 100' > help_keyword_100.sql


