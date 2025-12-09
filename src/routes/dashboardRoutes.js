import express from "express";
import {
  getDashboardSummary,
  getActivityLogs,
  getLoginHistory,
  getDispenserStatusOverview,
  getUserStatistics,
  getTodayReportSummary,
  getTransactions,
  getTransactionById,
  getActivitySummary,
} from "../controllers/dashboardController.js";

const router = express.Router();

router.get("/summary", getDashboardSummary);
router.get("/dispenser-status", getDispenserStatusOverview);
router.get("/user-stats", getUserStatistics);
router.get("/today-reports", getTodayReportSummary);
router.get("/activity-logs", getActivityLogs);
router.get("/transactions", getTransactions);
router.get("/transactions/:id", getTransactionById);
router.get("/activity-summary", getActivitySummary);
router.get("/login-history", getLoginHistory);

export default router;
