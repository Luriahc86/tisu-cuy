import mysql from "mysql2";

const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: "cleaning_system",
});

db.connect(err => {
  if (err) {
    console.error("DATABASE GAGAL TERHUBUNG SOD:", err);
  } else {
    console.log("DATANBASE BERHASIL TERHUBUNG SOD");
  }
});

export default db;
