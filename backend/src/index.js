import express from 'express'
import cors from 'cors'
import dotenv from 'dotenv'
import { PrismaClient } from '@prisma/client'
import authRoutes from './routes/auth.routes.js'
import clientesRoutes from './routes/clientes.routes.js'
import cabanasRoutes from './routes/cabanas.routes.js'
import reservasRoutes from './routes/reservas.routes.js'
import adminRoutes from './routes/admin.routes.js'
import organizationRoutes from './routes/organization.routes.js'


// Cargamos las variables de .env
dotenv.config()

const app = express()
const prisma = new PrismaClient()
const PORT = process.env.PORT || 3000

app.use(cors())
app.use(express.json())

app.use('/auth', authRoutes)
app.use('/organization', organizationRoutes)
app.use('/api/admin', adminRoutes)
app.use('/api/clientes',clientesRoutes)
app.use('/api/cabanas',cabanasRoutes)
app.use('/api/reservas', reservasRoutes)

app.get('/', (req, res) => {
    res.send('API funcionando correctamente por: Deiby Alejandro')
})

app.listen(PORT, () => {
    console.log("El servidor esta corriendo para Deiby Alejandro")
})