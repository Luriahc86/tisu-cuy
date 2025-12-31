import db from "../config/db.js";

export const createGambar = async (req, res) => {
  const { judul, caption } = req.body;
  try {
    await db.query("CALL sp_insert_gambar(?,?)", [judul, caption]);
    res.json({ message: "Gambar berhasil ditambahkan" });
  } catch (err) {
    res.status(400).json({ error: err.sqlMessage });
  }
};

export const deleteGambar = async (req, res) => {
  try {
    await db.query("CALL sp_delete_gambar(?)", [req.params.id]);
    res.json({ message: "Gambar berhasil dihapus" });
  } catch (err) {
    res.status(400).json({ error: err.sqlMessage });
  }
};
