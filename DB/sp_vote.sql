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
    -- 取出 JSON 陣列中的第 i 個元素，轉為整數
    SET item_id = CAST(JSON_UNQUOTE(JSON_EXTRACT(p_item_ids, CONCAT('$[', i, ']'))) AS UNSIGNED);
    -- 透過 sp_vote 寫入紀錄並更新統計
    CALL sp_vote(p_voter, item_id);
    SET i = i + 1;
  END WHILE;
  COMMIT;
END$$
DELIMITER ;
