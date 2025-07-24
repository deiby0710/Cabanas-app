import express from 'express'
import { verifyToken } from '../middlewares/verifyToken.js'
import {
    getClientes,
    postCliente,
    putCliente,
    deleteCliente
} from '../controllers/cliente.controller.js'

const router = express.Router()

router.get('/', verifyToken, getClientes)
router.post('/', verifyToken, postCliente)
router.put('/:id', verifyToken, putCliente)
router.delete('/:id', verifyToken, deleteCliente)

export default router