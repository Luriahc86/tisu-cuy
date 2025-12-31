DELIMITER $$

CREATE TRIGGER trg_after_insert_gambar
AFTER INSERT ON gambar
FOR EACH ROW
BEGIN
    INSERT INTO log_insert_gambar (
        id_gambar,
        judul,
        inserted_at
    )
    VALUES (
        NEW.id,
        NEW.judul,
        NOW()
    );
END$$
CREATE TRIGGER trg_after_delete_gambar
AFTER DELETE ON gambar
FOR EACH ROW
BEGIN
    INSERT INTO log_hapus_gambar(id_gambar, judul, deleted_at)
    VALUES (OLD.id, OLD.judul, NOW());
END$$

DELIMITER ;
