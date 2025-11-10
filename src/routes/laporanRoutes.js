import express from "express";
import { getLaporan, createLaporan, deleteLaporan } from "../controllers/laporanController.js";

const router = express.Router();

router.get("/", getLaporan);
router.post("/", createLaporan);
router.delete("/", deleteLaporan);

export default router;
