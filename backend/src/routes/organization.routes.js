import express from 'express';
import { verifyToken } from '../middlewares/verifyToken.js';
import { 
    createOrganization,
    joinOrganization,
    listMyOrganizations,
    getOrganizationById,
    updateOrganizationName,
    deleteOrganization,
    updateMemberRole,
    listOrganizationMembers,
    removeMemberFromOrg,
    getOutUser
 } from '../controllers/organization.controller.js';

const router = express.Router();

router.post('/create', verifyToken, createOrganization)
router.post('/join', verifyToken, joinOrganization)
router.get('/my', verifyToken, listMyOrganizations)
router.get('/:id', verifyToken, getOrganizationById)
router.get('/:id/members', verifyToken, listOrganizationMembers)
router.put('/:id', verifyToken, updateOrganizationName)
router.delete('/:id', verifyToken, deleteOrganization)
router.delete('/:orgId/members/:adminId', verifyToken, removeMemberFromOrg);
router.delete('/:id/user/:userId', verifyToken, getOutUser)
router.put('/:id/member/:adminId', verifyToken, updateMemberRole)

export default router;