import db from "../config/db.js";

export const createPost = async (req, res) => {
  const { id_user, id_gambar } = req.body;
  try {
    await db.query("CALL sp_insert_post(?,?)", [id_user, id_gambar]);
    res.json({ message: "Post berhasil dibuat" });
  } catch (err) {
    res.status(400).json({ error: err.sqlMessage });
  }
};

export const deletePost = async (req, res) => {
  try {
    await db.query("CALL sp_delete_post(?)", [req.params.id]);
    res.json({ message: "Post berhasil dihapus" });
  } catch (err) {
    res.status(400).json({ error: err.sqlMessage });
  }
};
