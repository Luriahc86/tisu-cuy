DELIMITER $$

CREATE PROCEDURE sp_delete_comment_transaction (
    IN p_id_comment INT
)
BEGIN
    DECLARE exit handler FOR SQLEXCEPTION
    BEGIN
        -- Jika terjadi error
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM comment
    WHERE id = p_id_comment;

    COMMIT;
END $$

CALL sp_delete_comment_transaction(5);

DELIMITER ;
