SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM login;
DELETE FROM laporan_penggantian;
DELETE FROM dispenser;
DELETE FROM lokasi;
DELETE FROM pegawai;
DELETE FROM admin;
SET FOREIGN_KEY_CHECKS = 1;


SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE login;
TRUNCATE TABLE laporan_penggantian;
TRUNCATE TABLE dispenser;
TRUNCATE TABLE lokasi;
TRUNCATE TABLE pegawai;
TRUNCATE TABLE admin;
SET FOREIGN_KEY_CHECKS = 1;

-- ========================
-- ADMIN
-- ========================
INSERT INTO admin (username, password)
VALUES
('apong', 'Adm!n_47op'),
('bima', 'B1m@_Adm#'),
('ata', 'At@_Secr3t!'),
('raka', 'R@k4_Sys$'),
('doni', 'D0n!_Adm@'),
('nisa', 'N!s@_Admin');

-- ========================
-- PEGAWAI
-- ========================
INSERT INTO pegawai (username, password)
VALUES
('rei', 'Re1#Peg@2025'),
('luri', 'Lur!i$23'),
('faisal', 'F@i$4L#99'),
('noel', 'N0eL!Peg@'),
('tina', 'T!n@Peg1'),
('andika', 'And1k@Peg$');

-- ========================
-- LOKASI
-- ========================
INSERT INTO lokasi (nama_lokasi, lokasi, deskripsi)
VALUES
('Gedung A Lantai 1 Toilet Mahasiswa Laki-Laki', 'Gedung A', 'Toilet mahasiswa laki-laki di lantai 1 Gedung A'),
('Gedung A Lantai 2 Toilet Mahasiswa Perempuan', 'Gedung A', 'Toilet mahasiswa perempuan di lantai 2 Gedung A'),
('Gedung B Lantai 1 Toilet Dosen Laki-Laki', 'Gedung B', 'Toilet dosen laki-laki di lantai 1 Gedung B'),
('Gedung C Lantai 2 Toilet Mahasiswa Perempuan', 'Gedung C', 'Toilet mahasiswa perempuan di lantai 2 Gedung C'),
('LabTer 1 Lantai 1 Toilet Dosen Perempuan', 'LabTer 1', 'Toilet dosen perempuan di lantai 1 LabTer 1'),
('LabTer 2 Lantai 3 Toilet Mahasiswa Laki-Laki', 'LabTer 2', 'Toilet mahasiswa laki-laki di lantai 3 LabTer 2');

-- ========================
-- DISPENSER
-- ========================
INSERT INTO dispenser (id_lokasi, kondisi)
VALUES
(1, 'AKTIF'),
(2, 'RUSAK'),
(3, 'AKTIF'),
(4, 'PERBAIKAN'),
(5, 'AKTIF'),
(6, 'AKTIF');

-- ========================
-- LAPORAN_PENGGANTIAN
-- ========================
INSERT INTO laporan_penggantian (id_dispenser, id_pegawai, jumlah_tisu, keterangan, waktu)
VALUES
(1, 1, 25, 'Isi ulang dispenser Gedung A', NOW() - INTERVAL 6 DAY),
(2, 2, 30, 'Perbaikan dispenser Gedung A Lantai 2', NOW() - INTERVAL 5 DAY),
(3, 3, 35, 'Penggantian tisu Gedung B Lantai 1', NOW() - INTERVAL 4 DAY),
(4, 4, 40, 'Perawatan dispenser Gedung C Lantai 2', NOW() - INTERVAL 3 DAY),
(5, 5, 45, 'Isi ulang tisu LabTer 1 Lantai 1', NOW() - INTERVAL 2 DAY),
(6, 6, 50, 'Cek dispenser LabTer 2 Lantai 3', NOW() - INTERVAL 1 DAY);

-- ========================
-- LOGIN
-- ========================
INSERT INTO login (id_admin, id_pegawai, waktu_login)
VALUES
(1, NULL, NOW() - INTERVAL 6 DAY),
(2, NULL, NOW() - INTERVAL 5 DAY),
(NULL, 1, NOW() - INTERVAL 4 DAY),
(NULL, 2, NOW() - INTERVAL 3 DAY),
(NULL, 3, NOW() - INTERVAL 2 DAY),
(NULL, 4, NOW() - INTERVAL 1 DAY);

SELECT total_tisu_by_pegawai(1);
SELECT total_laporan_by_dispenser(3);
SELECT total_dispenser_by_lokasi(2);
SELECT last_penggantian_by_dispenser(6);
SELECT get_laporan_by_lokasi(1);
SELECT rekap_penggantian_periode(CURDATE()-INTERVAL 7 DAY, CURDATE());