import db from "../config/db.js";

export const getLokasi = async (req, res) => {
  try {
    const [rows] = await db.query("SELECT * FROM v_lokasi");
    res.status(200).json(rows);
  } catch (err) {
    res.status(500).json({ message: "Gagal memuat data lokasi" });
  }
};

export const createLokasi = async (req, res) => {
  try {
    const { id_akun, nama_lokasi, deskripsi } = req.body;
    await db.query("CALL sp_insert_lokasi(?, ?, ?)", [id_akun, nama_lokasi, deskripsi]);
    res.status(201).json({ message: "Lokasi berhasil ditambahkan" });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

export const updateLokasi = async (req, res) => {
  try {
    const { id_akun, id_lokasi, nama_lokasi, deskripsi } = req.body;
    await db.query("CALL sp_update_lokasi(?, ?, ?, ?)", [id_akun, id_lokasi, nama_lokasi, deskripsi]);
    res.status(200).json({ message: "Lokasi berhasil diupdate" });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

export const deleteLokasi = async (req, res) => {
  try {
    const { id_akun, id_lokasi } = req.body;
    await db.query("CALL sp_delete_lokasi(?, ?)", [id_akun, id_lokasi]);
    res.status(200).json({ message: "Lokasi berhasil dihapus" });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};
