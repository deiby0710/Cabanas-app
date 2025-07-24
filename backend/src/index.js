import express from 'express'
import cors from 'cors'
import dotenv from 'dotenv'
import { PrismaClient } from '@prisma/client'
import authRoutes from './routes/auth.routes.js'
import clientesRoutes from './routes/clientes.routes.js'
import cabanasRoutes from './routes/cabanas.routes.js'
import reservasRoutes from './routes/reservas.routes.js'


// Cargamos las variables de .env
dotenv.config()

const app = express()
const prisma = new PrismaClient()
const PORT = process.env.PORT || 3000

app.use(cors())
app.use(express.json())

app.use('/api', authRoutes)
app.use('/api/clientes',clientesRoutes)
app.use('/api/cabanas',cabanasRoutes)
app.use('/api/reservas', reservasRoutes)


// app.get('/admin-test', async (req, res) => {
//     try{
//         const administradores = await prisma.Administrador.findMany()
//         res.json(administradores)
//     } catch (error) {
//         console.error('Error al consultar administradores:', error)
//         res.status(500).json({ error: 'Error consultando la base de datos' })
//     }
// })

// app.get('/protected-test', verifyToken, (req, res) => {
//   res.json({
//     message: 'Accediste a una ruta protegida 🎉',
//     admin: req.admin
//   })
// })

app.get('/', (req, res) => {
    res.send('API funcionando correctamente por: Deiby Alejandro')
})

app.listen(PORT, () => {
    console.log("El servidor esta corriendo para Deiby Alejandro")
})