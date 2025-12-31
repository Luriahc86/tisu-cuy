import db from "../config/db.js";

export const createPengguna = async (req, res) => {
  const { nama, username, password } = req.body;
  try {
    await db.query("CALL sp_insert_pengguna(?,?,?)", [
      nama,
      username,
      password
    ]);
    res.json({ message: "Pengguna berhasil ditambahkan" });
  } catch (err) {
    res.status(400).json({ error: err.sqlMessage });
  }
};

export const updatePengguna = async (req, res) => {
  try {
    await db.query("CALL sp_update_pengguna(?,?)", [
      req.params.id,
      req.body.nama
    ]);
    res.json({ message: "Pengguna berhasil diupdate" });
  } catch (err) {
    res.status(400).json({ error: err.sqlMessage });
  }
};

export const deletePengguna = async (req, res) => {
  try {
    await db.query("CALL sp_delete_pengguna(?)", [req.params.id]);
    res.json({ message: "Pengguna berhasil dihapus" });
  } catch (err) {
    res.status(400).json({ error: err.sqlMessage });
  }
};
