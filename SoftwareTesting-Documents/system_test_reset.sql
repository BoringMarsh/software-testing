DELETE FROM student WHERE stu_id >= 20;
DELETE FROM user WHERE id >= 20;

SET @max_id = (SELECT MAX(id) FROM user);
SET @new_auto_increment = @max_id + 1;
SET @alter_sql = CONCAT('ALTER TABLE user AUTO_INCREMENT = ', @new_auto_increment);
PREPARE stmt FROM @alter_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

DELETE FROM activity WHERE act_id >= 4;

SET @max_id = (SELECT MAX(act_id) FROM activity);
SET @new_auto_increment = @max_id + 1;
SET @alter_sql = CONCAT('ALTER TABLE activity AUTO_INCREMENT = ', @new_auto_increment);
PREPARE stmt FROM @alter_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;