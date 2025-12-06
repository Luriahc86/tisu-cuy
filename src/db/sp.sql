DELIMITER $$
CREATE PROCEDURE sp_insert_akun (
    IN p_id_akun_aktif INT,
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(100),
    IN p_role ENUM('ADMIN', 'PEGAWAI'),
    IN p_nama_lengkap VARCHAR(100),
    IN p_email VARCHAR(100)
)
BEGIN
    DECLARE v_role ENUM('ADMIN', 'PEGAWAI');

    SELECT role INTO v_role FROM akun WHERE id_akun = p_id_akun_aktif;

    IF v_role != 'ADMIN' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Hanya ADMIN yang dapat menambah akun!';
    ELSE
        START TRANSACTION;
        INSERT INTO akun (username, password, role, nama_lengkap, email)
        VALUES (p_username, p_password, p_role, p_nama_lengkap, p_email);
        COMMIT;
    END IF;
END $$


CREATE PROCEDURE sp_update_akun (
    IN p_id_akun_aktif INT,
    IN p_id_akun_target INT,
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(100),
    IN p_role ENUM('ADMIN', 'PEGAWAI'),
    IN p_nama_lengkap VARCHAR(100),
    IN p_email VARCHAR(100)
)
BEGIN
    DECLARE v_role ENUM('ADMIN', 'PEGAWAI');
    SELECT role INTO v_role FROM akun WHERE id_akun = p_id_akun_aktif;

    IF v_role != 'ADMIN' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Hanya ADMIN yang dapat mengedit akun!';
    ELSE
        START TRANSACTION;
        UPDATE akun
        SET username = p_username,
            password = p_password,
            role = p_role,
            nama_lengkap = p_nama_lengkap,
            email = p_email
        WHERE id_akun = p_id_akun_target;
        COMMIT;
    END IF;
END $$


CREATE PROCEDURE sp_delete_akun (
    IN p_id_akun_aktif INT,
    IN p_id_akun_target INT
)
BEGIN
    DECLARE v_role ENUM('ADMIN', 'PEGAWAI');
    SELECT role INTO v_role FROM akun WHERE id_akun = p_id_akun_aktif;

    IF v_role != 'ADMIN' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Hanya ADMIN yang dapat menghapus akun!';
    ELSE
        START TRANSACTION;
        DELETE FROM akun WHERE id_akun = p_id_akun_target;
        COMMIT;
    END IF;
END $$

CREATE PROCEDURE sp_insert_lokasi (
    IN p_id_akun_aktif INT,
    IN p_nama_lokasi VARCHAR(100),
    IN p_deskripsi TEXT
)
BEGIN
    DECLARE v_role ENUM('ADMIN', 'PEGAWAI');
    SELECT role INTO v_role FROM akun WHERE id_akun = p_id_akun_aktif;

    IF v_role != 'ADMIN' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Hanya ADMIN yang dapat menambah lokasi!';
    ELSE
        START TRANSACTION;
        INSERT INTO lokasi (nama_lokasi, deskripsi)
        VALUES (p_nama_lokasi, p_deskripsi);
        COMMIT;
    END IF;
END $$


CREATE PROCEDURE sp_update_lokasi (
    IN p_id_akun_aktif INT,
    IN p_id_lokasi INT,
    IN p_nama_lokasi VARCHAR(100),
    IN p_deskripsi TEXT
)
BEGIN
    DECLARE v_role ENUM('ADMIN', 'PEGAWAI');
    SELECT role INTO v_role FROM akun WHERE id_akun = p_id_akun_aktif;

    IF v_role != 'ADMIN' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Hanya ADMIN yang dapat mengedit lokasi!';
    ELSE
        START TRANSACTION;
        UPDATE lokasi
        SET nama_lokasi = p_nama_lokasi,
            deskripsi = p_deskripsi
        WHERE id_lokasi = p_id_lokasi;
        COMMIT;
    END IF;
END $$


CREATE PROCEDURE sp_delete_lokasi (
    IN p_id_akun_aktif INT,
    IN p_id_lokasi INT
)
BEGIN
    DECLARE v_role ENUM('ADMIN', 'PEGAWAI');
    SELECT role INTO v_role FROM akun WHERE id_akun = p_id_akun_aktif;

    IF v_role != 'ADMIN' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Hanya ADMIN yang dapat menghapus lokasi!';
    ELSE
        START TRANSACTION;
        DELETE FROM lokasi WHERE id_lokasi = p_id_lokasi;
        COMMIT;
    END IF;
END $$

CREATE PROCEDURE sp_insert_dispenser (
    IN p_id_akun_aktif INT,
    IN p_id_lokasi INT,
    IN p_kode_dispenser VARCHAR(50),
    IN p_kondisi ENUM('AKTIF', 'RUSAK', 'PERBAIKAN'),
    IN p_tanggal_pasang DATE
)
BEGIN
    DECLARE v_role ENUM('ADMIN', 'PEGAWAI');
    SELECT role INTO v_role FROM akun WHERE id_akun = p_id_akun_aktif;

    IF v_role != 'ADMIN' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Hanya ADMIN yang dapat menambah dispenser!';
    ELSE
        START TRANSACTION;
        INSERT INTO dispenser (id_lokasi, kode_dispenser, kondisi, tanggal_pasang)
        VALUES (p_id_lokasi, p_kode_dispenser, p_kondisi, p_tanggal_pasang);
        COMMIT;
    END IF;
END $$


CREATE PROCEDURE sp_update_dispenser (
    IN p_id_akun_aktif INT,
    IN p_id_dispenser INT,
    IN p_id_lokasi INT,
    IN p_kode_dispenser VARCHAR(50),
    IN p_kondisi ENUM('AKTIF', 'RUSAK', 'PERBAIKAN'),
    IN p_tanggal_pasang DATE
)
BEGIN
    DECLARE v_role ENUM('ADMIN', 'PEGAWAI');
    SELECT role INTO v_role FROM akun WHERE id_akun = p_id_akun_aktif;

    IF v_role != 'ADMIN' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Hanya ADMIN yang dapat mengedit dispenser!';
    ELSE
        START TRANSACTION;
        UPDATE dispenser
        SET id_lokasi = p_id_lokasi,
            kode_dispenser = p_kode_dispenser,
            kondisi = p_kondisi,
            tanggal_pasang = p_tanggal_pasang
        WHERE id_dispenser = p_id_dispenser;
        COMMIT;
    END IF;
END $$


CREATE PROCEDURE sp_delete_dispenser (
    IN p_id_akun_aktif INT,
    IN p_id_dispenser INT
)
BEGIN
    DECLARE v_role ENUM('ADMIN', 'PEGAWAI');
    SELECT role INTO v_role FROM akun WHERE id_akun = p_id_akun_aktif;

    IF v_role != 'ADMIN' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Hanya ADMIN yang dapat menghapus dispenser!';
    ELSE
        START TRANSACTION;
        DELETE FROM dispenser WHERE id_dispenser = p_id_dispenser;
        COMMIT;
    END IF;
END $$


CREATE PROCEDURE sp_insert_laporan_penggantian (
    IN p_id_akun_aktif INT,
    IN p_id_dispenser INT,
    IN p_jumlah_tisu INT,
    IN p_keterangan TEXT
)
BEGIN
    DECLARE v_role ENUM('ADMIN', 'PEGAWAI');
    SELECT role INTO v_role FROM akun WHERE id_akun = p_id_akun_aktif;

    IF v_role != 'PEGAWAI' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Hanya PEGAWAI yang dapat menambah laporan penggantian!';
    ELSE
        START TRANSACTION;
        INSERT INTO laporan_penggantian (id_dispenser, id_akun, jumlah_tisu, keterangan)
        VALUES (p_id_dispenser, p_id_akun_aktif, p_jumlah_tisu, p_keterangan);
        COMMIT;
    END IF;
END $$

DELIMITER ;