import express from "express";
import dotenv from "dotenv";
import cors from "cors";
import helmet from "helmet";
import morgan from "morgan";

import authRoutes from "./routes/authRoutes.js";
import userRoutes from "./routes/userRoutes.js";
import locationRoutes from "./routes/locationRoutes.js";
import dispenserRoutes from "./routes/dispenserRoutes.js";
import reportRoutes from "./routes/laporanRoutes.js";
import dashboardRoutes from "./routes/dashboardRoutes.js";

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
    message: "🚀 API is running perfectly!",
    author: "BANG LURIAHC",
    version: "2.0.0",
    timestamp: new Date().toISOString(),
    endpoints: {
      auth: "/api/auth",
      users: "/api/users",
      locations: "/api/locations",
      dispensers: "/api/dispensers",
      reports: "/api/reports",
      dashboard: "/api/dashboard",
    },
  });
});

app.use("/api/auth", authRoutes);
app.use("/api/users", userRoutes);
app.use("/api/locations", locationRoutes);
app.use("/api/dispensers", dispenserRoutes);
app.use("/api/reports", reportRoutes);
app.use("/api/dashboard", dashboardRoutes);

app.use((req, res) => {
  res.status(404).json({
    status: "error",
    message: "Route tidak ditemukan di server",
    url: req.originalUrl,
    timestamp: new Date().toISOString(),
  });
});

app.use((err, req, res, next) => {
  console.error("❌ Error:", err);
  res.status(500).json({
    status: "error",
    message: "Terjadi kesalahan internal server",
    detail: err.message,
    timestamp: new Date().toISOString(),
  });
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log("═══════════════════════════════════════════════════════════");
  console.log("🎉 Server berjalan dengan sempurna!");
  console.log(`📍 Port: ${PORT}`);
  console.log(`🌐 Akses API: http://localhost:${PORT}`);
  console.log("═══════════════════════════════════════════════════════════");
});
