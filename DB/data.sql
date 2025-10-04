INSERT INTO vote_item(name) VALUES ('電腦'), ('滑鼠');

-- 使用 sp_vote 插入，會同時更新 vote_stat
CALL sp_vote('Leo',   1);
CALL sp_vote('Sandy', 1);
CALL sp_vote('Sandy', 2);
CALL sp_vote('Randy', 2);
CALL sp_vote('RSY',   2);
