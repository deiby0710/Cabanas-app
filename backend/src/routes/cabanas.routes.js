import express from 'express'
import { verifyToken } from '../middlewares/verifyToken.js'
import { 
    getCabinById,
    createCabin,
    listCabins,
    updateCabin,
    deleteCabin
 } from '../controllers/cabana.controller.js'

const router = express.Router()

router.get('/:orgId/:cabanaId', verifyToken, getCabinById);
router.get('/:orgId', verifyToken, listCabins);
router.post('/create', verifyToken, createCabin);
router.put('/:orgId/:cabanaId', verifyToken, updateCabin);
router.delete('/:orgId/:cabanaId', verifyToken, deleteCabin);

export default router