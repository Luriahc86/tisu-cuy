import db from "../config/db.js";

export const getAkun = async (req, res) => {
  try {
    const [rows] = await db.query("SELECT * FROM v_akun");
    res.status(200).json(rows);
  } catch (err) {
    res.status(500).json({ message: "Gagal memuat data akun" });
  }
};

export const createAkun = async (req, res) => {
  try {
    const { id_akun, username, password, role, nama_lengkap, email } = req.body;
    await db.query("CALL sp_insert_akun(?, ?, ?, ?, ?, ?)", [
      id_akun,
      username,
      password,
      role,
      nama_lengkap,
      email,
    ]);
    res.status(201).json({ message: "Akun berhasil ditambahkan" });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

export const updateAkun = async (req, res) => {
  try {
    const { id_akun_aktif, id_akun_target, username, password, role, nama_lengkap, email } = req.body;

    if (!id_akun_aktif || !id_akun_target || !username || !role) {
      return res.status(400).json({ message: "Data tidak lengkap untuk update akun!" });
    }

    await db.query("CALL sp_update_akun(?, ?, ?, ?, ?, ?, ?)", [
      id_akun_aktif,
      id_akun_target,
      username,
      password,
      role,
      nama_lengkap,
      email,
    ]);

    res.status(200).json({ message: "Akun berhasil diperbarui" });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

export const deleteAkun = async (req, res) => {
  try {
    const { id_akun_aktif, id_akun_target } = req.body;

    if (!id_akun_aktif || !id_akun_target) {
      return res.status(400).json({ message: "id_akun_aktif dan id_akun_target wajib diisi!" });
    }

    await db.query("CALL sp_delete_akun(?, ?)", [id_akun_aktif, id_akun_target]);
    res.status(200).json({ message: "Akun berhasil dihapus" });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};
