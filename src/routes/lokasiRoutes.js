import express from "express";
import { getLokasi, createLokasi, updateLokasi, deleteLokasi } from "../controllers/lokasiController.js";

const router = express.Router();

router.get("/", getLokasi);

router.post("/", createLokasi);

router.put("/", updateLokasi);

router.delete("/", deleteLokasi);

export default router;
