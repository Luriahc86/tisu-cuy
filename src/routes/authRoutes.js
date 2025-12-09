import express from "express";
import {
  register,
  login,
  logout,
  getRegistrations,
  getLogins,
} from "../controllers/authController.js";

const router = express.Router();

router.get("/register", getRegistrations);
router.post("/register", register);
router.get("/login", getLogins);
router.post("/login", login);
router.post("/logout", logout);

export default router;
