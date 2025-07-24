import express from 'express'
import { verifyToken } from '../middlewares/verifyToken.js'
import { 
    getCabana,
    postCabana,
    putCabana,
    deleteCabana
 } from '../controllers/cabana.controller.js'

const router = express.Router()

router.get('/', verifyToken, getCabana)
router.post('/', verifyToken, postCabana)
router.put('/:id', verifyToken, putCabana)
router.delete('/:id', verifyToken, deleteCabana)

export default router