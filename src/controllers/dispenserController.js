import db from "../config/db.js";

export const getAllDispensers = async (req, res) => {
  try {
    const [rows] = await db.query("SELECT * FROM v_dispensers");
    res.status(200).json({
      status: "success",
      data: rows,
      message: "Dispensers retrieved successfully",
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      status: "error",
      message: "Failed to retrieve dispensers",
      detail: err.message,
    });
  }
};

export const getDispenserById = async (req, res) => {
  try {
    const { id } = req.params;
    const [rows] = await db.query(
      "SELECT * FROM v_dispensers WHERE id_dispenser = ?",
      [id]
    );

    if (rows.length === 0) {
      return res.status(404).json({
        status: "error",
        message: "Dispenser not found",
      });
    }

    res.status(200).json({
      status: "success",
      data: rows[0],
      message: "Dispenser retrieved successfully",
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      status: "error",
      message: "Failed to retrieve dispenser",
      detail: err.message,
    });
  }
};

export const createDispenser = async (req, res) => {
  try {
    const {
      id_location,
      dispenser_code,
      status,
      installation_date,
      last_maintenance_date,
    } = req.body;

    if (!id_location || !dispenser_code) {
      return res.status(400).json({
        status: "error",
        message: "Missing required fields: id_location, dispenser_code",
      });
    }

    await db.query("CALL sp_create_dispenser(?, ?, ?, ?, ?)", [
      id_location,
      dispenser_code,
      status || "ACTIVE",
      installation_date || null,
      last_maintenance_date || null,
    ]);

    res.status(201).json({
      status: "success",
      message: "Dispenser created successfully",
    });
  } catch (err) {
    console.error(err);
    const errorMsg = err.message.includes("ERROR:")
      ? err.message
      : "Failed to create dispenser";
    res.status(400).json({
      status: "error",
      message: errorMsg,
      detail: err.message,
    });
  }
};

export const updateDispenser = async (req, res) => {
  try {
    const {
      id_location,
      dispenser_code,
      status,
      installation_date,
      last_maintenance_date,
    } = req.body;
    const { id } = req.params;

    if (!id || !id_location || !dispenser_code) {
      return res.status(400).json({
        status: "error",
        message:
          "Missing required fields: id_location, dispenser_code (or invalid id in URL)",
      });
    }

    await db.query("CALL sp_update_dispenser(?, ?, ?, ?, ?, ?)", [
      id,
      id_location,
      dispenser_code,
      status || "ACTIVE",
      installation_date || null,
      last_maintenance_date || null,
    ]);

    res.status(200).json({
      status: "success",
      message: "Dispenser updated successfully",
    });
  } catch (err) {
    console.error(err);
    const errorMsg = err.message.includes("ERROR:")
      ? err.message
      : "Failed to update dispenser";
    res.status(400).json({
      status: "error",
      message: errorMsg,
      detail: err.message,
    });
  }
};

export const deleteDispenser = async (req, res) => {
  try {
    const { id } = req.params;

    if (!id) {
      return res.status(400).json({
        status: "error",
        message: "Missing required parameter: id",
      });
    }

    await db.query("CALL sp_delete_dispenser(?)", [id]);

    res.status(200).json({
      status: "success",
      message: "Dispenser deleted successfully",
    });
  } catch (err) {
    console.error(err);
    const errorMsg = err.message.includes("ERROR:")
      ? err.message
      : "Failed to delete dispenser";
    res.status(400).json({
      status: "error",
      message: errorMsg,
      detail: err.message,
    });
  }
};

export const getDispensersByLocation = async (req, res) => {
  try {
    const { location_id } = req.params;
    const [rows] = await db.query(
      "SELECT * FROM v_dispensers WHERE id_location = ?",
      [location_id]
    );

    res.status(200).json({
      status: "success",
      data: rows,
      message: "Dispensers retrieved successfully",
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      status: "error",
      message: "Failed to retrieve dispensers",
      detail: err.message,
    });
  }
};

export const getDispensersByStatus = async (req, res) => {
  try {
    const { status } = req.params;
    const validStatuses = ["ACTIVE", "DAMAGED", "MAINTENANCE"];

    if (!validStatuses.includes(status.toUpperCase())) {
      return res.status(400).json({
        status: "error",
        message: `Invalid status. Must be one of: ${validStatuses.join(", ")}`,
      });
    }

    const [rows] = await db.query(
      "SELECT * FROM v_dispensers WHERE status = ?",
      [status.toUpperCase()]
    );

    res.status(200).json({
      status: "success",
      data: rows,
      message: "Dispensers retrieved successfully",
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      status: "error",
      message: "Failed to retrieve dispensers",
      detail: err.message,
    });
  }
};
