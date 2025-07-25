import express from 'express'
import { postReserva } from '../controllers/reserva.controller.js'
import { verifyToken } from '../middlewares/verifyToken.js'

const router = express.Router()

router.post('/', verifyToken, postReserva)

export default router