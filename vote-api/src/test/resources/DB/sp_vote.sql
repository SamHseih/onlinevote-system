-- 使用資料庫（若已在 schema.sql 內 USE 就可省略）
SET NAMES utf8mb4;
USE esun_vote;

-- 如果舊的同名 SP 存在就先移除
DROP PROCEDURE IF EXISTS sp_cast_votes;

DELIMITER $$

/**
 * sp_cast_votes
 * @param v_voter   投票人名稱（必填）
 * @param v_item_ids JSON 陣列，如：[1,2,3]
 *
 * 行為：
 *   - 逐一呼叫 schema.sql 內的 sp_vote(v_voter, v_item_id)
 *   - 全程包在 TRANSACTION；任一筆失敗則 ROLLBACK 全部
 *   - 若投重複的項目，因 vote_record 上有 (voter,item_id) 唯一鍵，會丟錯並回滾
 */
CREATE PROCEDURE sp_cast_votes(
  IN v_voter    VARCHAR(100),
  IN v_item_ids JSON
)
BEGIN
  DECLARE i INT DEFAULT 0;
  DECLARE n INT DEFAULT 0;
  DECLARE v_item_id BIGINT;

  -- 任何 SQL 例外都回滾並結束
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;

  -- 基本參數檢查
  IF v_voter IS NULL OR JSON_TYPE(v_item_ids) <> 'ARRAY' THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Invalid arguments: voter required and item_ids must be JSON array';
  END IF;

  SET n = JSON_LENGTH(v_item_ids);

  START TRANSACTION;

  WHILE i < n DO
    -- 取出第 i 個 item_id（轉成整數）
    SET v_item_id = CAST(JSON_UNQUOTE(JSON_EXTRACT(v_item_ids, CONCAT('$[', i, ']'))) AS UNSIGNED);

    -- 呼叫單筆投票的 SP（此 SP 於 schema.sql 已建立）
    CALL sp_vote(v_voter, v_item_id);

    SET i = i + 1;
  END WHILE;

  COMMIT;
END$$

DELIMITER ;
