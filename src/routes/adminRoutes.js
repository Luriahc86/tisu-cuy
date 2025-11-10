import express from "express";
import { getDashboard, getLogAktivitas } from "../controllers/adminController.js";

const router = express.Router();

router.get("/dashboard", getDashboard);

router.get("/log", getLogAktivitas);

export default router;
