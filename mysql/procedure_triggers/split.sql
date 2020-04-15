DELIMITER $$
DROP PROCEDURE IF EXISTS split_string $$
CREATE TABLE if not exists tmp_store (
    id int NOT NULL AUTO_INCREMENT,
    allValues varchar(100) Default NULL,
    PRIMARY KEY(id)
) $$

CREATE PROCEDURE split_string(Value longtext)
BEGIN
DECLARE front TEXT DEFAULT NULL;
DECLARE frontlen INT DEFAULT NULL;
DECLARE TempValue TEXT DEFAULT NULL;
iterator:
LOOP  
IF LENGTH(TRIM(Value)) = 0 OR Value IS NULL THEN
LEAVE iterator;
END IF;
SET front = SUBSTRING_INDEX(Value,',',1);
SET frontlen = LENGTH(front);
SET TempValue = TRIM(front);
INSERT INTO tmp_store (allValues) VALUES (TempValue);
SET Value = INSERT(Value,1,frontlen + 1,'');
END LOOP;
END $$
DELIMITER ;
