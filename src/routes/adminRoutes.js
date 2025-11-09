import express from "express";
import {getPegawai, addPegawai, updatePegawai, deletePegawai,getDispenser, addDispenser, updateDispenser, deleteDispenser,getLokasi, addLokasi, updateLokasi, deleteLokasi } from "../controllers/adminController.js";

const router = express.Router();

router.get("/pegawai", getPegawai);
router.post("/pegawai", addPegawai);
router.put("/pegawai/:id", updatePegawai);
router.delete("/pegawai/:id", deletePegawai);

router.get("/dispenser", getDispenser);
router.post("/dispenser", addDispenser);
router.put("/dispenser/:id", updateDispenser);
router.delete("/dispenser/:id", deleteDispenser);

router.get("/lokasi", getLokasi);
router.post("/lokasi", addLokasi);
router.put("/lokasi/:id", updateLokasi);
router.delete("/lokasi/:id", deleteLokasi);

export default router;