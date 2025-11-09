import express from "express";
import { laporan_pergantian } from "../controllers/pegawaiController.js";

const router = express.Router();

router.post("/laporan_pergantian", laporan_pergantian);

export default router;
