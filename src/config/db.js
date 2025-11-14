import mysql from "mysql2/promise";
import dotenv from "dotenv";

dotenv.config();

const db = mysql.createPool({
  host: "localhost",
  user: "root",
  password: "",
  database: "cleaning_system",
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
});

try {
  const connection = await db.getConnection();
  console.log("DATABASE BERHASIL TERHUBUNG SOD!");
  connection.release();
} catch (err) {
  console.error("DATABASE GAGAL TERHUBUNG SOD:", err.message);
}

export default db;
