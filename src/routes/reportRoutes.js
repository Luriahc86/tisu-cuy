import express from "express";
import {
  getAllReports,
  getReportById,
  createReport,
  updateReport,
  deleteReport,
  getReportsByDispenser,
  getReportsByUser,
  getReportsByDateRange,
} from "../controllers/reportController.js";

const router = express.Router();

router.get("/", getAllReports);

router.get("/:id", getReportById);

router.post("/", createReport);

router.get("/dispenser/:dispenser_id", getReportsByDispenser);

router.get("/user/:user_id", getReportsByUser);

router.get("/filter/date", getReportsByDateRange);

export default router;
