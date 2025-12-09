import db from "../config/db.js";

export const getAllReports = async (req, res) => {
  try {
    const [rows] = await db.query(
      "SELECT * FROM v_replacement_reports ORDER BY replacement_time DESC"
    );
    res.status(200).json({
      status: "success",
      data: rows,
      message: "Reports retrieved successfully",
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      status: "error",
      message: "Failed to retrieve reports",
      detail: err.message,
    });
  }
};

export const getReportById = async (req, res) => {
  try {
    const { id } = req.params;
    const [rows] = await db.query(
      "SELECT * FROM v_replacement_reports WHERE id_report = ?",
      [id]
    );

    if (rows.length === 0) {
      return res.status(404).json({
        status: "error",
        message: "Report not found",
      });
    }

    res.status(200).json({
      status: "success",
      data: rows[0],
      message: "Report retrieved successfully",
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      status: "error",
      message: "Failed to retrieve report",
      detail: err.message,
    });
  }
};

export const createReport = async (req, res) => {
  try {
    const { id_user, id_dispenser, tissue_quantity, notes } = req.body;

    if (!id_user || !id_dispenser || typeof tissue_quantity === "undefined") {
      return res.status(400).json({
        status: "error",
        message:
          "Missing required fields: id_user, id_dispenser, tissue_quantity",
      });
    }

    await db.query("CALL sp_create_replacement_report(?, ?, ?, ?)", [
      id_user,
      id_dispenser,
      tissue_quantity,
      notes || null,
    ]);

    res.status(201).json({
      status: "success",
      message: "Report created successfully",
    });
  } catch (err) {
    console.error(err);
    const errorMsg = err.message.includes("ERROR:")
      ? err.message
      : "Failed to create report";
    res.status(400).json({
      status: "error",
      message: errorMsg,
      detail: err.message,
    });
  }
};

export const getReportsByDispenser = async (req, res) => {
  try {
    const { dispenser_id } = req.params;
    const [rows] = await db.query(
      "SELECT * FROM v_replacement_reports WHERE id_dispenser = ? ORDER BY replacement_time DESC",
      [dispenser_id]
    );

    res.status(200).json({
      status: "success",
      data: rows,
      message: "Reports retrieved successfully",
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      status: "error",
      message: "Failed to retrieve reports",
      detail: err.message,
    });
  }
};

export const getReportsByUser = async (req, res) => {
  try {
    const { user_id } = req.params;
    const [rows] = await db.query(
      "SELECT * FROM v_replacement_reports WHERE id_user = ? ORDER BY replacement_time DESC",
      [user_id]
    );

    res.status(200).json({
      status: "success",
      data: rows,
      message: "Reports retrieved successfully",
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      status: "error",
      message: "Failed to retrieve reports",
      detail: err.message,
    });
  }
};

export const getReportsByDateRange = async (req, res) => {
  try {
    const { start_date, end_date } = req.query;

    if (!start_date || !end_date) {
      return res.status(400).json({
        status: "error",
        message: "Missing required query parameters: start_date, end_date",
      });
    }

    const [rows] = await db.query(
      "SELECT * FROM v_replacement_reports WHERE DATE(replacement_time) BETWEEN ? AND ? ORDER BY replacement_time DESC",
      [start_date, end_date]
    );

    res.status(200).json({
      status: "success",
      data: rows,
      message: "Reports retrieved successfully",
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      status: "error",
      message: "Failed to retrieve reports",
      detail: err.message,
    });
  }
};
