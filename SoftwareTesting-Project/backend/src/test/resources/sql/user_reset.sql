SET @max_id = (SELECT MAX(id) FROM user);
SET @new_auto_increment = @max_id + 1;
SET @alter_sql = CONCAT('ALTER TABLE user AUTO_INCREMENT = ', @new_auto_increment);
PREPARE stmt FROM @alter_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
