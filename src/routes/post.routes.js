import express from "express";
import {
  createPost,
  deletePost
} from "../controllers/post.controller.js";

const router = express.Router();

router.post("/post", createPost);
router.delete("/post/:id", deletePost);

export default router;
