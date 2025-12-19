import db from "../config/db.js";

// Controller: hapus comment
exports.deleteComment = async (req, res) => {
  const { id } = req.params;

  try {
    // Panggil stored procedure
    await db.query(
      "CALL sp_delete_comment_transaction(?)",
      [id]
    );

    res.status(200).json({
      message: "Comment berhasil dihapus"
    });

  } catch (error) {
    console.error("Delete comment error:", error);

    res.status(500).json({
      message: "Gagal menghapus comment",
      error: error.message
    });
  }
};
