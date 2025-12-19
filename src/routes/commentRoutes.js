import express from "express";
import express from "express";
import { deleteComment } from "../controllers/commentController.js";

const router = express.Router();

// DELETE comment by id
router.delete("/:id", deleteComment);

export default router;