CREATE VIEW v_gambar_summary AS
SELECT
    g.id AS id_gambar,
    g.judul,
    COUNT(DISTINCT p.id) AS total_post,
    COUNT(DISTINCT c.id) AS total_comment,
    COUNT(DISTINCT l.id) AS total_like
FROM gambar g
LEFT JOIN post p ON p.id_gambar = g.id
LEFT JOIN comment c ON c.id_gambar = g.id
LEFT JOIN `like` l ON l.id_gambar = g.id
GROUP BY g.id, g.judul;

CREATE VIEW v_pengguna AS
SELECT id, nama, username FROM pengguna;

CREATE VIEW v_post AS
SELECT p.id, u.nama, g.judul
FROM post p
JOIN pengguna u ON p.id_user = u.id
JOIN gambar g ON p.id_gambar = g.id;

CREATE VIEW v_comment AS
SELECT c.id, u.nama, g.judul
FROM comment c
JOIN pengguna u ON c.id_user = u.id
JOIN gambar g ON c.id_gambar = g.id;

CREATE VIEW v_like_count AS
SELECT id_gambar, COUNT(id) AS total_like
FROM `like`
GROUP BY id_gambar;
