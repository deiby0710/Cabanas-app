import express from 'express'
import { verifyToken } from '../middlewares/verifyToken.js'
import {
    createCustomer,
    listCustomers,
    getCustomerById,
    updateCustomer,
    deleteCustomer
} from '../controllers/cliente.controller.js'

const router = express.Router()

router.post('/create', verifyToken, createCustomer);
router.get('/:orgId', verifyToken, listCustomers);
router.get('/:orgId/:clienteId', verifyToken, getCustomerById);
router.put('/:orgId/:clienteId', verifyToken, updateCustomer);
router.delete('/:orgId/:clienteId', verifyToken, deleteCustomer);

export default router