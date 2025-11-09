import db from "../config/db.js";

export const login = (req, res) => {
  const { username, password } = req.body;
  db.query("CALL login_admin(?, ?)", [username, password], (err, result) => {
    if (err) return res.status(500).json({ message: err });
    const data = result[0][0];
    if (data.message.startsWith("ERROR")) {
      return res.status(401).json({ message: data.message });
    }
    res.json(data);
  });
};