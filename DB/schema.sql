SET NAMES utf8mb4;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_unicode_ci;

-- 重建
DROP DATABASE IF EXISTS esun_vote;
CREATE DATABASE esun_vote
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;
USE esun_vote;

-- 保險移除
DROP TABLE IF EXISTS vote_record;
DROP TABLE IF EXISTS vote_stat;
DROP TABLE IF EXISTS vote_item;

CREATE TABLE vote_item (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL UNIQUE,
  enabled TINYINT NOT NULL DEFAULT 1
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

CREATE TABLE vote_record (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  voter VARCHAR(100) NOT NULL,
  item_id BIGINT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_voter_item (voter, item_id),
  CONSTRAINT fk_record_item FOREIGN KEY (item_id) REFERENCES vote_item(id) ON DELETE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

CREATE TABLE vote_stat (
  item_id BIGINT PRIMARY KEY,
  total INT NOT NULL DEFAULT 0,
  CONSTRAINT fk_stat_item FOREIGN KEY (item_id) REFERENCES vote_item(id) ON DELETE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

-- Stored Procedures
DROP PROCEDURE IF EXISTS sp_add_item;
DELIMITER //
CREATE PROCEDURE sp_add_item(IN v_name VARCHAR(100))
BEGIN
  INSERT INTO vote_item(name) VALUES (v_name);
  INSERT INTO vote_stat(item_id,total) VALUES (LAST_INSERT_ID(),0);
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_update_item;
DELIMITER //
CREATE PROCEDURE sp_update_item(IN v_id BIGINT, IN v_name VARCHAR(100), IN v_enabled TINYINT)
BEGIN
  UPDATE vote_item SET name = v_name, enabled = v_enabled WHERE id = v_id;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_delete_item;
DELIMITER //
CREATE PROCEDURE sp_delete_item(IN v_id BIGINT)
BEGIN
  DELETE FROM vote_item WHERE id = v_id;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_vote;
DELIMITER //
CREATE PROCEDURE sp_vote(IN v_voter VARCHAR(100), IN v_item_id BIGINT)
BEGIN
  INSERT INTO vote_record(voter,item_id) VALUES (v_voter, v_item_id);
  INSERT INTO vote_stat(item_id,total) VALUES (v_item_id,1)
  ON DUPLICATE KEY UPDATE total = total + 1;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_list_items_with_count;
DELIMITER //
CREATE PROCEDURE sp_list_items_with_count()
BEGIN
  SELECT i.id, i.name, i.enabled, COALESCE(s.total,0) AS total
  FROM vote_item i
  LEFT JOIN vote_stat s ON s.item_id = i.id
  ORDER BY i.id;
END//
DELIMITER ;
