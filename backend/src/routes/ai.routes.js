// src/routes/ai.routes.js
import express from "express";
import { verifyToken } from "../middlewares/verifyToken.js";
import { handleChat } from "../controllers/ai.controller.js";

const router = express.Router();

// POST /ai/chat
router.post("/chat", verifyToken, handleChat);

export default router;