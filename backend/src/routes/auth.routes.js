import express from 'express'
import { 
    login,
    register,
    loginGoogle
 } from '../controllers/auth.controller.js'

const router = express.Router()

router.post('/login', login)
router.post('/register', register)
router.post('/google',loginGoogle)

export default router