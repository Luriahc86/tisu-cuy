import db from "../config/db.js";

export const register = async (req, res) => {
  try {
    const { username, password, role, full_name, email, phone } = req.body;

    if (!username || !password || !role) {
      return res.status(400).json({
        status: "error",
        message: "Missing required fields: username, password, role",
      });
    }

    const [result] = await db.query(
      "CALL sp_register_user(?, ?, ?, ?, ?, ?, @p_status, @p_id_user)",
      [
        username,
        password,
        role,
        full_name || null,
        email || null,
        phone || null,
      ]
    );

    const [statusResult] = await db.query(
      "SELECT @p_status AS status, @p_id_user AS id_user"
    );

    const { status, id_user } = statusResult[0];

    if (status.includes("ERROR")) {
      return res.status(400).json({
        status: "error",
        message: status.replace("ERROR: ", ""),
      });
    }

    res.status(201).json({
      status: "success",
      message: status.replace("SUCCESS: ", ""),
      data: { id_user },
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      status: "error",
      message: "Registration failed",
      detail: err.message,
    });
  }
};

export const login = async (req, res) => {
  try {
    const { username, password } = req.body;

    if (!username || !password) {
      return res.status(400).json({
        status: "error",
        message: "Missing required fields: username, password",
      });
    }

    const [result] = await db.query(
      "CALL sp_login_user(?, ?, @p_status, @p_id_user, @p_role, @p_full_name, @p_email)",
      [username, password]
    );

    const [statusResult] = await db.query(
      "SELECT @p_status AS status, @p_id_user AS id_user, @p_role AS role, @p_full_name AS full_name, @p_email AS email"
    );

    const { status, id_user, role, full_name, email } = statusResult[0];

    if (status.includes("ERROR")) {
      return res.status(401).json({
        status: "error",
        message: status.replace("ERROR: ", ""),
      });
    }

    res.status(200).json({
      status: "success",
      message: status.replace("SUCCESS: ", ""),
      data: {
        id_user,
        username,
        role,
        full_name,
        email,
      },
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      status: "error",
      message: "Login failed",
      detail: err.message,
    });
  }
};

export const logout = async (req, res) => {
  try {
    res.status(200).json({
      status: "success",
      message: "Logout successful",
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      status: "error",
      message: "Logout failed",
      detail: err.message,
    });
  }
};

export const getRegistrations = async (req, res) => {
  try {
    const limit = parseInt(req.query.limit) || 50;
    const offset = parseInt(req.query.offset) || 0;
    const role = req.query.role || null;
    const startDate = req.query.start_date || null;
    const endDate = req.query.end_date || null;

    let query = `
      SELECT 
        id_user,
        username,
        role,
        full_name,
        email,
        phone,
        is_active,
        created_at
      FROM users
      WHERE 1=1
    `;
    const params = [];

    if (role) {
      query += " AND role = ?";
      params.push(role);
    }

    if (startDate) {
      query += " AND DATE(created_at) >= ?";
      params.push(startDate);
    }

    if (endDate) {
      query += " AND DATE(created_at) <= ?";
      params.push(endDate);
    }

    query += " ORDER BY created_at DESC LIMIT ? OFFSET ?";
    params.push(limit, offset);

    const [rows] = await db.query(query, params);

    res.status(200).json({
      status: "success",
      data: rows,
      pagination: {
        limit,
        offset,
        total: rows.length,
      },
      message: "Registrations retrieved successfully",
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      status: "error",
      message: "Failed to retrieve registrations",
      detail: err.message,
    });
  }
};

export const getLogins = async (req, res) => {
  try {
    const limit = parseInt(req.query.limit) || 50;
    const offset = parseInt(req.query.offset) || 0;
    const userId = req.query.user_id || null;
    const username = req.query.username || null;
    const role = req.query.role || null;
    const startDate = req.query.start_date || null;
    const endDate = req.query.end_date || null;

    let query = `
      SELECT 
        id_login,
        id_user,
        username,
        role,
        login_time
      FROM login_history
      WHERE 1=1
    `;
    const params = [];

    if (userId) {
      query += " AND id_user = ?";
      params.push(userId);
    }

    if (username) {
      query += " AND username = ?";
      params.push(username);
    }

    if (role) {
      query += " AND role = ?";
      params.push(role);
    }

    if (startDate) {
      query += " AND DATE(login_time) >= ?";
      params.push(startDate);
    }

    if (endDate) {
      query += " AND DATE(login_time) <= ?";
      params.push(endDate);
    }

    query += " ORDER BY login_time DESC LIMIT ? OFFSET ?";
    params.push(limit, offset);

    const [rows] = await db.query(query, params);

    res.status(200).json({
      status: "success",
      data: rows,
      pagination: {
        limit,
        offset,
        total: rows.length,
      },
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
