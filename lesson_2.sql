-- �������� ���� ������ example 
CREATE DATABASE example;
USE example;

-- �������� ������� users � ���� ������ example
CREATE TABLE if not exists users (
	id SERIAL,
	name VARCHAR(255) NOT NULL
);

-- �������� ����� ���� ������ example
mysqldump example > example.sql

CREATE DATABASE sample;

-- �������� ����� � ����� ���� ������ sample
mysql sample < example.sql

USE sample;
SHOW TABLES;

-- ������� 4

mysqldump mysql help_keyword --where='TRUE LIMIT 100' > help_keyword_100.sql


