import express from "express";
import {
  createPengguna,
  updatePengguna,
  deletePengguna
} from "../controllers/pengguna.controller.js";

const router = express.Router();

router.post("/pengguna", createPengguna);
router.put("/pengguna/:id", updatePengguna);
router.delete("/pengguna/:id", deletePengguna);

export default router;
