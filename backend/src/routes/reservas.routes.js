import express from 'express'
import { postReserva, getReservas, getReservasById, putReserva, deleteReserva } from '../controllers/reserva.controller.js'
import { verifyToken } from '../middlewares/verifyToken.js'

const router = express.Router()

router.post('/', verifyToken, postReserva)
router.get('/', verifyToken, getReservas)
router.get('/:id', verifyToken, getReservasById)
router.put('/:id', verifyToken, putReserva)
router.delete('/:id', verifyToken, deleteReserva)

export default router