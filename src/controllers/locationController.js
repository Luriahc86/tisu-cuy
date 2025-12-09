import db from "../config/db.js";

export const getAllLocations = async (req, res) => {
  try {
    const [rows] = await db.query("SELECT * FROM v_locations");
    res.status(200).json({
      status: "success",
      data: rows,
      message: "Locations retrieved successfully",
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      status: "error",
      message: "Failed to retrieve locations",
      detail: err.message,
    });
  }
};

export const getLocationById = async (req, res) => {
  try {
    const { id } = req.params;
    const [rows] = await db.query(
      "SELECT * FROM v_locations WHERE id_location = ?",
      [id]
    );

    if (rows.length === 0) {
      return res.status(404).json({
        status: "error",
        message: "Location not found",
      });
    }

    res.status(200).json({
      status: "success",
      data: rows[0],
      message: "Location retrieved successfully",
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      status: "error",
      message: "Failed to retrieve location",
      detail: err.message,
    });
  }
};

export const createLocation = async (req, res) => {
  try {
    const { id_user, location_name, description, address } = req.body;

    console.log("📥 createLocation request body:", req.body);
    console.log("📤 Calling sp_create_location with:", [
      id_user,
      location_name,
      description || null,
      address || null,
    ]);

    if (!location_name) {
      return res.status(400).json({
        status: "error",
        message: "Missing required fields: location_name",
      });
    }

    const result = await db.query("CALL sp_create_location(?, ?, ?)", [
      location_name,
      description || null,
      address || null,
    ]);

    console.log("✅ Procedure executed successfully:", result);

    res.status(201).json({
      status: "success",
      message: "Location created successfully",
    });
  } catch (err) {
    console.error("❌ Error in createLocation:", {
      message: err.message,
      code: err.code,
      errno: err.errno,
      sqlState: err.sqlState,
      sql: err.sql,
      stack: err.stack,
    });

    const errorMsg = err.message.includes("ERROR:")
      ? err.message
      : "Failed to create location";

    res.status(400).json({
      status: "error",
      message: errorMsg,
      detail: err.message,
      code: err.code,
    });
  }
};

export const updateLocation = async (req, res) => {
  try {
    const { location_name, description, address } = req.body;
    const { id } = req.params;

    if (!id || !location_name) {
      return res.status(400).json({
        status: "error",
        message:
          "Missing required fields: location_name (or invalid id in URL)",
      });
    }

    await db.query("CALL sp_update_location(?, ?, ?, ?)", [
      id,
      location_name,
      description || null,
      address || null,
    ]);

    res.status(200).json({
      status: "success",
      message: "Location updated successfully",
    });
  } catch (err) {
    console.error(err);
    const errorMsg = err.message.includes("ERROR:")
      ? err.message
      : "Failed to update location";
    res.status(400).json({
      status: "error",
      message: errorMsg,
      detail: err.message,
    });
  }
};

export const deleteLocation = async (req, res) => {
  try {
    const { id } = req.params;

    if (!id) {
      return res.status(400).json({
        status: "error",
        message: "Missing required parameter: id",
      });
    }

    await db.query("CALL sp_delete_location(?)", [id]);

    res.status(200).json({
      status: "success",
      message: "Location deleted successfully",
    });
  } catch (err) {
    console.error(err);
    const errorMsg = err.message.includes("ERROR:")
      ? err.message
      : "Failed to delete location";
    res.status(400).json({
      status: "error",
      message: errorMsg,
      detail: err.message,
    });
  }
};
