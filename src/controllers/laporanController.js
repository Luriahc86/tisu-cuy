import db from "../config/db.js";

export const getLaporan = async (req, res) => {
  try {
    const [rows] = await db.query("SELECT * FROM v_laporan_penggantian ORDER BY waktu_penggantian DESC");
    res.status(200).json(rows);
  } catch (err) {
    res.status(500).json({ message: "Gagal memuat laporan penggantian" });
  }
};

export const createLaporan = async (req, res) => {
  try {
    const { id_akun, id_dispenser, jumlah_tisu, keterangan } = req.body;
    await db.query("CALL sp_insert_laporan_penggantian(?, ?, ?, ?)", [
      id_akun,
      id_dispenser,
      jumlah_tisu,
      keterangan,
    ]);
    res.status(201).json({ message: "Laporan berhasil ditambahkan" });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};