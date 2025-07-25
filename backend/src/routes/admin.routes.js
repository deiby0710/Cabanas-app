import express from 'express'
import { postAdmin } from '../controllers/admin.controller.js'

const router = express.Router()

router.post('/', postAdmin)

export default router