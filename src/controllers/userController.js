import db from "../config/db.js";

export const getAllUsers = async (req, res) => {
  try {
    const [rows] = await db.query("SELECT * FROM v_users");
    res.status(200).json({
      status: "success",
      data: rows,
      message: "Users retrieved successfully",
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      status: "error",
      message: "Failed to retrieve users",
      detail: err.message,
    });
  }
};

export const getUserById = async (req, res) => {
  try {
    const { id } = req.params;
    const [rows] = await db.query("SELECT * FROM v_users WHERE id_user = ?", [
      id,
    ]);

    if (rows.length === 0) {
      return res.status(404).json({
        status: "error",
        message: "User not found",
      });
    }

    res.status(200).json({
      status: "success",
      data: rows[0],
      message: "User retrieved successfully",
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      status: "error",
      message: "Failed to retrieve user",
      detail: err.message,
    });
  }
};

export const createUser = async (req, res) => {
  try {
    const {
      id_user_creator,
      username,
      password,
      role,
      full_name,
      email,
      phone,
    } = req.body;

    if (!id_user_creator || !username || !password || !role) {
      return res.status(400).json({
        status: "error",
        message:
          "Missing required fields: id_user_creator, username, password, role",
      });
    }

    await db.query("CALL sp_create_user(?, ?, ?, ?, ?, ?, ?)", [
      id_user_creator,
      username,
      password,
      role,
      full_name || null,
      email || null,
      phone || null,
    ]);

    res.status(201).json({
      status: "success",
      message: "User created successfully",
    });
  } catch (err) {
    console.error(err);
    const errorMsg = err.message.includes("ERROR:")
      ? err.message
      : "Failed to create user";
    res.status(400).json({
      status: "error",
      message: errorMsg,
      detail: err.message,
    });
  }
};

export const updateUser = async (req, res) => {
  try {
    const {
      id_user_creator,
      id_user_target,
      username,
      password,
      role,
      full_name,
      email,
      phone,
    } = req.body;

    if (!id_user_creator || !id_user_target || !username || !role) {
      return res.status(400).json({
        status: "error",
        message:
          "Missing required fields: id_user_creator, id_user_target, username, role",
      });
    }

    await db.query("CALL sp_update_user(?, ?, ?, ?, ?, ?, ?, ?)", [
      id_user_creator,
      id_user_target,
      username,
      password || "",
      role,
      full_name || null,
      email || null,
      phone || null,
    ]);

    res.status(200).json({
      status: "success",
      message: "User updated successfully",
    });
  } catch (err) {
    console.error(err);
    const errorMsg = err.message.includes("ERROR:")
      ? err.message
      : "Failed to update user";
    res.status(400).json({
      status: "error",
      message: errorMsg,
      detail: err.message,
    });
  }
};

export const deleteUser = async (req, res) => {
  try {
    const { id } = req.params;
    const { id_user_creator } = req.body;

    if (!id) {
      return res.status(400).json({
        status: "error",
        message: "Missing required parameter: id",
      });
    }

    if (!id_user_creator) {
      return res.status(400).json({
        status: "error",
        message: "Missing required field: id_user_creator",
      });
    }

    await db.query("CALL sp_delete_user(?, ?)", [id_user_creator, id]);

    res.status(200).json({
      status: "success",
      message: "User deleted successfully",
    });
  } catch (err) {
    console.error(err);
    const errorMsg = err.message.includes("ERROR:")
      ? err.message
      : "Failed to delete user";
    res.status(400).json({
      status: "error",
      message: errorMsg,
      detail: err.message,
    });
  }
};
