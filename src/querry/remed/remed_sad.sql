DROP DATABASE IF EXISTS cleaning_system;
CREATE DATABASE cleaning_system;
USE cleaning_system;

Drop TABLE IF EXISTS like;
Drop TABLE IF EXISTS comment;
Drop TABLE IF EXISTS post;
Drop TABLE IF EXISTS gambar;
Drop TABLE IF EXISTS pengguna;  

CREATE TABLE pengguna (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(20) NOT NULL,
    username VARCHAR(20) NOT NULL,
    password VARCHAR(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE gambar (
    id INT AUTO_INCREMENT PRIMARY KEY,
    judul VARCHAR(50) NOT NULL,
    caption TEXT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE post (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    id_gambar INT NOT NULL,

    CONSTRAINT fk_user_post
        FOREIGN KEY (id_user)
        REFERENCES pengguna(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_gambar_post
        FOREIGN KEY (id_gambar)
        REFERENCES gambar(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE comment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    id_gambar INT NOT NULL,

    CONSTRAINT fk_user_comment
        FOREIGN KEY (id_user)
        REFERENCES pengguna(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_gambar_comment
        FOREIGN KEY (id_gambar)
        REFERENCES gambar(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE like (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    id_gambar INT NOT NULL,

    CONSTRAINT fk_user_like
        FOREIGN KEY (id_user)
        REFERENCES pengguna(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_gambar_like
        FOREIGN KEY (id_gambar)
        REFERENCES gambar(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_post_user ON post(id_user);
CREATE INDEX idx_post_gambar ON post(id_gambar);
CREATE INDEX idx_comment_user ON comment(id_user);
CREATE INDEX idx_comment_gambar ON comment(id_gambar);
CREATE INDEX idx_like_user ON like(id_user);
CREATE INDEX idx_like_gambar ON like(id_gambar);
COMMIT;