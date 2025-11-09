import db from "../config/db.js";

export const getPegawai = (req, res) => {
  db.query("SELECT * FROM pegawai", (err, result) => {
    if (err) return res.status(500).json({ message: err });
    res.json(result);
  });
};

export const addPegawai = (req, res) => {
  const { id_admin, username, password } = req.body;
  db.query("CALL tambah_pegawai_by_admin(?, ?, ?)", [id_admin, username, password], (err, result) => {
    if (err) return res.status(500).json({ message: err });
    const data = result[0][0];
    if (data.message.startsWith("ERROR")) return res.status(400).json({ message: data.message });
    res.json({ message: data.message });
  });
};

export const updatePegawai = (req, res) => {
  const { id } = req.params;
  const { id_admin, username, password } = req.body;
  db.query("CALL edit_pegawai_by_admin(?, ?, ?, ?)", [id_admin, id, username, password], (err, result) => {
    if (err) return res.status(500).json({ message: err });
    const data = result[0][0];
    if (data.message.startsWith("ERROR")) return res.status(400).json({ message: data.message });
    res.json({ message: data.message });
  });
};

export const deletePegawai = (req, res) => {
  const { id } = req.params;
  const { id_admin } = req.body;
  db.query("CALL hapus_pegawai_by_admin(?, ?)", [id_admin, id], (err, result) => {
    if (err) return res.status(500).json({ message: err });
    const data = result[0][0];
    if (data.message.startsWith("ERROR")) return res.status(400).json({ message: data.message });
    res.json({ message: data.message });
  });
};

export const getLokasi = (req, res) => {
  db.query("SELECT * FROM lokasi", (err, result) => {
    if (err) return res.status(500).json({ message: err });
    res.json(result);
  });
};

export const addLokasi = (req, res) => {
  const { id_admin, nama_lokasi, lokasi, deskripsi } = req.body;
  db.query("CALL tambah_lokasi_by_admin(?, ?, ?, ?)", [id_admin, nama_lokasi, lokasi, deskripsi], (err, result) => {
    if (err) return res.status(500).json({ message: err });
    const data = result[0][0];
    if (data.message.startsWith("ERROR")) return res.status(400).json({ message: data.message });
    res.json(data);
  });
};

export const updateLokasi = (req, res) => {
  const { id } = req.params;
  const { id_admin, nama_lokasi, lokasi, deskripsi } = req.body;
  db.query("CALL edit_lokasi_by_admin(?, ?, ?, ?, ?)", [id_admin, id, nama_lokasi, lokasi, deskripsi], (err, result) => {
    if (err) return res.status(500).json({ message: err });
    const data = result[0][0];
    if (data.message.startsWith("ERROR")) return res.status(400).json({ message: data.message });
    res.json({ message: data.message });
  });
};

export const deleteLokasi = (req, res) => {
  const { id } = req.params;
  const { id_admin } = req.body;
  db.query("CALL hapus_lokasi_by_admin(?, ?)", [id_admin, id], (err, result) => {
    if (err) return res.status(500).json({ message: err });
    const data = result[0][0];
    if (data.message.startsWith("ERROR")) return res.status(400).json({ message: data.message });
    res.json({ message: data.message });
  });
};

export const getDispenser = (req, res) => {
  const sql = `
    SELECT d.id_dispenser, d.kondisi, l.nama_lokasi, l.lokasi AS area
    FROM dispenser d
    JOIN lokasi l ON l.id_lokasi = d.id_lokasi;
  `;
  db.query(sql, (err, result) => {
    if (err) return res.status(500).json({ message: err });
    res.json(result);
  });
};

export const addDispenser = (req, res) => {
  const { id_admin, id_lokasi, kondisi } = req.body;

  db.query(
    "CALL tambah_dispenser_by_admin(?, ?, ?)",
    [id_admin, id_lokasi, kondisi],
    (err, result) => {
      if (err) return res.status(500).json({ message: err });

      const data = result[0][0]; // hasil SELECT '...' AS message
      if (data.message.startsWith("ERROR")) {
        return res.status(400).json({ message: data.message });
      }

      res.json({ message: data.message });
    }
  );
};

export const updateDispenser = (req, res) => {
  const { id } = req.params;
  const { id_admin, id_lokasi, kondisi } = req.body;
  db.query("CALL edit_dispenser_by_admin(?, ?, ?, ?)", [id_admin, id, id_lokasi, kondisi], (err, result) => {
    if (err) return res.status(500).json({ message: err });
    const data = result[0][0];
    if (data.message.startsWith("ERROR")) return res.status(400).json({ message: data.message });
    res.json({ message: data.message });
  });
};

export const deleteDispenser = (req, res) => {
  const { id } = req.params;
  const { id_admin } = req.body;
  db.query("CALL hapus_dispenser_by_admin(?, ?)", [id_admin, id], (err, result) => {
    if (err) return res.status(500).json({ message: err });
    const data = result[0][0];
    if (data.message.startsWith("ERROR")) return res.status(400).json({ message: data.message });
    res.json({ message: data.message });
  });
};