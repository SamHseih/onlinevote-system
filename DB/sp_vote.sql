USE esun_vote;
DROP PROCEDURE IF EXISTS sp_cast_votes;
DELIMITER $$
CREATE PROCEDURE sp_cast_votes(IN p_voter VARCHAR(100), IN p_item_ids JSON)
BEGIN
  DECLARE i INT DEFAULT 0;
  DECLARE n INT;
  DECLARE item_id BIGINT;

  START TRANSACTION;
  SET n = JSON_LENGTH(p_item_ids);
  WHILE i < n DO
    SET item_id = JSON_EXTRACT(p_item_ids, CONCAT('$[', i, ']'));
    INSERT INTO vote_record(voter, item_id) VALUES (p_voter, item_id);
    SET i = i + 1;
  END WHILE;
  COMMIT;
END$$
DELIMITER ;