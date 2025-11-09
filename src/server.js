import express from "express";
import cors from "cors";
import morgan from "morgan";
import mysql from "mysql2";
import adminRoutes from "./routes/adminRoutes.js";
import pegawaiRoutes from "./routes/pegawaiRoutes.js";
import authRoutes from "./routes/authRoutes.js";
import dotenv from "dotenv";
dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

const db = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME
});

app.use(cors());
app.use(express.json());
app.use(morgan("dev"));

app.use("/api/admin", adminRoutes);
app.use("/api/pegawai", pegawaiRoutes);
app.use("/api/auth", authRoutes);

app.get("/", (req, res) => {
  res.json({
    message: "API is running POOOOOOK",
    description: "Sistem manajemen dispenser dan laporan tisu otomatis.",
    version: "1.0.0",
    endpoints: {
      auth: {
        login: "/api/auth/login"
      },
      admin: {
        pegawai: "/api/admin/pegawai",
        dispenser: "/api/admin/dispenser",
        lokasi: "/api/admin/lokasi"
      },
      pegawai: {
        laporan: "/api/laporan_pergantian/laporan_pergantian",
      }
    }
  });
});


app.listen(PORT, () => {
  console.log(`SERVERMU UDAH JALAN CESKUUU http://localhost:${PORT}`);
});