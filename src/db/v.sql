DELIMITER $$
CREATE OR REPLACE VIEW v_akun AS
SELECT 
    id_akun,
    username,
    role,
    nama_lengkap,
    email,
    created_at,
    updated_at
FROM akun;

CREATE OR REPLACE VIEW v_lokasi AS
SELECT 
    id_lokasi,
    nama_lokasi,
    deskripsi,
    created_at,
    updated_at
FROM lokasi;

CREATE OR REPLACE VIEW v_dispenser AS
SELECT 
    d.id_dispenser,
    d.kode_dispenser,
    d.kondisi,
    d.tanggal_pasang,
    l.nama_lokasi,
    l.deskripsi AS deskripsi_lokasi,
    d.created_at,
    d.updated_at
FROM dispenser d
JOIN lokasi l ON d.id_lokasi = l.id_lokasi;

CREATE OR REPLACE VIEW v_laporan_penggantian AS
SELECT 
    lp.id_laporan,
    lp.id_dispenser,
    d.kode_dispenser,
    l.nama_lokasi,
    lp.id_akun,
    a.nama_lengkap AS nama_pegawai,
    a.username AS username_pegawai,
    lp.jumlah_tisu,
    lp.keterangan,
    lp.waktu_penggantian
FROM laporan_penggantian lp
JOIN dispenser d ON lp.id_dispenser = d.id_dispenser
JOIN lokasi l ON d.id_lokasi = l.id_lokasi
JOIN akun a ON lp.id_akun = a.id_akun;

DELIMITER $$