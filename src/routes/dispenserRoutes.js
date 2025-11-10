import express from "express";
import { getDispenser, createDispenser, updateDispenser, deleteDispenser } from "../controllers/dispenserController.js";

const router = express.Router();

router.get("/", getDispenser);

router.post("/", createDispenser);

router.put("/", updateDispenser);

router.delete("/", deleteDispenser);

export default router;
