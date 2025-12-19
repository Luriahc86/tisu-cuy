DELIMITER $$

CREATE TRIGGER trg_before_delete_comment
BEFORE DELETE ON comment
FOR EACH ROW
BEGIN
    IF OLD.id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Comment ID tidak valid';
    END IF;
END $$

DELIMITER ;
