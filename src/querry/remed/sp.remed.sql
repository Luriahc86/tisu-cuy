DELIMITER $$

CREATE PROCEDURE sp_insert_pengguna(
    IN p_nama VARCHAR(20),
    IN p_username VARCHAR(20),
    IN p_password VARCHAR(20)
)
BEGIN
    START TRANSACTION;
        INSERT INTO pengguna(nama, username, password)
        VALUES (p_nama, p_username, p_password);
    COMMIT;
END$$


CREATE PROCEDURE sp_update_pengguna(
    IN p_id INT,
    IN p_nama VARCHAR(20)
)
BEGIN
    IF fn_pengguna_exists(p_id) = FALSE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pengguna tidak ditemukan';
    END IF;

    START TRANSACTION;
        UPDATE pengguna SET nama = p_nama WHERE id = p_id;
    COMMIT;
END$$


CREATE PROCEDURE sp_delete_pengguna(IN p_id INT)
BEGIN
    IF fn_pengguna_exists(p_id) = FALSE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pengguna tidak ditemukan';
    END IF;

    START TRANSACTION;
        DELETE FROM pengguna WHERE id = p_id;
    COMMIT;
END$$

CREATE PROCEDURE sp_insert_post(IN p_user INT, IN p_gambar INT)
BEGIN
    START TRANSACTION;
        INSERT INTO post(id_user, id_gambar)
        VALUES (p_user, p_gambar);
    COMMIT;
END;

CREATE PROCEDURE sp_delete_post(IN p_id INT)
BEGIN
    IF fn_post_exists(p_id) = FALSE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Post tidak ditemukan';
    END IF;

    START TRANSACTION;
        DELETE FROM post WHERE id = p_id;
    COMMIT;
END;

CREATE PROCEDURE sp_insert_likes(IN p_user INT, IN p_gambar INT)
BEGIN
    IF fn_likes_exists(p_user,p_gambar) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Sudah like';
    END IF;

    START TRANSACTION;
        INSERT INTO `like`(id_user,id_gambar)
        VALUES(p_user,p_gambar);
    COMMIT;
END;


DELIMITER ;