import db from "../config/db.js";

export const createLike = async (req, res) => {
  const { id_user, id_gambar } = req.body;
  try {
    await db.query("CALL sp_insert_like(?,?)", [id_user, id_gambar]);
    res.json({ message: "Like berhasil ditambahkan" });
  } catch (err) {
    res.status(400).json({ error: err.sqlMessage });
  }
};
