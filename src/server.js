import express from "express";
import dotenv from "dotenv";
import cors from "cors";
import helmet from "helmet";
import morgan from "morgan";

// =======================
// Load Environment
// =======================
dotenv.config();

// =======================
// Init App
// =======================
const app = express();

// =======================
// Global Middlewares
// =======================
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors());
app.use(helmet());
app.use(morgan("dev"));

// =======================
// Import Routes
// =======================
import authRoutes from "./routes/authRoutes.js";
import userRoutes from "./routes/userRoutes.js";
import locationRoutes from "./routes/locationRoutes.js";
import dispenserRoutes from "./routes/dispenserRoutes.js";
import reportRoutes from "./routes/reportRoutes.js";
import dashboardRoutes from "./routes/dashboardRoutes.js";

///////////////////////////////////////////////////////////////////////////////
// =======================
// Import Routes remed
// =======================
import penggunaRoutes from "./routes/pengguna.routes.js";
import gambarRoutes from "./routes/gambar.routes.js";
import postRoutes from "./routes/post.routes.js";
import commentRoutes from "./routes/comment.routes.js";
import likeRoutes from "./routes/like.routes.js";
// =======================
// API Routes remed
// =======================
app.use("/api", penggunaRoutes);
app.use("/api", gambarRoutes);
app.use("/api", postRoutes);
app.use("/api", commentRoutes);
app.use("/api", likeRoutes);
// =======================
//////////////////////////////////////////////////////////////////////////////////
import gambarRoutes from "./routes/gambar.routes.js";
app.use("/api", gambarRoutes);
POST:"/api/gambar"
DELETE:"/api/gambar/:id"
GET:"/api/view/gambar"
/////////////////////////////////////////////////////////////////////////////////

// =======================
// Root Endpoint
// =======================
app.get("/", (req, res) => {
  res.status(200).json({
    status: "success",
    message: "🚀 API is running perfectly!",
    author: "LURIAHC",
    version: "2.0.0",
    timestamp: new Date().toISOString(),
    endpoints: {
                  pengguna: "/api/pengguna",
                  gambar: "/api/gambar",
                  posts: "/api/post",
                  comments: "/api/comment",
                  likes: "/api/like",
                  pengguna: "/api/view/pengguna",
                  gambar: "/api/view/gambar",
                  posts: "/api/view/post",
                  comments: "/api/view/comment",
                  likes: "/api/view/like"
    },
  });
});

// =======================
// API Routes
// =======================
app.use("/api/auth", authRoutes);
app.use("/api/users", userRoutes);
app.use("/api/locations", locationRoutes);
app.use("/api/dispensers", dispenserRoutes);
app.use("/api/reports", reportRoutes);
app.use("/api/dashboard", dashboardRoutes);

// =======================
// 404 Handler
// =======================
app.use((req, res) => {
  res.status(404).json({
    status: "error",
    message: "Route tidak ditemukan di server",
    url: req.originalUrl,
    timestamp: new Date().toISOString(),
  });
});

// =======================
// Global Error Handler
// =======================
app.use((err, req, res, next) => {
  console.error("❌ Internal Server Error:", err);

  res.status(500).json({
    status: "error",
    message: "Terjadi kesalahan internal server",
    detail: err.message,
    timestamp: new Date().toISOString(),
  });
});

// =======================
// Run Server
// =======================
const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log("═══════════════════════════════════════════════════════════");
  console.log("🎉 Server berjalan dengan sempurna!");
  console.log(`📍 Port: ${PORT}`);
  console.log(`🌐 API: http://localhost:${PORT}`);
  console.log("═══════════════════════════════════════════════════════════");
});
