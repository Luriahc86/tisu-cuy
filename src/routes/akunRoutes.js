import express from "express";
import { getAkun, createAkun, updateAkun, deleteAkun} from "../controllers/akunController.js";

const router = express.Router();

router.get("/", getAkun);

router.post("/", createAkun);

router.put("/", updateAkun);

router.delete("/", deleteAkun);

export default router;

