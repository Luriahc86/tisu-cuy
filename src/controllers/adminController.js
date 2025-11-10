import db from "../config/db.js";

export const getDashboard = async (req, res) => {
  try {
    const [rows] = await db.query("SELECT * FROM v_ringkasan_dashboard");
    res.status(200).json(rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Gagal memuat ringkasan dashboard" });
  }
};

export const getLogAktivitas = async (req, res) => {
  try {
    const [rows] = await db.query("SELECT * FROM v_log_aktivitas ORDER BY waktu DESC");
    res.status(200).json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Gagal memuat log aktivitas" });
  }
};
