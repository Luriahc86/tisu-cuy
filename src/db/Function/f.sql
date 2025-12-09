DELIMITER $$

DROP FUNCTION IF EXISTS fn_get_nama_akun $$
CREATE FUNCTION fn_get_nama_akun(p_id_akun INT)
RETURNS VARCHAR(100)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_nama VARCHAR(100);
    SELECT nama_lengkap INTO v_nama
    FROM akun
    WHERE id_akun = p_id_akun;
    RETURN v_nama;
END $$

DROP FUNCTION IF EXISTS fn_get_nama_lokasi_by_dispenser $$
CREATE FUNCTION fn_get_nama_lokasi_by_dispenser(p_id_dispenser INT)
RETURNS VARCHAR(100)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_nama_lokasi VARCHAR(100);
    SELECT l.nama_lokasi INTO v_nama_lokasi
    FROM dispenser d
    JOIN lokasi l ON d.id_lokasi = l.id_lokasi
    WHERE d.id_dispenser = p_id_dispenser;
    RETURN v_nama_lokasi;
END $$

DROP FUNCTION IF EXISTS fn_get_status_dispenser $$
CREATE FUNCTION fn_get_status_dispenser(p_id_dispenser INT)
RETURNS VARCHAR(20)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_kondisi VARCHAR(20);
    SELECT kondisi INTO v_kondisi
    FROM dispenser
    WHERE id_dispenser = p_id_dispenser;
    RETURN v_kondisi;
END $$

DROP FUNCTION IF EXISTS fn_total_laporan_pegawai $$
CREATE FUNCTION fn_total_laporan_pegawai(p_id_akun INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_total INT;
    SELECT COUNT(*) INTO v_total
    FROM laporan_penggantian
    WHERE id_akun = p_id_akun;
    RETURN v_total;
END $$

DROP FUNCTION IF EXISTS fn_total_dispenser_kondisi $$
CREATE FUNCTION fn_total_dispenser_kondisi(p_kondisi VARCHAR(20))
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_total INT;
    SELECT COUNT(*) INTO v_total
    FROM dispenser
    WHERE kondisi = p_kondisi;
    RETURN v_total;
END $$

DROP FUNCTION IF EXISTS fn_total_laporan_lokasi $$
CREATE FUNCTION fn_total_laporan_lokasi(p_id_lokasi INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_total INT;
    SELECT COUNT(*) INTO v_total
    FROM laporan_penggantian lp
    JOIN dispenser d ON lp.id_dispenser = d.id_dispenser
    WHERE d.id_lokasi = p_id_lokasi;
    RETURN v_total;
END $$

DROP FUNCTION IF EXISTS fn_waktu_terakhir_penggantian $$
CREATE FUNCTION fn_waktu_terakhir_penggantian(p_id_dispenser INT)
RETURNS DATETIME
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_waktu DATETIME;
    SELECT MAX(waktu_penggantian) INTO v_waktu
    FROM laporan_penggantian
    WHERE id_dispenser = p_id_dispenser;
    RETURN v_waktu;
END $$

DELIMITER ;