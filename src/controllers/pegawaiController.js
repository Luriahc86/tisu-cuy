import db from "../config/db.js";

export const laporan_pergantian = (req, res) => {
  const { id_pegawai, id_dispenser, jumlah_tisu, keterangan } = req.body;

  db.query(
    "CALL laporan_penggantian_insert(?, ?, ?, ?)",
    [id_dispenser, id_pegawai, jumlah_tisu, keterangan],
    (err, result) => {
      if (err) return res.status(500).json({ message: err });

      const data = result[0][0];
      if (data.message.startsWith("ERROR")) {
        return res.status(400).json({ message: data.message });
      }

      res.json({ message: data.message });
    }
  );
};