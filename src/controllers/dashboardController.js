import db from "../config/db.js";

export const getDashboardSummary = async (req, res) => {
  try {
    const [rows] = await db.query("SELECT * FROM v_dashboard_summary");

    res.status(200).json({
      status: "success",
      data: rows[0],
      message: "Dashboard summary retrieved successfully",
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      status: "error",
      message: "Failed to retrieve dashboard summary",
      detail: err.message,
    });
  }
};

export const getActivityLogs = async (req, res) => {
  try {
    const limit = parseInt(req.query.limit) || 50;
    const offset = parseInt(req.query.offset) || 0;
    const actionType = req.query.action_type || null;
    const resourceType = req.query.resource_type || null;
    const startDate = req.query.start_date || null;
    const endDate = req.query.end_date || null;
    const userId = req.query.user_id || null;

    const [rows] = await db.query(
      "CALL sp_get_transactions(?, ?, ?, ?, ?, ?, ?)",
      [limit, offset, actionType, resourceType, startDate, endDate, userId]
    );

    res.status(200).json({
      status: "success",
      data: rows[0],
      pagination: {
        limit,
        offset,
        total: rows[0].length,
      },
      message: "Activity logs retrieved successfully",
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      status: "error",
      message: "Failed to retrieve activity logs",
      detail: err.message,
    });
  }
};

export const getTransactions = async (req, res) => {
  try {
    const limit = parseInt(req.query.limit) || 100;
    const offset = parseInt(req.query.offset) || 0;
    const actionType = req.query.action_type || null;
    const resourceType = req.query.resource_type || null;
    const startDate = req.query.start_date || null;
    const endDate = req.query.end_date || null;
    const userId = req.query.user_id || null;

    const [rows] = await db.query(
      "CALL sp_get_transactions(?, ?, ?, ?, ?, ?, ?)",
      [limit, offset, actionType, resourceType, startDate, endDate, userId]
    );

    res.status(200).json({
      status: "success",
      data: rows[0],
      pagination: {
        limit,
        offset,
        records_returned: rows[0].length,
      },
      message: "Transactions retrieved successfully",
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      status: "error",
      message: "Failed to retrieve transactions",
      detail: err.message,
    });
  }
};

export const getTransactionById = async (req, res) => {
  try {
    const { id } = req.params;

    const [rows] = await db.query("CALL sp_get_transaction_by_id(?)", [id]);

    if (!rows[0] || rows[0].length === 0) {
      return res.status(404).json({
        status: "error",
        message: "Transaction not found",
      });
    }

    res.status(200).json({
      status: "success",
      data: rows[0][0],
      message: "Transaction retrieved successfully",
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      status: "error",
      message: "Failed to retrieve transaction",
      detail: err.message,
    });
  }
};

export const getActivitySummary = async (req, res) => {
  try {
    const days = req.query.days || 7;

    const [rows] = await db.query("CALL sp_get_activity_summary(?)", [days]);

    res.status(200).json({
      status: "success",
      data: rows[0],
      summary_period: `Last ${days} days`,
      message: "Activity summary retrieved successfully",
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      status: "error",
      message: "Failed to retrieve activity summary",
      detail: err.message,
    });
  }
};

export const getLoginHistory = async (req, res) => {
  try {
    const limit = req.query.limit || 50;
    const [rows] = await db.query("SELECT * FROM v_login_history LIMIT ?", [
      parseInt(limit),
    ]);

    res.status(200).json({
      status: "success",
      data: rows,
      message: "Login history retrieved successfully",
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      status: "error",
      message: "Failed to retrieve login history",
      detail: err.message,
    });
  }
};

export const getDispenserStatusOverview = async (req, res) => {
  try {
    const [summary] = await db.query("SELECT * FROM v_dashboard_summary");

    res.status(200).json({
      status: "success",
      data: {
        total: summary[0].total_dispensers,
        active: summary[0].active_dispensers,
        damaged: summary[0].damaged_dispensers,
        maintenance: summary[0].maintenance_dispensers,
      },
      message: "Dispenser status overview retrieved successfully",
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      status: "error",
      message: "Failed to retrieve dispenser status overview",
      detail: err.message,
    });
  }
};

export const getUserStatistics = async (req, res) => {
  try {
    const [summary] = await db.query("SELECT * FROM v_dashboard_summary");

    res.status(200).json({
      status: "success",
      data: {
        total_admins: summary[0].total_admins,
        total_staff: summary[0].total_staff,
      },
      message: "User statistics retrieved successfully",
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      status: "error",
      message: "Failed to retrieve user statistics",
      detail: err.message,
    });
  }
};

export const getTodayReportSummary = async (req, res) => {
  try {
    const [summary] = await db.query("SELECT * FROM v_dashboard_summary");

    res.status(200).json({
      status: "success",
      data: {
        reports_today: summary[0].reports_today,
        last_replacement_time: summary[0].last_replacement_time,
      },
      message: "Today's report summary retrieved successfully",
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      status: "error",
      message: "Failed to retrieve today's report summary",
      detail: err.message,
    });
  }
};
