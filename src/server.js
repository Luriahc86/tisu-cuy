import express from "express";
import dotenv from "dotenv";
import cors from "cors";
import helmet from "helmet";
import morgan from "morgan";

import laporanRoutes from "./routes/laporanRoutes.js";
import lokasiRoutes from "./routes/lokasiRoutes.js";
import dispenserRoutes from "./routes/dispenserRoutes.js";
import akunRoutes from "./routes/akunRoutes.js";
import adminRoutes from "./routes/adminRoutes.js";

dotenv.config();
const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors());
app.use(helmet());
app.use(morgan("dev"));

app.get("/", (req, res) => {
  res.status(200).json({
    status: "success",
    message: "DAMNNNN API is running BRUUUUHHHH ",
    author: "BANG LURIAHC",
    version: "1.0.0",
    timestamp: new Date().toISOString(),
  });
});

app.use("/api/admin", adminRoutes);
app.use("/api/akun", akunRoutes);
app.use("/api/lokasi", lokasiRoutes);
app.use("/api/dispenser", dispenserRoutes);
app.use("/api/laporan", laporanRoutes);

app.use((req, res) => {
  res.status(404).json({
    status: "error",
    message: "Route tidak ditemukan di server",
    url: req.originalUrl,
  });
});

app.use((err, req, res, next) => {
  console.error(" Terjadi error:", err);
  res.status(500).json({
    status: "error",
    message: "Terjadi kesalahan internal server ",
    detail: err.message,
  });
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log("========================================");
  console.log(` Server berjalan di port ${PORT}`);
  console.log(` Akses API: http://localhost:${PORT}`);
  console.log("========================================");
});
