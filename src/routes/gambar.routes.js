import express from "express";
import { createGambar, deleteGambar } from "../controllers/gambarController.js";

const router = express.Router();

router.post("/gambar", createGambar);
router.delete("/gambar/:id", deleteGambar);

export default router;
