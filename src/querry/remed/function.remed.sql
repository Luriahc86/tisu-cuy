DELIMITER $$

CREATE FUNCTION fn_gambar_exists(p_id_gambar INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT COUNT(id)
    INTO total
    FROM gambar
    WHERE id = p_id_gambar;

    RETURN total > 0;
END$$

CREATE FUNCTION fn_pengguna_exists(p_id INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(id) INTO total FROM pengguna WHERE id = p_id;
    RETURN total > 0;
END$$

CREATE FUNCTION fn_post_exists(p_id INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(id) INTO total FROM post WHERE id = p_id;
    RETURN total > 0;
END;

CREATE FUNCTION fn_like_exists(p_user INT, p_gambar INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(id) INTO total
    FROM `like`
    WHERE id_user=p_user AND id_gambar=p_gambar;
    RETURN total > 0;
END;

DELIMITER $$