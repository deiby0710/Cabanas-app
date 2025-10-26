import express from 'express'
import { 
    login,
    register,
    loginGoogle,
    getMe
 } from '../controllers/auth.controller.js'
 import { verifyToken } from '../middlewares/verifyToken.js'

const router = express.Router()

router.post('/login', login)
router.post('/register', register)
router.post('/google', loginGoogle)
router.get('/getMe', verifyToken, getMe)

export default router