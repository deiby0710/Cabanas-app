import express from 'express'
import { 
    createReservation,
    listReservations,
    getReservationById,
    updateReservation,
    deleteReservation
 } from '../controllers/reserva.controller.js'
import { verifyToken } from '../middlewares/verifyToken.js'

const router = express.Router()

router.post('/create', verifyToken, createReservation);
router.get('/:orgId', verifyToken, listReservations);
router.get('/:orgId/:reservaId', verifyToken, getReservationById);
router.put('/:orgId/:reservaId', verifyToken, updateReservation);
router.delete('/:orgId/:reservaId', verifyToken, deleteReservation);


export default router