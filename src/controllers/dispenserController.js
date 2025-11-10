import db from "../config/db.js";

export const getDispenser = async (req, res) => {
  try {
    const [rows] = await db.query("SELECT * FROM v_dispenser");
    res.status(200).json(rows);
  } catch (err) {
    res.status(500).json({ message: "Gagal memuat data dispenser" });
  }
};

export const createDispenser = async (req, res) => {
  try {
    const { id_akun, id_lokasi, kode_dispenser, kondisi, tanggal_pasang } = req.body;
    await db.query("CALL sp_insert_dispenser(?, ?, ?, ?, ?)", [
      id_akun,
      id_lokasi,
      kode_dispenser,
      kondisi,
      tanggal_pasang,
    ]);
    res.status(201).json({ message: "Dispenser berhasil ditambahkan" });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

export const updateDispenser = async (req, res) => {
  try {
    const { id_akun, id_dispenser, id_lokasi, kode_dispenser, kondisi, tanggal_pasang } = req.body;
    await db.query("CALL sp_update_dispenser(?, ?, ?, ?, ?, ?)", [
      id_akun,
      id_dispenser,
      id_lokasi,
      kode_dispenser,
      kondisi,
      tanggal_pasang,
    ]);
    res.status(200).json({ message: "Dispenser berhasil diperbarui" });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

export const deleteDispenser = async (req, res) => {
  try {
    const { id_akun, id_dispenser } = req.body;
    await db.query("CALL sp_delete_dispenser(?, ?)", [id_akun, id_dispenser]);
    res.status(200).json({ message: "Dispenser berhasil dihapus" });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};
