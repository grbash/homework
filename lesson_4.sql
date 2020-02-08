UPDATE users SET created_at = updated_at WHERE created_at > updated_at;

-- упрощаем изначальные данные, изначально photo_id было случайным числом от 1 до 100000

UPDATE profiles SET photo_id = FLOOR(1 + (RAND() * 150));

UPDATE messages SET
  from_user_id = FLOOR(1 + (RAND() * 300)),
  to_user_id = FLOOR(1 + (RAND() * 300))
;

TRUNCATE media_types;


INSERT INTO media_types (name) VALUES
  ('photo'),
  ('video'),
  ('audio')
;

UPDATE media SET media_type_id = FLOOR(1 + (RAND() * 3));

UPDATE media SET user_id = FLOOR(1 + (RAND() * 150));

UPDATE media SET filename = CONCAT('https://dropbox/vk/file_', size);

UPDATE media SET metadata = CONCAT('{"owner":"', 
  (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = user_id),
  '"}');   
  
ALTER TABLE media MODIFY COLUMN metadata JSON;

TRUNCATE friendship_statuses;

INSERT INTO friendship_statuses (name)
  VALUES ('Requested'), ('Confirmed'), ('Rejected');
  
UPDATE friendship SET status_id = FLOOR(1 + (RAND() * 2));  

SELECT * FROM communities;

DELETE FROM communities WHERE id > 10;

UPDATE communities_users SET community_id = FLOOR(1 + (RAND() * 10));

ALTER TABLE profiles ADD COLUMN user_id INT UNSIGNED NOT NULL FIRST;
UPDATE profiles SET user_id = FLOOR(1 + (RAND() * 150)); 

CREATE TABLE posts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  media_id INT UNSIGNED, 
  user_id INT UNSIGNED not null,
  head VARCHAR(255), 
  body MEDIUMTEXT, 
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
); 

ALTER TABLE messages ADD COLUMN to_community_id INT UNSIGNED AFTER to_user_id;

UPDATE messages 
  SET to_community_id = FLOOR(1 + (RAND() * 10))
  WHERE id > 50 AND id < 70; 

ALTER TABLE communities ADD COLUMN is_open BOOLEAN;
ALTER TABLE communities ADD COLUMN description VARCHAR(255) AFTER name;
UPDATE communities SET is_open = TRUE WHERE id IN (2, 3, 5, 8, 9);
UPDATE communities SET is_open = FALSE WHERE is_open IS NULL;
UPDATE communities SET description = (SELECT body 
    FROM messages WHERE messages.id = communities.id);











