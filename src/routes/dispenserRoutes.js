import express from "express";
import {
  getAllDispensers,
  getDispenserById,
  createDispenser,
  updateDispenser,
  deleteDispenser,
  getDispensersByLocation,
  getDispensersByStatus,
} from "../controllers/dispenserController.js";

const router = express.Router();

router.get("/", getAllDispensers);
router.get("/:id", getDispenserById);
router.post("/", createDispenser);
router.put("/:id", updateDispenser);
router.delete("/:id", deleteDispenser);

router.get("/location/:location_id", getDispensersByLocation);
router.get("/status/:status", getDispensersByStatus);

export default router;
