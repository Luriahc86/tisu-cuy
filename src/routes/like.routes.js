import express from "express";
import { createLike } from "../controllers/like.controller.js";

const router = express.Router();

router.post("/like", createLike);

export default router;
