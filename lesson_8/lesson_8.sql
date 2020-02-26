-- Задание 1. Добавить необходимые внешние ключи для всех таблиц базы данных vk (приложить команды).

USE vk;

-- Смотрим список таблиц БД

SHOW tables;

-- Добавляем внешние ключи

DESC communities;

-- внешних ключей для данной таблицы не требуется, все данные уникальны

DESC communities_users;

ALTER TABLE communities_users 
  ADD CONSTRAINT communities_users_community_id_fk 
    FOREIGN KEY (community_id) REFERENCES communities(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT communities_users_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE;

DESC friendship;


ALTER TABLE friendship 
  ADD CONSTRAINT friendship_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT friendship_friend_id_fk
    FOREIGN KEY (friend_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT friendship_status_id_fk
    FOREIGN KEY (status_id) REFERENCES friendship_statuses(id)
      ON DELETE CASCADE;
      
DESC friendship_statuses;

-- внешних ключей для данной таблицы не требуется, все данные уникальны

DESC likes;

ALTER TABLE likes
  ADD CONSTRAINT likes_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT likes_target_type_id_fk
    FOREIGN KEY (target_type_id) REFERENCES target_types(id)
      ON DELETE CASCADE;

DESC media;

ALTER TABLE media
  ADD CONSTRAINT media_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT media_media_type_id_fk
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
      ON DELETE CASCADE;

-- Получили ошибку
-- SQL Error [1452] [23000]: Cannot add or update a child row: a foreign key constraint fails 
-- (`vk`.`#sql-298_c`, CONSTRAINT `media_media_type_id_fk` FOREIGN KEY (`media_type_id`) REFERENCES `media_types` 
-- (`id`) ON DELETE CASCADE)
-- Разбираемся

SELECT * FROM media LIMIT 10;
SELECT * FROM media_types;

-- Проблема: в таблицу media_types id имеют значения 8 6 7, а в таблице media media_type_id значения 1 2 3
-- Исправляем

UPDATE media_types SET id = 2 WHERE name = 'audio';
UPDATE media_types SET id = 1 WHERE name = 'photo';
UPDATE media_types SET id = 3 WHERE name = 'video';

-- Пробуем заново добавить внешение ключи в таблицу media. Успешно.

DESC media_types;

-- внешних ключей для данной таблицы не требуется, все данные уникальны

DESC messages;

-- Возможно так только у меня в БД, но на мой взгляд в структуре таблицы messages есть проблема:
-- столбец to_user_id не может быть NULL, хотя если сообщение отправлено в сообщество, то to_community_id должен содержать id сообщества,
-- а to_user_id должен быть NULL и наоборот.
-- Вопрос: можно ли добавить условие такое, что столбцы to_user_id и to_community_id могут быть NULL но не одновременно?
-- То есть хотя бы один из столбцов должен быть не NULL. Сообщение может быть отправлено либо пользователю, либо сообществу, но
-- не может быть отправлено никому.

ALTER TABLE messages
  ADD CONSTRAINT messages_from_user_id_fk
    FOREIGN KEY (from_user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT messages_to_user_id_fk
    FOREIGN KEY (to_user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT messages_to_community_id_fk
    FOREIGN KEY (to_community_id) REFERENCES communities(id)
      ON DELETE CASCADE;

-- Ошибка: SQL Error [1452] [23000]: Cannot add or update a child row: a foreign key constraint fails (`vk`.`#sql-298_c`, 
-- CONSTRAINT `messages_to_user_id_fk` FOREIGN KEY (`to_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE)
-- Исправляем в соответствии с вышеописанной логикой

ALTER TABLE messages MODIFY COLUMN to_user_id INT(10) UNSIGNED;

-- Заполняем столбец to_user_id случайными числами от 1 до 150 (в моих данных пользователей 150)

UPDATE messages SET to_user_id = FLOOR (1 + (RAND() * 149));

-- Пробуем добавить ключи. Опять ошибка, но уже связанная со столбцом from_user_id
-- Обновим данные для него.

UPDATE messages SET from_user_id = FLOOR (1 + (RAND() * 149));

-- Пробуем добавить ключи. Успешно.

DESC posts;

ALTER TABLE posts
  ADD CONSTRAINT posts_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT posts_media_id_fk
    FOREIGN KEY (media_id) REFERENCES media(id)
      ON DELETE SET NULL;
     
DESC profiles;

ALTER TABLE profiles
  ADD CONSTRAINT profiles_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT profiles_photo_id_fk
    FOREIGN KEY (photo_id) REFERENCES media(id)
      ON DELETE SET NULL;

DESC target_types;

-- внешних ключей для данной таблицы не требуется, все данные уникальны

DESC users;

-- внешних ключей для данной таблицы не требуется, все данные уникальны


-- Задание 3. Переписать запросы, заданые к ДЗ урока 6 с использованием JOIN (четыре запроса).

-- 1. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.
-- Запрос без использования JOIN

SELECT * FROM (
            SELECT user_id FROM profiles ORDER BY birthdate DESC LIMIT 10
          ) AS sorted_profiles;
SELECT SUM(likes_per_user) AS likes_total FROM ( 
  SELECT COUNT(*) AS likes_per_user 
    FROM likes 
      WHERE target_type_id = 2
        AND target_id IN (
          SELECT * FROM (
            SELECT user_id FROM profiles ORDER BY birthdate DESC LIMIT 10
          ) AS sorted_profiles 
        ) 
      GROUP BY target_id
) AS counted_likes;

-- Запрос с использованием JOIN. 

SELECT SUM(likes_per_user) AS likes_total FROM ( 
  SELECT target_id, COUNT(*) AS likes_per_user, profiles.user_id, profiles.birthdate
  FROM likes
    JOIN profiles
      ON target_id  = profiles.user_id 
      AND target_id IN (
          SELECT * FROM (
            SELECT user_id FROM profiles ORDER BY birthdate DESC LIMIT 10
          ) AS sorted_profiles 
      ) 
  WHERE target_type_id = 2
  GROUP BY target_id
) AS counted_likes;

-- Запрос работает, но корректно ли применять конструкцию 
-- AND target_id IN (
--   SELECT * FROM (
--     SELECT user_id FROM profiles ORDER BY birthdate DESC LIMIT 10
--       ) AS sorted_profiles 
-- ) 
-- вместе с JOIN?

-- 2. Определить кто больше поставил лайков (всего) - мужчины или женщины?
-- Запрос без использования JOIN

SELECT 
  (CASE(sex)
		WHEN 'm' THEN 'man'
		WHEN 'f' THEN 'woman'
	END) AS sex, 
	COUNT(*) as likes_count 
	  FROM (
	    SELECT 
	      user_id as user, 
		    (SELECT sex FROM profiles WHERE user_id = user) as sex 
		  FROM likes) dummy_table 
  GROUP BY sex
  ORDER BY likes_count DESC
  LIMIT 1;
 
-- К сожалению, я запутался, но выполнить получилось следующим образом:
-- Написал запрос

SELECT likes.user_id AS liked_by, profiles.sex
FROM likes
  JOIN profiles
    ON likes.user_id = profiles.user_id;

-- Таблица, которая получается в результате выполнения запроса выше, совпадает с таблицей, полученной запросом ниже

SELECT 
	user_id as user, 
		(SELECT sex FROM profiles WHERE user_id = user) as sex 
	FROM likes;

-- Заменив один запрос на другой, получил работающий запрос к базе с использованием JOIN

SELECT 
  (CASE(sex)
		WHEN 'm' THEN 'man'
		WHEN 'f' THEN 'woman'
	END) AS sex, 
	COUNT(*) as likes_count 
	  FROM (
	    SELECT likes.user_id AS liked_by, profiles.sex
			FROM likes
  			JOIN profiles
   			  ON likes.user_id = profiles.user_id) dummy_table 
  GROUP BY sex
  ORDER BY likes_count DESC
  LIMIT 1;

-- 3. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети
-- Запрос без использования JOIN

SELECT CONCAT(first_name, ' ', last_name) AS user, 
	(SELECT COUNT(*) FROM likes WHERE likes.user_id = users.id) + 
	(SELECT COUNT(*) FROM media WHERE media.user_id = users.id) + 
	(SELECT COUNT(*) FROM messages WHERE messages.from_user_id = users.id) 
	AS overall_activity 
	FROM users
	ORDER BY overall_activity
	LIMIT 10;
	
-- Не смог придумать, как формаировать запрос с использованием JOIN для этой задачи
-- Если получится сделать до следующего вебинара добавлю коммит и сообщу от этом.