import express from 'express';
import { verifyToken } from '../middlewares/verifyToken.js';
import { 
    createOrganization,
    joinOrganization
 } from '../controllers/organization.controller.js';

const router = express.Router();

router.post('/create', verifyToken, createOrganization)
router.post('/join', verifyToken, joinOrganization)

export default router;